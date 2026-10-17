---
type: weekly_report
period: "10/10/2026–16/10/2026"
next_period: "17/10/2026–22/10/2026"
source_event: "PPJ-WEEKLY-20261010-20261016"
prepared_by: "Nguyễn Vũ Ánh Khoa"
last_verified: "2026-10-16"
confidence: "Strong"
baseline: "2026-10-09"
---

# PPJ AI, Automation & Digital Portfolio
# WEEKLY PORTFOLIO UPDATE — 10/10–16/10/2026

**Kỳ báo cáo:** 10/10/2026–16/10/2026
**Baseline so sánh:** 09/10/2026
**Phạm vi:** Các dự án có cập nhật thực tế được xác nhận trong kỳ

---

## 1. Tóm tắt điều hành

Trong kỳ 10–16/10/2026, portfolio ghi nhận các chuyển động chính như sau:

1. **Sew Agent V1 hoàn thành — V2 chuyển giao BA support cho Khoa**
   - Sew V1 completion confirmed. Các lỗi đã ghi nhận về search, ordering, SAM, QC-exclusion, export, operation-existence được báo cáo là đã fix.
   - V2 BA bridge chính thức chuyển về **Nguyễn Vũ Ánh Khoa**. Evidence requirements cho V2 đã được xác định.

2. **Finance WS3 đi vào fieldwork — khảo sát gửi đi trước 22/10**
   - Ba bộ khảo sát 20 câu cho Accounting/Cost, HR/Payroll và Planning/Production/GTAS đã được tạo và gửi đi.
   - Deadline thu hồi: **22/10/2026**.

3. **Finance WS4 — constraint được xác nhận**
   - Weaving OC và Dyeing OC riêng biệt, không có linkage cross-OC đã xác nhận.
   - OVH là report-level, không phải OC-wise. Constraint này ảnh hưởng trực tiếp đến end-to-end profitability và performance reporting.

4. **Business Travel / HCQT / WFX — tiến triển về mapping**
   - Tất cả 22 loại chi phí đã có mapping 642x/627x chi tiết (Mrs. Violet cung cấp).
   - Tuy nhiên: 641x details chưa có cho bất kỳ loại nào; 18/22 WFX Analysis Code vẫn mở; production import chưa sẵn sàng.

5. **Expense Invoice Automation — đang dùng nhưng nhiều defect**
   - 36 fuel invoices đã upload. Các lỗi: VAT reset sau khi chọn Tax Template; PDF/XML attachment; airport-invoice linking; slow bulk processing.

6. **PPJ × UIT/AISC — chuẩn bị giám khảo vòng sơ loại**
   - Chuẩn bị judge cho preliminary round đang tiến hành.
   - UIT contract và PPJ documents còn pending. Deadline **22/10/2026**.

---

## 2. Portfolio Movement Summary

| Dự án | Canonical Code | Domain | Movement vs 9 Oct | Trạng thái |
|---|---|---|---|---|
| Finance WS3 — Factory Performance | `FIN_FinanceManagement_v1.2.0` | Finance / Accounting | Planning → Response collection | ⚡ Chuyển động |
| Finance WS4 — Fabric OC | `FIN_FinanceManagement_v1.2.0` | Finance / Accounting | Constraint confirmed | ⚠️ Constrained |
| Finance WS1 / WS2 | `FIN_FinanceManagement_v1.2.0` | Finance / Accounting | No new confirmed update | — Không đổi |
| Business Travel / HCQT / WFX | `ADMIN_ExpenseManagement_v1.1.0` | Administration | 642x/627x mapped; 641x open | ⚡ Chuyển động |
| Expense Invoice Automation | `LOG_ExpenseInvoiceProcessing_v1.2.2` | Logistics / EXIM | Active use; defect-heavy | 🔴 At Risk |
| GDI / Material Allocation / Invoice Downloader | `PUR_GDIAutomation_v1.0.0` / `PUR_MaterialAllocation_v1.1.0` | Sourcing / Purchasing | No new confirmed update | — Không đổi |
| Warehouse / AWB OCR | `WH_AWBExtraction_v1.1.0` | Warehouse | No new confirmed update | — Không đổi |
| PERRI Costing — Sew Agent | `MER_CostingAgenticPlatform_v1.1.0` | Merchandising | V1 done; V2 BA → Khoa | ⚡ Major movement |
| KPI/BSC Performance Management | (New — unregistered) | — | Concept → Structured discovery | 🆕 Mới ghi nhận |
| Smart Factory / Cowash / Hanger | `PROD_HangingLineIoT_v1.0.0` | Production + Wash | Requirements advanced; no build | ⚡ Nhỏ |
| Sourcing / PERRI / DWH | `SCP_SourcingChatbot_v2.3.0` | Sourcing | No new confirmed update | — Không đổi |
| GTAS / Stratova | (Discovery) | — | No new confirmed update | — Không đổi |
| PPJ × UIT / AISC | `EXT_AcademicCollaboration_v1.1.0` | External Collaboration | Event prep active | ⚡ Chuyển động |
| Quansolution B2C | (Strategic hold) | — | No new confirmed update | — Hold |

---

## 3. Cập nhật chi tiết theo dự án

### `FIN_FinanceManagement_v1.2.0` — Nền tảng Kiểm soát Tài chính

**WS3 — Factory Performance:**
- Ba bộ khảo sát 20 câu đã tạo: Accounting/Cost, HR/Payroll, Planning/Production/GTAS.
- Giai đoạn thu thập phản hồi bắt đầu. Deadline: **22/10/2026**.
- Next: Collect responses → Create data/rule/gap register.

**WS4 — Fabric OC:**
- ⚠️ **Constraint confirmed:** Separate Weaving OC và Dyeing OC không có confirmed linkage cross-OC.
- OVH là report-level, không phải OC-wise. NPL tolerance 10% vẫn confirmed.
- Decision needed: Approve mapping approach và OVH allocation driver.

**WS1 / WS2:** No new confirmed update. Baseline từ 9/10 giữ nguyên.

---

### `MER_CostingAgenticPlatform_v1.1.0` — PERRI Costing (Sew / Wash)

- ✅ **Sew V1 completion confirmed.** Các defects về search, ordering, SAM, QC-exclusion, export, operation-existence đã được báo cáo fixed.
- **V2 BA bridge chuyển về Nguyễn Vũ Ánh Khoa.** V2 evidence requirements defined.
- Wash Agent: No new confirmed update.
- Next: Obtain complete golden case, dictionary, mandatory operations; collect controlled V1 pilot feedback.
- Decision needed: Approve V2 boundary, acceptance owner và pilot criteria.

---

### `ADMIN_ExpenseManagement_v1.1.0` — Business Travel / HCQT / eOffice

- ✅ Tất cả 22 loại chi phí đã có **642x / 627x** mapping chi tiết (Mrs. Violet — HCQT_WFX_AccountingMapping_v2.1.1).
- 4 ví dụ Name3 đã có evidence.
- ❌ Chưa có: 641x details cho bất kỳ loại nào. 18/22 WFX Analysis Code còn mở.
- Production import chưa sẵn sàng.
- Conflict cần giải quyết: 6421 vs 6427/6428 evidence mâu thuẫn.
- Decision needed: Approve mapping authority, exceptions, effective date và UAT gate.

---

### `LOG_ExpenseInvoiceProcessing_v1.2.2` — Expense Invoice Automation

- Đang được sử dụng thực tế: 36 fuel invoices đã upload.
- 🔴 **Defects active:**
  - VAT reset sau khi chọn Tax Template (manual re-entry required)
  - PDF/XML attachment issues
  - Airport-invoice linking issues
  - Slow bulk processing
- Risk: Manual re-entry, incomplete evidence, duplicate/error risk.
- Decision needed: Assign hotfix và UAT owner.

---

### `EXT_AcademicCollaboration_v1.1.0` — PPJ × UIT / AISC

- Preliminary-round judge preparation đang tiến hành.
- ❌ UIT contract và PPJ documents còn pending.
- Deadline: **22/10/2026** — confirm panel và document responsibilities.

---

## 4. Milestone Movement

| Milestone | Status |
|---|---|
| Sew Agent V1 completion confirmed | ✅ Completed |
| Finance WS3 surveys created & sent | ✅ Completed |
| HCQT 642x/627x mapping confirmed | ✅ Completed |
| Sew V1 defect set reported fixed | ✅ Completed |
| Finance WS4 constraint (cross-OC lineage) confirmed | ⚠️ Constraint identified |
| Business Travel 641x / Name3 rules | 🔴 Open |
| Invoice automation defect cycle | 🔴 At Risk |
| Sew V2 evidence pack | 🔄 In Progress |
| WS3 survey responses | 🔄 Due 22/10 |
| PPJ × UIT/AISC contract & documents | 🔄 Due 22/10 |

---

## 5. Top 5 Actions — Tuần tới (17–22/10/2026)

1. **Close Fabric OC lineage, GRN source và OVH allocation decisions** — WS4 unblocked.
2. **Complete Business Travel 641x / Name3 rules; run WFX posting golden cases.**
3. **Triage và prioritize invoice-automation defect cycle** — assign hotfix + UAT owner.
4. **Complete Sew V2 evidence pack; start structured V1 pilot feedback.**
5. **Drive WS3 survey completion by 22/10** và consolidate requirements.

---

## 6. Decisions Required

| Priority | Decision | Owner |
|---|---|---|
| P0 | Approve Fabric OC cross-OC mapping approach và OVH allocation driver | Finance/Accounting + IT |
| P0 | Confirm Business Travel accounting authority, exception rules, effective date, UAT gate | Accounting + HCQT + IT/WFX |
| P0 | Assign invoice-automation defect và UAT ownership | Technical team |
| P1 | Mandate WS3 participation; appoint requirements owner | — |
| P1 | Approve Sew V2 discovery boundaries, golden-case minimum, acceptance owner | Nguyễn Vũ Ánh Khoa |
| P1 | Confirm PPJ × UIT/AISC panel và contract/document responsibilities | — |
| P2 | Appoint KPI/BSC sponsor; authorize bounded MVP/BRD phase | — |
| P2 | Gate Smart Factory vendor development by measurable use case và readiness review | — |

---

## 7. Cross-Project Dependencies

1. Accounting/WFX specialists shared across: WS4, Business Travel, Invoice Automation, GDI/GRN, Finance Reporting.
2. WFX master data, APIs và dimensions ảnh hưởng: Travel posting, material flows, OC profitability, consolidated reporting.
3. Business experts cần đồng thời cho: Finance rules, Sew V2 golden cases, invoice regression, WS3 surveys.
4. AI/BA capacity chia giữa: Sew V2 (Khoa), Finance AI, KPI/BSC, production support.

---

## Related Notes

Projects:
[[../../../03_Projects/FIN.AI.FINANCE.MANAGEMENT.v1.1/00_Project_Home]]
[[../../../03_Projects/PPJ.COSTING.AGENT.PLATFORM.v1.1/00_Project_Home]]
[[../../../03_Projects/ADMIN_ExpenseManagement_v1.1.0/00_Project_Home]]
[[../../../03_Projects/PPJ. Expense-Invoices.v1.1/00_Project_Home]]
[[../../../03_Projects/PPJ.UIT.ACADEMIC.COLLABORATION.v1.1/00_Project_Home]]
