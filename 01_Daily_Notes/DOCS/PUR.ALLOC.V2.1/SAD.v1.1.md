# TÀI LIỆU PHÂN TÍCH & THIẾT KẾ HỆ THỐNG

## PURCHASING – MATERIAL ALLOCATION AUTOMATION v2.1

**Phạm vi thiết kế:** Workflow 2 – Điều chuyển NPL khác Style / khác Article / khác Lot / khác nguồn nhập
**Hai activity nghiệp vụ lõi:** **UNRESERVE → ALLOCATION**

Artifact kỹ thuật hiện tại xác nhận hệ thống đang vận hành theo mô hình tuần tự trên từng record: tìm Excess/Shortage, thực hiện Unreserve trước, lưu checkpoint `unreserve_completed`, sau đó đọc lại dữ liệu và thực hiện Allocation. Checkpoint này cho phép resume mà không chạy lại Unreserve. 

Transcript khảo sát cũng cho thấy Workflow 2 được xây để bao phủ các trường hợp phức tạp hơn như cùng Style khác Lot, khác Style, PO có nhiều lần nhập/GRN, PO có nhiều mã NPL và yêu cầu phải chọn đúng nguồn/kho. 

---

# 1. TÓM TẮT THIẾT KẾ

## 1.1. Business concept

Hệ thống không thực hiện một giao dịch “transfer” duy nhất.

Một lần điều chuyển thực chất gồm **hai transaction độc lập nhưng liên kết**:

```text
SOURCE                                             DESTINATION

Stock đang gắn với OC nguồn
            │
            ▼
╔══════════════════════╗
║      UNRESERVE       ║
║ Giải phóng stock     ║
╚══════════╤═══════════╝
           │
           ▼
   CHECKPOINT + VERIFY
           │
           ▼
       Free Stock
           │
           ▼
╔══════════════════════╗
║      ALLOCATION      ║
║ Gắn stock vào OC     ║
║ đang thiếu           ║
╚══════════╤═══════════╝
           │
           ▼
    Final Verification
```

---

# 2. NGUYÊN TẮC THIẾT KẾ

| ID  | Nguyên tắc                                                                           |
| --- | ------------------------------------------------------------------------------------ |
| P01 | Unreserve luôn thực hiện trước Allocation                                            |
| P02 | Allocation không được chạy nếu Unreserve chưa được xác nhận thành công               |
| P03 | Sau Unreserve phải lưu checkpoint                                                    |
| P04 | Allocation phải đọc lại dữ liệu WFX mới nhất                                         |
| P05 | Không sử dụng snapshot cũ sau Unreserve                                              |
| P06 | Không cho phép fuzzy match Source PO / Site / Article / GRN / Lot                    |
| P07 | Người dùng không nhập PO đích                                                        |
| P08 | Người dùng không nhập OC đích                                                        |
| P09 | Người dùng chỉ định **Style đích**; hệ thống tự tìm các OC thiếu                     |
| P10 | **Partial Quantity không được hỗ trợ trong v2.1**                                    |
| P11 | User không nhập số lượng điều chuyển thủ công                                        |
| P12 | Làm tròn cuộn chỉ dựa trên **Inhouse**                                               |
| P13 | Site nguồn phải được xác định chính xác                                              |
| P14 | Một Style không được coi là completed chỉ vì một Article/Lot đã chạy                 |
| P15 | Mỗi transaction phải có audit trail Source → Unreserve → Destination OC → Allocation |

Artifact hiện tại đã có cơ chế xử lý tuần tự, xác nhận save và dừng toàn run khi một Allocation save trở nên “uncertain”; đây là pattern an toàn cần giữ lại. 

---

# 3. SCOPE

## 3.1. In Scope

| Business Case                          | v2.1 |
| -------------------------------------- | ---: |
| Cùng Style – khác Lot                  |    ✅ |
| Khác Style                             |    ✅ |
| Khác Article / mã NPL                  |    ✅ |
| Một PO nguồn có nhiều Style            |    ✅ |
| Một PO có nhiều Article                |    ✅ |
| Một PO được nhập nhiều lần / nhiều GRN |    ✅ |
| Một Article có nhiều Lot               |    ✅ |
| NPL tồn tại tại nhiều Site             |    ✅ |
| Một Style đích có nhiều OC             |    ✅ |
| Tự xác định OC thiếu                   |    ✅ |
| Batch nhiều dòng nguồn                 |    ✅ |
| Checkpoint và resume                   |    ✅ |
| Human review khi nguồn ambiguous       |    ✅ |
| Làm tròn cuộn theo Inhouse             |    ✅ |

Transcript cho thấy một PO có thể được nhập nhiều lần và một PO có thể chứa nhiều mã NPL, vì vậy chỉ dùng PO để xác định source không phải lúc nào cũng đủ. 

---

## 3.2. Out of Scope

| Case                                                    | Trạng thái   |
| ------------------------------------------------------- | ------------ |
| Partial Quantity do user nhập                           | ❌            |
| User chọn số lượng muốn mượn                            | ❌            |
| PO đích                                                 | ❌ Không nhập |
| OC đích                                                 | ❌ Không nhập |
| Tự fallback sang Site khác khi Source Site không có tồn | ❌            |
| Fuzzy matching Article/Lot/GRN                          | ❌            |
| Tự điều chỉnh khi dữ liệu WFX thay đổi sau approval     | ❌            |
| Cross-UOM conversion chưa có rule                       | ❌            |
| Auto reversal khi Allocation lỗi                        | Chưa chốt    |

**Lưu ý:** transcript có đề cập case “mượn một phần”; business cũng nói đây có thể là ngoại lệ phải làm thủ công. Theo scope đã chốt sau đó, **v2.1 không automation Partial Quantity**. 

---

# 4. THUẬT NGỮ NGHIỆP VỤ

| Thuật ngữ    | Định nghĩa                                                    |
| ------------ | ------------------------------------------------------------- |
| PO           | Purchase Order – lần đặt mua NPL; có thể chứa nhiều Style/NPL |
| GRN          | Phiếu nhận hàng; một PO có thể có nhiều GRN                   |
| Style        | Mã hàng                                                       |
| OC           | Đơn hàng/Order cụ thể thuộc Style                             |
| Article      | Mã NPL                                                        |
| Lot          | Lô NPL                                                        |
| Site         | Kho/location giữ stock                                        |
| Inhouse      | Số lượng tồn thực tế đang ghi nhận trong luồng                |
| Open Qty < 0 | Excess / dư                                                   |
| Open Qty > 0 | Shortage / thiếu                                              |
| Unreserve    | Giải phóng stock khỏi OC/source ownership                     |
| Allocation   | Gắn stock khả dụng vào OC thiếu                               |

Artifact hiện tại sử dụng `Open Qty < 0` làm Excess cho Unreserve và `Open Qty > 0` làm Shortage cho Allocation. 

---

# 5. ACTOR MODEL

## 5.1. Actors

| Actor               | Vai trò                                     |
| ------------------- | ------------------------------------------- |
| Purchasing User     | Khởi tạo yêu cầu điều chuyển                |
| Reviewer / Approver | Kiểm tra source/destination plan khi cần    |
| Automation System   | Resolve, calculate, execute, verify         |
| WFX                 | System of Record                            |
| Technical Account   | Account hệ thống dùng thực hiện transaction |
| Support/Admin       | Recovery khi transaction lỗi/uncertain      |

---

# 6. SYSTEM CONTEXT DIAGRAM

```text
┌───────────────────┐
│ Purchasing User   │
└─────────┬─────────┘
          │
          │ Source PO
          │ Source Site
          │ Destination Style
          │ Conditional Filters
          ▼
┌─────────────────────────────────────┐
│ MATERIAL ALLOCATION AUTOMATION v2.1 │
│                                     │
│ Source Resolver                     │
│ Quantity Engine                     │
│ Unreserve Engine                    │
│ Destination Resolver                │
│ Allocation Engine                   │
│ Verification Engine                 │
│ History / Checkpoint                │
└───────────────┬─────────────────────┘
                │
                │ Playwright / Future API
                ▼
       ┌────────────────┐
       │      WFX       │
       │ System of      │
       │ Record         │
       └────────────────┘
```

Artifact mô tả implementation hiện tại là **Playwright Automation over WFX**. 

---

# 7. KIẾN TRÚC LOGIC

```text
                           ┌────────────────────┐
                           │        UI          │
                           │ Purchasing Portal  │
                           └──────────┬─────────┘
                                      │
                                      ▼
┌───────────────────────────────────────────────────────────┐
│                    ORCHESTRATION LAYER                    │
│                                                           │
│  Record Runner                                            │
│  Batch Runner                                             │
│  State Manager                                            │
│  Checkpoint Manager                                       │
└───────────┬─────────────────────────────┬─────────────────┘
            │                             │
            ▼                             ▼
┌───────────────────────┐      ┌────────────────────────┐
│ SOURCE DOMAIN         │      │ DESTINATION DOMAIN     │
│                       │      │                        │
│ PO Resolver           │      │ Style Resolver         │
│ GRN Resolver          │      │ OC Resolver            │
│ Article Resolver      │      │ Demand Reader          │
│ Lot Resolver          │      │ Allocation Planner     │
│ Site Validator        │      │                        │
└──────────┬────────────┘      └────────────┬───────────┘
           │                                │
           ▼                                ▼
┌───────────────────────┐      ┌────────────────────────┐
│ UNRESERVE ENGINE      │      │ ALLOCATION ENGINE      │
└──────────┬────────────┘      └────────────┬───────────┘
           │                                │
           └──────────────┬─────────────────┘
                          ▼
                ┌────────────────────┐
                │ Verification       │
                │ Audit / History    │
                └─────────┬──────────┘
                          ▼
                     ┌─────────┐
                     │   WFX   │
                     └─────────┘
```

---

# 8. USE CASE – LEVEL 0

```text
                    ┌───────────────────────────────┐
                    │ Material Allocation System    │
                    │                               │
Purchasing User ───►│ UC-00 Điều chuyển NPL        │
                    │                               │
                    └───────────────┬───────────────┘
                                    │
                             <<include>>
                                    │
                ┌───────────────────┴───────────────────┐
                ▼                                       ▼
         UC-10 UNRESERVE                         UC-20 ALLOCATION
```

---

# 9. USE CASE – LEVEL 1

```text
Purchasing User
      │
      ▼
┌──────────────────────┐
│ UC-01 Khởi tạo Run   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UC-02 Nhập Source    │
│ PO + Site            │
└──────────┬───────────┘
           │
           ▼
┌────────────────────────────┐
│ UC-03 Resolve Source       │
│ Style/Article/GRN/Lot      │
└──────────┬─────────────────┘
           │
           ▼
┌──────────────────────┐
│ UC-04 Resolve        │
│ Destination Style    │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UC-10 UNRESERVE      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UC-11 Verify         │
│ Unreserve            │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UC-12 Checkpoint     │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UC-20 ALLOCATION     │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UC-21 Verify         │
│ Allocation           │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ UC-30 Finalize       │
│ + Audit              │
└──────────────────────┘
```

---

# 10. USE CASE HIERARCHY

## Layer A – Business

| UC    | Use Case                    |
| ----- | --------------------------- |
| UC-00 | Điều chuyển NPL             |
| UC-01 | Khởi tạo workflow           |
| UC-02 | Khai báo source             |
| UC-03 | Xác định source stock       |
| UC-04 | Xác định destination demand |

## Layer B – Transaction

| UC    | Use Case              |
| ----- | --------------------- |
| UC-10 | Unreserve Source      |
| UC-11 | Verify Unreserve      |
| UC-12 | Save Checkpoint       |
| UC-20 | Allocate Destination  |
| UC-21 | Verify Allocation     |
| UC-22 | Reconcile Destination |

## Layer C – Control

| UC    | Use Case                |
| ----- | ----------------------- |
| UC-30 | Finalize Run            |
| UC-31 | Resume Run              |
| UC-32 | Handle Ambiguous Source |
| UC-33 | Handle State Change     |
| UC-34 | Recovery Required       |
| UC-35 | Prevent Duplicate       |

---

# 11. USE CASE UC-00 – ĐIỀU CHUYỂN NPL

| Thuộc tính      | Đặc tả                                                      |
| --------------- | ----------------------------------------------------------- |
| Primary Actor   | Purchasing User                                             |
| Trigger         | Có NPL tại nguồn cần điều chuyển sang Style khác/lot khác   |
| Preconditions   | User có quyền; WFX khả dụng; nguồn tồn tại                  |
| Main Input      | Source PO, Source Site, Destination Style                   |
| Output          | Source Unreserved + Destination Allocated                   |
| Main Activities | Unreserve → Verify → Checkpoint → Allocation                |
| Success         | Transaction reconcile thành công                            |
| Failure         | Không thay đổi hoặc recovery-required tùy transaction stage |

---

# 12. INPUT DESIGN

## 12.1. Mandatory

| Field             | Type         | Required |
| ----------------- | ------------ | -------: |
| Company           | Select       |        ✅ |
| Division          | Select       |        ✅ |
| WFX Account       | Credential   |        ✅ |
| Source PO         | Search/Input |        ✅ |
| Source Site       | Select       |        ✅ |
| Destination Style | Search/Input |        ✅ |

Site phải được chọn đúng theo kho thực tế; transcript nhấn mạnh việc phải chọn đúng kho và tùy loại NPL có thể nằm ở những kho khác nhau. 

---

# 13. CONDITIONAL INPUT

| Field          | Điều kiện                 |
| -------------- | ------------------------- |
| Source Style   | PO nguồn chứa nhiều Style |
| Source Article | PO có nhiều NPL           |
| Source GRN     | PO được nhận nhiều lần    |
| Source Lot     | Article có nhiều Lot      |
| Color          | Article có nhiều màu      |
| Size           | NPL quản lý theo Size     |
| Width          | NPL quản lý theo khổ      |

Transcript xác nhận các trường Source Style/GRN có thể chỉ cần “nếu có”, và hệ thống cần cho phép chọn loại NPL cần điều chuyển.

---

# 14. FIELD KHÔNG CÓ TRÊN FORM

```text
PO Destination     ❌
OC Destination     ❌
Requested Qty      ❌
Partial Qty        ❌
```

Destination được xác định:

```text
Destination Style
       │
       ▼
System resolve OCs
       │
       ▼
OC có Shortage
```

---

# 15. SOURCE RESOLUTION

```text
Source PO
    │
    ▼
Query WFX
    │
    ▼
Source Site
    │
    ▼
Possible Sources
    │
    ├──────── Source Style provided?
    │                  │
    │                 Yes
    │                  ▼
    │              Filter Style
    │
    ├──────── Article provided?
    │                  │
    │                 Yes
    │                  ▼
    │             Filter Article
    │
    ├──────── GRN provided?
    │                  │
    │                 Yes
    │                  ▼
    │              Filter GRN
    │
    ├──────── Lot provided?
    │                  │
    │                 Yes
    │                  ▼
    │               Filter Lot
    │
    ▼
Count candidates
 │
 ├── 0 ─────────► FAILED_SOURCE_NOT_FOUND
 │
 ├── 1 ─────────► SOURCE_RESOLVED
 │
 └── >1 ────────► NEEDS_INPUT
```

---

# 16. SOURCE UNIQUE KEY

Không dùng:

```text
Style
```

làm transaction key.

Đề xuất:

```text
Source Context
=
Company
+ Division
+ Source PO
+ Source Site
+ Source Style
+ Article
+ GRN
+ Lot
```

---

# 17. DESTINATION RESOLUTION

```text
Destination Style
        │
        ▼
GET OC list
        │
        ▼
Filter eligible status
        │
        ▼
Match material
        │
        ▼
Read Open Qty
        │
       ┌┴───────────────┐
       │                │
 Open Qty <= 0      Open Qty > 0
       │                │
      Skip           Shortage OC
                        │
                        ▼
                Allocation Candidate
```

---

# 18. OVERALL ACTIVITY DIAGRAM

```text
┌──────────── USER ─────────────┐
│                               │
│ Input PO Source               │
│ Input Site Source             │
│ Input Destination Style       │
│ + Optional source filters     │
└──────────────┬────────────────┘
               │
               ▼
┌──────── AUTOMATION ───────────┐
│ Validate Context              │
│        │                      │
│        ▼                      │
│ Resolve Source                │
│        │                      │
│   ┌────┴─────┐                │
│   │          │                │
│ Unique    Ambiguous           │
│   │          └──► Needs Input │
│   ▼                           │
│ Resolve Destination OCs       │
│        │                      │
│        ▼                      │
│ Calculate Transaction Plan    │
│        │                      │
└────────┼──────────────────────┘
         │
         ▼
╔═══════════════════════════════╗
║          UNRESERVE            ║
╚══════════════╤════════════════╝
               │
               ▼
         Verify Success
               │
        ┌──────┴───────┐
       Fail          Success
        │                │
        ▼                ▼
      STOP        SAVE CHECKPOINT
                         │
                         ▼
               Fresh WFX Read
                         │
                         ▼
╔═══════════════════════════════╗
║          ALLOCATION           ║
╚══════════════╤════════════════╝
               │
               ▼
             Verify
               │
          ┌────┴────┐
        Fail      Success
          │           │
          ▼           ▼
      Recovery     Reconcile
      Required         │
                       ▼
                   Completed
```

---

# 19. ACTIVITY 1 – UNRESERVE

## 19.1. Business Objective

Giải phóng NPL đang reserved trên OC nguồn để stock trở thành nguồn hợp lệ cho Allocation.

---

# 20. UNRESERVE – PRECONDITIONS

| ID    | Condition                            |
| ----- | ------------------------------------ |
| U-P01 | Source PO tồn tại                    |
| U-P02 | Source Site hợp lệ                   |
| U-P03 | Source stock được xác định duy nhất  |
| U-P04 | Article đúng                         |
| U-P05 | WFX record còn eligible              |
| U-P06 | Open Qty/stock state vẫn phù hợp     |
| U-P07 | Không có transaction trùng đang chạy |

---

# 21. UNRESERVE – DATA INPUT

```text
Source Context
│
├── Company
├── Division
├── PO
├── Site
├── Style
├── OC
├── Article
├── GRN
├── Lot
├── Color
├── Size
├── Width
└── UOM
```

---

# 22. UNRESERVE – DATA READ FROM WFX

| Field           | Purpose                 |
| --------------- | ----------------------- |
| OC No           | Transaction source      |
| PO              | Source lineage          |
| Style           | Source context          |
| Article         | Material validation     |
| GRN             | Receipt lineage         |
| Lot             | Stock differentiation   |
| Site            | Warehouse validation    |
| UOM             | Compatibility           |
| Inhouse         | Stock + rounding basis  |
| Reserved Qty    | Existing reservation    |
| Open Qty        | Excess identification   |
| Status          | Eligibility             |
| WFX Allowed Qty | Transaction restriction |

---

# 23. UNRESERVE ACTIVITY DIAGRAM

Artifact hiện tại search source rows, loại row sai Article hoặc Qty không hợp lệ, thực hiện Delete/Unreserve, điền Qty, Reason = `Stock Utilization`, save rồi parse Stock Correction Report. 

```text
START UNRESERVE
      │
      ▼
Fresh read Source
      │
      ▼
Validate Source key
PO + Site + Article + GRN/Lot
      │
      ▼
Still valid?
 ┌────┴─────┐
 No         Yes
 │           │
STOP         ▼
        Open Unreserve Stock
             │
             ▼
       Search OC + Site
             │
             ▼
      Filter exact Article
             │
             ▼
      Eligible row?
       ┌─────┴──────┐
      No            Yes
       │             │
       ▼             ▼
     FAILED       Select Row
                     │
                     ▼
             Execute Unreserve
                     │
                     ▼
       Reason = Stock Utilization
                     │
                     ▼
                    Save
                     │
                     ▼
            Confirm Save Result
                ┌────┴─────┐
             Uncertain    Confirmed
                │            │
                ▼            ▼
              STOP      Read Report
                             │
                             ▼
                     Re-query Source
                             │
                             ▼
                         Verify
                             │
                    ┌────────┴──────┐
                  Fail           Success
                    │               │
                    ▼               ▼
                 FAILED         CHECKPOINT
```

---

# 24. UNRESERVE – QUANTITY RULE

**Không có Requested Quantity.**

```text
User
  │
  └── does NOT enter Qty
```

System determines quantity from WFX business state.

```text
WFX Source Data
       │
       ├─ Open Qty
       ├─ Inhouse
       ├─ Reserved
       └─ Allowed transaction
       │
       ▼
Quantity Engine
       │
       ▼
Business Rule
       │
       ▼
Round Roll when applicable
       │
       ▼
Calculated Unreserve Qty
```

---

# 25. ROUNDING RULE

```text
           ┌──────────────┐
           │   INHOUSE    │
           └──────┬───────┘
                  │
                  ▼
             ROUNDING
                  │
                  ▼
      Final System Quantity
```

Không sử dụng:

```text
Open Qty ───────────X──► Rounding
Reserved Qty ───────X──► Rounding
User Qty ───────────X──► Rounding
```

---

# 26. UNRESERVE OUTPUT

| Field                    | Description             |
| ------------------------ | ----------------------- |
| Run ID                   | Automation run          |
| Line ID                  | Input line              |
| Source PO                | resolved                |
| Source OC                | resolved                |
| Source Site              | resolved                |
| Source Article           | resolved                |
| Source GRN               | if applicable           |
| Source Lot               | if applicable           |
| Inhouse Before           | snapshot                |
| Open Qty Before          | snapshot                |
| Calculated Unreserve Qty | system                  |
| Executed Qty             | actual WFX              |
| Transaction ID           | WFX                     |
| Report Ref               | Stock Correction Report |
| Status                   | success/fail            |
| Timestamp                | execution               |
| Error                    | if any                  |

---

# 27. CHECKPOINT DESIGN

Artifact thực tế lưu:

```text
state = unreserve_completed
```

ngay sau nhóm Unreserve cuối cùng và trước Allocation. 

```text
UNRESERVE SUCCESS
        │
        ▼
Save History
        │
        ▼
┌─────────────────────────┐
│ unreserve_completed     │
│ source_transaction_id   │
│ source_snapshot_after   │
│ executed_at             │
└───────────┬─────────────┘
            │
            ▼
Allocation Enabled
```

---

# 28. RESUME ACTIVITY

```text
Application Restart
       │
       ▼
Read Run State
       │
       ▼
Checkpoint exists?
 ┌─────┴───────┐
 No            Yes
 │              │
 ▼              ▼
Start       Validate
Unreserve   checkpoint
                │
                ▼
           Source already
           unreserved?
             │
        ┌────┴────┐
       No        Yes
       │           │
       ▼           ▼
    REVIEW      Skip U
                    │
                    ▼
                Allocation
```

---

# 29. ACTIVITY 2 – ALLOCATION

## 29.1. Business Objective

Phân bổ quantity đã được giải phóng vào các OC đang thiếu thuộc **Destination Style**.

---

# 30. ALLOCATION PRECONDITIONS

| ID    | Requirement                     |
| ----- | ------------------------------- |
| A-P01 | Unreserve success               |
| A-P02 | Checkpoint tồn tại              |
| A-P03 | Destination Style tồn tại       |
| A-P04 | Destination OCs được resolve    |
| A-P05 | Shortage OCs tồn tại            |
| A-P06 | Article/material mapping hợp lệ |
| A-P07 | Fresh WFX snapshot được đọc     |
| A-P08 | Không có mismatch nghiêm trọng  |

Artifact cũng re-navigate và đọc lại Indent List sau Unreserve trước khi bắt đầu Allocation. 

---

# 31. ALLOCATION DATA INPUT

```text
Destination Style
        │
        ▼
System-resolved
        │
        ├─ Destination OC
        ├─ Article
        ├─ Open Qty
        ├─ Existing Allocation
        ├─ Unreserved Qty
        ├─ UOM
        └─ Status
```

---

# 32. ALLOCATION ACTIVITY DIAGRAM

```text
START ALLOCATION
       │
       ▼
Verify Checkpoint
       │
       ▼
Refresh Destination Style
       │
       ▼
Get all OCs
       │
       ▼
Filter eligible OCs
       │
       ▼
Match Material
       │
       ▼
Read current Open Qty
       │
       ▼
Open Qty > 0?
 ┌─────┴────┐
 No         Yes
 │           │
Skip         ▼
        Add to Plan
             │
             ▼
     All OCs processed?
             │
             ▼
      Final Allocation Plan
             │
             ▼
       For each OC
             │
             ▼
     Open In-House popup
             │
             ▼
      Enter system Qty
             │
             ▼
             Save
             │
             ▼
        Save Confirmed?
         ┌───┴─────┐
        No         Yes
         │           │
         ▼           ▼
   ABORT RUN      Re-read OC
                     │
                     ▼
                  Verify
                     │
                     ▼
                 Next OC
                     │
                     ▼
              Final Reconcile
                     │
                     ▼
                 COMPLETED
```

Artifact hiện tại cũng abort toàn run nếu một OC save bị unconfirmed/uncertain. 

---

# 33. ALLOCATION CALCULATION

Artifact hiện tại tính:

```text
Target Fill
=
Open Qty
− Unreserved Qty
```

Nếu Target Fill ≤ 0 → skip indent. 

Trong v2.1, Quantity Engine vẫn phải:

1. Đọc current shortage.
2. Đọc quantity thực tế đã Unreserve.
3. Lập plan cho các OC.
4. Không nhận Quantity input từ user.
5. Không tự partial execute khi state thay đổi.

---

# 34. MULTI-OC DESTINATION

```text
DESTINATION STYLE S01
           │
    ┌──────┼──────────┐
    ▼      ▼          ▼
  OC01    OC02       OC03
 Open     Open        Open
 +1000    +2500        0
    │      │           │
    ▼      ▼           └──► Skip
 shortage shortage
    │      │
    └──┬───┘
       ▼
Allocation Planner
       │
       ▼
 OC01 → allocation
       │
       ▼
Refresh / Verify
       │
       ▼
 OC02 → allocation
```

---

# 35. OC PRIORITY – OPEN DECISION

Nếu nhiều OC cùng thiếu, thứ tự allocation **chưa thấy transcript chốt rõ**.

Do đó không nên tự hard-code.

| Candidate Rule              | Status |
| --------------------------- | ------ |
| Earliest Delivery Date      | Open   |
| OC sequence                 | Open   |
| WFX display order           | Open   |
| Highest shortage            | Open   |
| Purchasing-defined priority | Open   |

**Requirement:** Purchasing cần chốt trước production.

---

# 36. FLOW 01 – CÙNG STYLE, KHÁC LOT

Transcript minh họa trực tiếp case một Lot đã về, Lot khác chưa về và cần mượn NPL từ Lot đã về để phục vụ sản xuất. 

```text
STYLE A

LOT 61                           LOT 68
Đã về                            Chưa về
  │                                 │
  ▼                                 ▼
Source Stock                    Destination Need
  │                                 ▲
  ▼                                 │
UNRESERVE                           │
  │                                 │
  └──────────► ALLOCATION ──────────┘
```

### Activity – Unreserve

| Step | Action                    |
| ---- | ------------------------- |
| U01  | Resolve PO nguồn          |
| U02  | Resolve Source Site       |
| U03  | Resolve Article           |
| U04  | Resolve Lot 61            |
| U05  | Verify source             |
| U06  | Calculate system quantity |
| U07  | Unreserve                 |
| U08  | Verify                    |
| U09  | Checkpoint                |

### Activity – Allocation

| Step | Action                          |
| ---- | ------------------------------- |
| A01  | Resolve Style A                 |
| A02  | Find destination OCs/Lot demand |
| A03  | Read shortage                   |
| A04  | Build plan                      |
| A05  | Allocate                        |
| A06  | Verify                          |
| A07  | Log                             |

---

# 37. FLOW 02 – KHÁC STYLE

```text
SOURCE                          DESTINATION
STYLE A                         STYLE B
   │                               │
   ▼                               ▼
PO / GRN / Article              OC01
Site / Lot                      OC02
   │                            OC03
   ▼                               ▲
UNRESERVE                         │
   │                               │
   └─────► FREE STOCK ─► ALLOCATION
```

### Required source dimensions

```text
PO
+ Site
+ Article
+ optional Style
+ optional GRN
+ optional Lot
```

Destination:

```text
Style B
→ system resolves OCs
```

---

# 38. FLOW 03 – PO CÓ NHIỀU ARTICLE

Transcript cho biết cùng một PO có thể gom nhiều loại vải/NPL, nên không thể mặc định toàn bộ PO chỉ có một code. 

```text
PO001
 │
 ├── ARTICLE A
 ├── ARTICLE B
 └── ARTICLE C
```

Nếu user chỉ nhập:

```text
PO001
```

và có 3 Article matching:

```text
SYSTEM
  │
  ▼
AMBIGUOUS
  │
  ▼
NEEDS INPUT:
SOURCE ARTICLE
```

Không được tự chọn Article đầu tiên.

---

# 39. FLOW 04 – PO CÓ NHIỀU GRN

```text
                 PO001
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
     GRN01       GRN02       GRN03
       │           │           │
     Lot A       Lot B       Lot C
```

Transcript mô tả PO có thể về 4–5 lần, do đó phải xác định đúng “nguồn nhập”. 

### Rule

```text
Multiple GRN detected
       │
       ▼
Can system uniquely resolve?
 ┌─────┴────┐
 Yes        No
 │           │
 ▼           ▼
Continue   Ask GRN
```

---

# 40. FLOW 05 – NHIỀU SOURCE → MỘT DESTINATION STYLE

```text
PO SOURCE A ─► U ──┐
                    │
PO SOURCE B ─► U ──┼────► STYLE DEST
                    │        │
PO SOURCE C ─► U ──┘        ├── OC01
                             ├── OC02
                             └── OC03
```

Batch nên xử lý theo từng Source Record:

```text
LINE 01
U → VERIFY → A → VERIFY
          ↓
LINE 02
U → VERIFY → A → VERIFY
          ↓
LINE 03
```

Không nên Unreserve toàn bộ source trước rồi mới Allocation hàng loạt nếu điều đó làm tăng recovery risk.

---

# 41. FLOW 06 – SOURCE SITE

Transcript nhấn mạnh “phải chọn đúng kho”, vì các nhóm NPL có thể nằm ở các kho khác nhau. 

```text
ARTICLE X
│
├── SITE FC   = 8,000
│
└── SITE LC   = 4,000
```

User chọn:

```text
Source Site = LC
```

Bot chỉ được:

```text
LC → 4,000
```

Không:

```text
LC insufficient
   ↓
Auto fallback FC   ❌
```

---

# 42. FLOW 07 – KHÁC ARTICLE

```text
SOURCE ARTICLE A
       │
       ▼
UNRESERVE
       │
       ▼
Material Compatibility Check
       │
       ▼
DESTINATION REQUIREMENT B
       │
       ▼
ALLOCATION
```

Nếu Source Article và Destination Article không giống nhau, cần có **mapping/business compatibility rule**.

Không có rule:

```text
STOP → NEEDS REVIEW
```

---

# 43. FLOW 08 – MULTI-SIZE NPL

Transcript cho thấy một số NPL như label có Size được quản lý riêng. 

```text
ARTICLE LABEL-X
      │
 ┌────┼────┐
 ▼    ▼    ▼
S     M    L
```

Nếu Size là dimension kiểm soát:

```text
Source Article
+ Size
```

phải match Destination Material Requirement.

---

# 44. BATCH ACTIVITY

Transcript cũng đề xuất khả năng thêm nhiều dòng để một lần nhập có thể chạy lần lượt nhiều PO nguồn. 

```text
RUN-20260807-01
       │
       ├── LINE 001
       │     ├─ Unreserve
       │     └─ Allocation
       │
       ├── LINE 002
       │     ├─ Unreserve
       │     └─ Allocation
       │
       └── LINE 003
             ├─ Unreserve
             └─ Allocation
```

---

# 45. STATE MACHINE

```text
                ┌───────────┐
                │   DRAFT   │
                └─────┬─────┘
                      ▼
                ┌─────────────┐
                │ VALIDATING  │
                └─────┬───────┘
                      │
           ┌──────────┴─────────┐
           ▼                    ▼
     NEEDS_INPUT             VALIDATED
                                 │
                                 ▼
                              READY
                                 │
                                 ▼
                           UNRESERVING
                            │       │
                          Fail    Success
                            │       │
                            ▼       ▼
                         FAILED  UNRESERVE_
                                 COMPLETED
                                     │
                                CHECKPOINT
                                     │
                                     ▼
                                ALLOCATING
                               │          │
                             Fail       Success
                               │          │
                               ▼          ▼
                       RECOVERY_REQUIRED VERIFYING
                                           │
                                           ▼
                                       COMPLETED
```

**Không có trạng thái business `PARTIAL`.**

---

# 46. DUPLICATE PREVENTION

Pain point v1 là system lưu state quá coarse theo Style; transcript cho biết khi một Style đã chạy một loại NPL thì loại NPL tiếp theo có thể không được Allocation nữa, trong khi chạy lại cùng NPL thì lại phải ngăn duplicate. 

Do đó:

```text
❌ Duplicate Key = Style
```

Đề xuất:

```text
Duplicate Key
=
Company
+ Division
+ Source PO
+ Source Site
+ Source Article
+ Source GRN/Lot
+ Destination Style
+ Destination Material
```

---

# 47. TRANSACTION DATA MODEL

```text
RUN
│
├── Run ID
├── Initiated By
├── Company
├── Division
└── Status
     │
     └── LINE
          │
          ├── Source Context
          │    ├── PO
          │    ├── Site
          │    ├── Style
          │    ├── OC
          │    ├── Article
          │    ├── GRN
          │    └── Lot
          │
          ├── Unreserve Transaction
          │
          └── Destination Style
                 │
                 └── Allocations
                       ├── OC01 Transaction
                       ├── OC02 Transaction
                       └── OC03 Transaction
```

---

# 48. LOGICAL ENTITY MODEL

```text
┌──────────────┐
│ RUN          │
│ run_id       │
└──────┬───────┘
       │ 1:N
       ▼
┌──────────────┐
│ RUN_LINE     │
│ line_id      │
└───┬──────┬───┘
    │      │
  1:1      │ 1:N
    │      │
    ▼      ▼
┌───────────┐    ┌────────────────┐
│ SOURCE    │    │ ALLOCATION_TX  │
└────┬──────┘    └───────┬────────┘
     │                    │
     ▼                    ▼
┌───────────────┐    ┌──────────────┐
│ UNRESERVE_TX  │    │ DESTINATION  │
└───────────────┘    │ OC           │
                     └──────────────┘
```

---

# 49. DATA DICTIONARY – RUN

| Field          | Type     | Description       |
| -------------- | -------- | ----------------- |
| run_id         | UUID     | Batch identifier  |
| company        | string   | WFX company       |
| division       | string   | WFX division      |
| initiated_by   | string   | business user     |
| technical_user | string   | executing account |
| started_at     | datetime | start             |
| finished_at    | datetime | finish            |
| status         | enum     | run status        |

---

# 50. DATA DICTIONARY – SOURCE

| Field           |             Required |
| --------------- | -------------------: |
| source_po       |                    ✅ |
| source_site     |                    ✅ |
| source_style    |          Conditional |
| source_oc       |             Resolved |
| source_article  | Conditional/Resolved |
| source_grn      |          Conditional |
| source_lot      |          Conditional |
| source_color    |          Conditional |
| source_size     |          Conditional |
| source_width    |          Conditional |
| source_uom      |             Resolved |
| inhouse_before  |             Resolved |
| open_qty_before |             Resolved |
| reserved_before |             Resolved |

---

# 51. DATA DICTIONARY – DESTINATION

| Field                     | Source |
| ------------------------- | ------ |
| destination_style         | User   |
| destination_oc            | System |
| destination_article       | System |
| destination_uom           | System |
| open_qty_before           | System |
| allocated_before          | System |
| allocation_qty            | System |
| open_qty_after            | System |
| allocation_transaction_id | WFX    |

---

# 52. BEFORE / AFTER SNAPSHOT

## Unreserve

| Dimension | Before | After |
| --------- | -----: | ----: |
| Inhouse   |      X |     Y |
| Reserved  |      X |     Y |
| Open Qty  |      X |     Y |
| Available |      X |     Y |

## Allocation

| Dimension | Before | After |
| --------- | -----: | ----: |
| Open Qty  |      X |     Y |
| Allocated |      X |     Y |
| Available |      X |     Y |

---

# 53. SEQUENCE DIAGRAM

```text
Purchasing   Automation        WFX         History
    │            │              │             │
    │ Submit     │              │             │
    ├───────────►│              │             │
    │            │ GET Source   │             │
    │            ├─────────────►│             │
    │            │◄─────────────┤             │
    │            │              │             │
    │            │ Resolve Dest │             │
    │            ├─────────────►│             │
    │            │◄─────────────┤             │
    │            │              │             │
    │            │ UNRESERVE    │             │
    │            ├─────────────►│             │
    │            │◄──Success────┤             │
    │            │              │             │
    │            │ Save checkpoint            │
    │            ├───────────────────────────►│
    │            │              │             │
    │            │ Fresh GET    │             │
    │            ├─────────────►│             │
    │            │◄─────────────┤             │
    │            │              │             │
    │            │ ALLOCATE OC1 │             │
    │            ├─────────────►│             │
    │            │◄─────────────┤             │
    │            │              │             │
    │            │ ALLOCATE OC2 │             │
    │            ├─────────────►│             │
    │            │◄─────────────┤             │
    │            │              │             │
    │            │ Final Log                  │
    │            ├───────────────────────────►│
    │ Completed  │                            │
    │◄───────────┤                            │
```

---

# 54. ERROR / EXCEPTION MATRIX

| Code | Condition                           | Action                        |
| ---- | ----------------------------------- | ----------------------------- |
| E001 | Source PO không tồn tại             | Stop                          |
| E002 | Site không tồn tại                  | Stop                          |
| E003 | Không tìm thấy stock                | Stop                          |
| E004 | Nhiều Article                       | Needs Input                   |
| E005 | Nhiều GRN                           | Needs Input nếu không resolve |
| E006 | Nhiều Lot                           | Needs Input                   |
| E007 | Article mismatch                    | Stop/Review                   |
| E008 | UOM mismatch                        | Stop                          |
| E009 | Source changed before execution     | Recalculate/Review            |
| E010 | Unreserve save uncertain            | Stop                          |
| E011 | Unreserve failed                    | No Allocation                 |
| E012 | Destination Style không có OC thiếu | Stop/No Action                |
| E013 | Allocation save uncertain           | Abort remaining               |
| E014 | Allocation fail after Unreserve     | Recovery Required             |
| E015 | Duplicate transaction               | Reject                        |
| E016 | WFX session lost                    | Stop + Resume-safe            |

---

# 55. CRITICAL FAILURE SCENARIO

```text
UNRESERVE
    │
    ▼
 SUCCESS
    │
    ▼
Stock Released
    │
    ▼
ALLOCATION
    │
    ▼
 FAILURE
    │
    ▼
╔══════════════════════════╗
║ RECOVERY REQUIRED        ║
║                          ║
║ Source đã thay đổi       ║
║ Destination chưa xong    ║
╚══════════════════════════╝
```

System phải lưu đủ:

* Source.
* Unreserve transaction.
* Executed quantity.
* Destination intended.
* OC đã/ chưa allocate.
* Error.
* Recovery status.

---

# 56. RECOVERY OPTIONS

Chưa có business rule chính thức cho automatic reversal.

Do đó v2.1 nên:

```text
Allocation Failed
      │
      ▼
STOP remaining transactions
      │
      ▼
RECOVERY_REQUIRED
      │
      ▼
Human review
```

Không tự reverse nếu Purchasing/WFX chưa chốt rule.

---

# 57. REVALIDATION

## Before Unreserve

```text
Initial Read
    │
    ▼
Plan
    │
    ▼
Fresh Read
    │
    ▼
Same State?
 ┌──┴──┐
Yes    No
 │      │
Run   Review
```

## Before Allocation

Artifact hiện tại đã thực hiện fresh read và snapshot comparison sau Unreserve. 

```text
Unreserve
    │
    ▼
Checkpoint
    │
    ▼
Fresh Indent Read
    │
    ▼
Snapshot Validation
    │
    ▼
Allocation
```

---

# 58. FUNCTIONAL REQUIREMENTS

| ID    | Requirement                      | Priority |
| ----- | -------------------------------- | -------- |
| FR-01 | Nhập Source PO                   | Must     |
| FR-02 | Chọn Source Site                 | Must     |
| FR-03 | Nhập Destination Style           | Must     |
| FR-04 | Resolve Source Article           | Must     |
| FR-05 | Resolve Source GRN               | Must     |
| FR-06 | Resolve Source Lot               | Should   |
| FR-07 | Detect source ambiguity          | Must     |
| FR-08 | Unreserve                        | Must     |
| FR-09 | Verify Unreserve                 | Must     |
| FR-10 | Save checkpoint                  | Must     |
| FR-11 | Resume after checkpoint          | Must     |
| FR-12 | Resolve OCs từ Destination Style | Must     |
| FR-13 | Detect Shortage OCs              | Must     |
| FR-14 | Allocate sequentially            | Must     |
| FR-15 | Verify each Allocation           | Must     |
| FR-16 | Abort on uncertain save          | Must     |
| FR-17 | Maintain audit history           | Must     |
| FR-18 | Duplicate prevention             | Must     |
| FR-19 | Support batch input              | Should   |
| FR-20 | Support Size dimension           | Should   |
| FR-21 | Rounding only using Inhouse      | Must     |
| FR-22 | No Partial Quantity input        | Must     |
| FR-23 | No Destination PO input          | Must     |
| FR-24 | No Destination OC input          | Must     |

---

# 59. NON-FUNCTIONAL REQUIREMENTS

| Category        | Requirement                                  |
| --------------- | -------------------------------------------- |
| Reliability     | Không double-Unreserve                       |
| Consistency     | Fresh WFX read before transactional activity |
| Auditability    | 100% transactions có Run ID                  |
| Recoverability  | Resume được từ checkpoint                    |
| Safety          | Uncertain transaction → Stop                 |
| Security        | Credentials không ghi plain text             |
| Concurrency     | Detect WFX state changes                     |
| Traceability    | Source → Destination OC đầy đủ               |
| Idempotency     | Duplicate request không chạy lại             |
| Maintainability | Source Resolver tách khỏi transaction engine |

---

# 60. CURRENT ARTIFACT → TARGET v2.1 GAP

| Current Artifact                    | Target v2.1                           |
| ----------------------------------- | ------------------------------------- |
| Search Excess/Shortage từ Indent    | Thêm explicit Source PO               |
| Site resolved per PO                | Site nguồn user chọn                  |
| Group OCs by division/article/site  | Giữ                                   |
| Unreserve first                     | Giữ                                   |
| Checkpoint after Unreserve          | Giữ                                   |
| Allocation fresh read               | Giữ                                   |
| Destination dựa trên indent context | Resolve từ Destination Style          |
| PO selection Awaiting Review        | Mở rộng ambiguity cho GRN/Article/Lot |
| State có nguy cơ coarse             | Transaction key chi tiết              |
| Chưa model multi-Article rõ         | Bổ sung                               |
| Chưa model multi-GRN rõ             | Bổ sung                               |
| Chưa model Site mandatory rõ        | Bổ sung                               |
| Quantity capped                     | Giữ system logic, bỏ user Partial     |
| Sequential                          | Giữ                                   |

---

# 61. UI CONCEPT

```text
┌────────────────────────────────────────────────────────────┐
│ MATERIAL ALLOCATION v2.1                                  │
├────────────────────────────────────────────────────────────┤
│ Company    [_____________]                                 │
│ Division   [_____________]                                 │
│ Account    [_____________]                                 │
├────────────────────────────────────────────────────────────┤
│ SOURCE                                                     │
│ PO          [_____________]                                │
│ Site        [____________▼]                                │
│ Style       [_____________] optional                       │
│ Article     [_____________] conditional                    │
│ GRN         [_____________] conditional                    │
│ Lot         [_____________] conditional                    │
│ Size        [_____________] conditional                    │
├────────────────────────────────────────────────────────────┤
│ DESTINATION                                                │
│ Style       [_____________]                                │
│                                                            │
│ PO Destination     -- NOT REQUIRED                         │
│ OC Destination     -- SYSTEM RESOLVED                      │
│ Quantity           -- SYSTEM CALCULATED                    │
├────────────────────────────────────────────────────────────┤
│ [+ Add Row]                  [Validate]   [Run]             │
└────────────────────────────────────────────────────────────┘
```

---

# 62. REVIEW SCREEN

Trước execute nên hiển thị:

| Source               | Value   |
| -------------------- | ------- |
| PO                   | PO001   |
| Site                 | LC      |
| Article              | FAB-001 |
| GRN                  | GRN001  |
| Lot                  | L01     |
| Inhouse              | ...     |
| Calculated Unreserve | ...     |

Destination:

| OC    | Current Open Qty | System Allocation |
| ----- | ---------------: | ----------------: |
| OC001 |              ... |               ... |
| OC002 |              ... |               ... |

User **review**, không edit transaction quantity.

---

# 63. FINAL REPORT

| Line | PO Source | Site | Article | Style Dest | OC Dest | Unreserve | Allocation | Status            |
| ---: | --------- | ---- | ------- | ---------- | ------- | --------: | ---------: | ----------------- |
|  001 | PO01      | FC   | ART01   | ST-B       | OC01    |         X |          Y | Completed         |
|  001 | PO01      | FC   | ART01   | ST-B       | OC02    |         — |          Y | Completed         |
|  002 | PO02      | LC   | ART05   | ST-C       | OC07    |         X |          — | Recovery Required |

---

# 64. SUCCESS CONDITION

Một Line chỉ là `COMPLETED` khi:

```text
Source resolved
       AND
Unreserve confirmed
       AND
Checkpoint saved
       AND
Destination refreshed
       AND
All intended Allocation transactions confirmed
       AND
Final reconciliation passed
```

---

# 65. BUSINESS RULES REGISTER

| ID    | Rule                                        |
| ----- | ------------------------------------------- |
| BR-01 | Unreserve trước Allocation                  |
| BR-02 | Destination chỉ nhập Style                  |
| BR-03 | Không nhập Destination OC                   |
| BR-04 | Không nhập Destination PO                   |
| BR-05 | Không hỗ trợ Partial Quantity               |
| BR-06 | Qty do system xác định                      |
| BR-07 | Rounding chỉ dùng Inhouse                   |
| BR-08 | Site Source phải chính xác                  |
| BR-09 | Không fallback Site                         |
| BR-10 | Multi-GRN phải resolve đúng receipt         |
| BR-11 | Multi-Article phải resolve đúng Article     |
| BR-12 | Multi-Lot phải resolve đúng Lot             |
| BR-13 | Multiple candidates → Needs Input           |
| BR-14 | Unreserve failure → không Allocation        |
| BR-15 | Allocation uncertain → Abort                |
| BR-16 | Checkpoint chống double-Unreserve           |
| BR-17 | Mỗi Article/Lot có state riêng              |
| BR-18 | Không fuzzy match transactional identifiers |

---

# 66. CÁC BUSINESS DECISION CHƯA ĐƯỢC CHỐT

Đây là các điểm **không nên để dev tự suy luận**:

| ID    | Open Question                                    |
| ----- | ------------------------------------------------ |
| OD-01 | Priority của các OC thiếu trong cùng Style       |
| OD-02 | Công thức “tròn cuộn” chính xác theo Inhouse     |
| OD-03 | Rule khi Inhouse rounding lớn hơn total shortage |
| OD-04 | Cross-Article mapping                            |
| OD-05 | UOM conversion                                   |
| OD-06 | Auto reversal khi Allocation fail                |
| OD-07 | Eligibility status chính xác cho từng loại NPL   |
| OD-08 | Material-specific Site mapping                   |
| OD-09 | Khi nhiều GRN cùng hợp lệ có cho auto-pick không |
| OD-10 | Transaction reconciliation tolerance             |

---

# 67. TARGET SYSTEM – ONE-PAGE DESIGN

```text
                       PURCHASING USER
                             │
       ┌─────────────────────┼──────────────────────┐
       ▼                     ▼                      ▼
   SOURCE PO             SOURCE SITE          DEST STYLE
       │                     │                      │
       └──────────────┬──────┘                      │
                      ▼                             │
              SOURCE RESOLVER                       │
          PO / Article / GRN / Lot                  │
                      │                             │
                Unique Source                       │
                      │                             │
                      └──────────────┬──────────────┘
                                     ▼
                              PLAN / VALIDATE
                                     │
                                     ▼
                  ╔══════════════════════════╗
                  ║       UNRESERVE          ║
                  ║ Source OC / Stock        ║
                  ╚════════════┬═════════════╝
                               │
                            VERIFY
                               │
                               ▼
                  ╔══════════════════════════╗
                  ║       CHECKPOINT         ║
                  ║ unreserve_completed      ║
                  ╚════════════┬═════════════╝
                               │
                               ▼
                       FRESH WFX READ
                               │
                               ▼
                       DEST STYLE → OCs
                               │
                               ▼
                    Filter Open Qty > 0
                               │
                               ▼
                  ╔══════════════════════════╗
                  ║       ALLOCATION         ║
                  ║ OC1 → OC2 → ... → OCn   ║
                  ╚════════════┬═════════════╝
                               │
                             VERIFY
                               │
                               ▼
                    FINAL RECONCILIATION
                               │
                 ┌─────────────┴─────────────┐
                 ▼                           ▼
             COMPLETED               RECOVERY REQUIRED
```

---

# 68. KẾT LUẬN THIẾT KẾ

**Material Allocation Automation v2.1 nên được thiết kế dưới dạng transaction orchestrator gồm hai domain activity độc lập:**

```text
UNRESERVE DOMAIN
      │
      │ confirmed transaction
      │ + checkpoint
      ▼
ALLOCATION DOMAIN
```

Một input record được định nghĩa theo:

```text
SOURCE
=
PO nguồn
+ Site nguồn
+ conditional:
  Style / Article / GRN / Lot / Size

DESTINATION
=
Style đích
```

Sau đó hệ thống:

```text
1. Resolve chính xác Source
2. Resolve Destination Style
3. Xác định các OC đang thiếu
4. Tính quantity tự động
5. UNRESERVE
6. Verify
7. Save checkpoint
8. Fresh read
9. ALLOCATE
10. Verify từng OC
11. Reconcile
12. Log
```

Đây là thiết kế vừa giữ được những pattern an toàn của engine hiện tại—Unreserve trước, checkpoint, fresh read, sequential save verification—vừa mở rộng đúng yêu cầu Workflow 2 cho **khác Style, khác Article, khác Lot, multi-GRN và đúng Site nguồn**.
