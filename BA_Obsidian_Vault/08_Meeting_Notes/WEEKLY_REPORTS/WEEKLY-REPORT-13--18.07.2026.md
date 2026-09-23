# PPJ AI & AUTOMATION TEAM

# WEEKLY PORTFOLIO UPDATE

**Kỳ báo cáo:** 13/07/2026–18/07/2026
**Kỳ kế hoạch tiếp theo:** 20/07/2026–25/07/2026
**Phạm vi:** Các dự án có cập nhật thực tế trong tuần
**Phân loại:** Theo Primary Business Domain và lifecycle hiện tại

## 1. Tóm tắt điều hành

Trong tuần 13/07–18/07/2026, portfolio ghi nhận chuyển động rõ ở ba nhóm:

1. **Hoàn thành kiểm thử hoặc chuẩn bị demo**

   * **`PUR.Material.Allocation.v1.1`** đã hoàn thành kiểm thử luồng phân bổ lại nguyên phụ liệu dư giữa các OC đã tách.
   * **`COSTING.AGENTIC.PLATFORM.v1.1`** đã hoàn thành thử nghiệm bóc tách công đoạn may từ description và chuẩn bị demo.

2. **Chuẩn bị vận hành**

   * **`PPJ.ExpenseInvoices.v1.1`** đã chốt kỳ hóa đơn chi phí, bắt đầu nhận mapping từ các đơn vị và bước vào giai đoạn pre-go-live.
   * **`SCP.SOURCING.CHATBOT.v2.3`** đã thực hiện buổi training lần thứ ba.
   * **`FD.Datamart.v2.2`** chính thức chuyển từ active delivery sang support.

3. **Điều chỉnh định hướng hoặc chờ quyết định**

   * **`HR.SSPFD.Workflow.v1.1`** được định hướng chuyển giao cho team Phần mềm.
   * **`PPJxQSee.AI`** đã nhận proposal chính thức và cần thực hiện đánh giá hợp tác chi tiết.
   * **`FIN.AI.FINANCE.MANAGEMENT.v1.2`** được tái định vị từ chatbot/reporting đơn thuần thành nền tảng kiểm soát, đối chiếu và phân tích tài chính tập trung, với ưu tiên đầu tiên là kiểm soát chi phí theo OC và quản lý ngoại lệ. 

## 2. Portfolio Movement Summary

| Dự án                                | Domain                      | Trạng thái đầu tuần | Cập nhật chính                                                               | Trạng thái cuối tuần         |
| ------------------------------------ | --------------------------- | ------------------- | ---------------------------------------------------------------------------- | ---------------------------- |
| **`FIN.AI.FINANCE.MANAGEMENT.v1.2`** | Finance / Accounting        | Business analysis   | Scope được tái cấu trúc theo hướng financial control và exception management | Discovery / Control Design   |
| **`COSTING.AGENTIC.PLATFORM.v1.1`**  | Merchandising               | Sew-first analysis  | Hoàn thành test bóc tách công đoạn may; Wash Agent được làm rõ MVP           | Prototype / Demo Preparation |
| **`PUR.Material.Allocation.v1.1`**   | Sourcing / Purchasing       | First-flow testing  | Hoàn thành test unreserve và allocate giữa các OC đã tách                    | Validated First Flow         |
| **`PPJ.ExpenseInvoices.v1.1`**       | Finance / Accounting        | UAT                 | Chốt kỳ hóa đơn, nhận mapping, chạy test và sửa bug                          | Pre-go-live                  |
| **`SCP.SOURCING.CHATBOT.v2.3`**      | Sourcing / Purchasing       | UAT / Adoption      | Hoàn thành training lần 3                                                    | User Adoption / Guided UAT   |
| **`HR.SSPFD.Workflow.v1.1`**         | HR                          | Analysis            | Thống nhất hướng chuyển giao cho team Phần mềm                               | Transfer Preparation         |
| **`FD.Datamart.v2.2`**               | Fabric / Textiles Technique | Closeout            | Chuyển sang support                                                          | Maintenance / Support        |
| **`PPJxQSee.AI`**                    | QC / TQM                    | Awaiting proposal   | Đã nhận proposal chính thức                                                  | Proposal Evaluation          |

## 3. Cập nhật chi tiết theo dự án

## **`FIN.AI.FINANCE.MANAGEMENT.v1.2`**

**Nền tảng kiểm soát và phân tích tài chính tập trung**

**Domain:** Finance / Accounting
**Business Owner:** Phòng Kế toán
**Current Status:** Discovery / Control Design / Business Rule Definition

### Goal

Xây dựng nền tảng giúp Phòng Kế toán:

* Kiểm tra mức độ đầy đủ của dữ liệu trước khi đóng sổ;
* Đối chiếu chi phí kế hoạch và thực tế;
* Phát hiện chi phí thiếu, sai OC hoặc sai kỳ;
* Quản lý ngoại lệ và người chịu trách nhiệm xử lý;
* Tự động kiểm tra lại sau khi dữ liệu được điều chỉnh;
* Cung cấp dữ liệu đáng tin cậy cho Power BI và trợ lý AI.

### Primary Output

Sản phẩm ưu tiên đầu tiên không còn là chatbot độc lập.

MVP giai đoạn đầu được xác định là:

> **Công cụ đối chiếu chi phí và quản lý ngoại lệ theo OC**

MVP tập trung vào:

* Nguyên phụ liệu;
* Chi phí gia công;
* Overhead cơ bản;
* Ghi nhận đúng OC;
* Ghi nhận đúng kỳ;
* Phát hiện thiếu chi phí;
* Quản lý ngoại lệ;
* Giao người xử lý;
* Tự kiểm tra lại;
* Truy vết nguồn và bằng chứng.

### Latest Update

Sau buổi làm việc ngày 17/07/2026, project đã được tái định vị.

Pain point lớn nhất của Kế toán không phải là hệ thống chưa tính được số liệu, mà là:

* Chưa biết dữ liệu đã đầy đủ chưa;
* Chi phí đã được ghi nhận đúng đơn hàng chưa;
* Chi phí đã được ghi nhận đúng kỳ chưa;
* Một OC có lợi nhuận cao có phải do thiếu chi phí không;
* Chứng từ nào đang thiếu;
* Đơn vị nào phải chịu trách nhiệm xử lý;
* Dữ liệu đã được điều chỉnh và kiểm tra lại hay chưa.

Vì vậy, nguyên tắc mới là:

```text
Kiểm soát dữ liệu
→ Xử lý ngoại lệ
→ Xác nhận dữ liệu đáng tin cậy
→ Tổng hợp báo cáo
→ Phân tích
→ AI hỗ trợ hỏi đáp
```

Latest BRD đã nâng mã chương trình từ **`v1.1`** lên **`v1.2`** và hợp nhất chương trình thành một nền tảng kiểm soát tài chính tổng thể. 

### Next Actions

1. Thu 20–30 OC mẫu để kiểm thử.
2. Thu Costing plan đã được phê duyệt.
3. Thu BOM và dữ liệu định mức.
4. Thu dữ liệu xuất và trả nguyên phụ liệu.
5. Thu PO, receipt, invoice và accounting posting của các công đoạn gia công.
6. Xây danh mục chi phí chuẩn.
7. Xây danh mục ngoại lệ.
8. Xác định owner cho từng loại ngoại lệ.
9. Xác định ngưỡng kiểm soát.
10. Thiết kế giao diện danh sách ngoại lệ và luồng giao xử lý.

### Risks / Decisions Required

* Chưa chốt source Costing chính thức;
* Chưa chốt cách lựa chọn Costing version;
* Chưa chốt ngưỡng chênh lệch nguyên phụ liệu;
* Chưa chốt quy tắc xác định đúng kỳ;
* Chưa xác định đầy đủ responsible owner theo từng exception;
* Portfolio registry cần xác nhận chính thức việc chuyển code từ `v1.1` sang `v1.2`.

## **`COSTING.AGENTIC.PLATFORM.v1.1`**

**Costing Agentic Platform**

**Domain:** Merchandising
**Current Status:** Sew Prototype / Wash Discovery
**Primary Output:** Costing / Quotation Package cho Merchandising review

### Goal

Hỗ trợ Merchandising tạo costing nhanh hơn để review và propose quotation cho khách hàng.

Platform dự kiến gồm:

* Sew Costing;
* BOM Costing;
* Wash Costing;
* Fabric Consumption Costing;
* Historical Costing;
* Cost Consolidation.

### Latest Update — Sew Costing

Team đã hoàn thành test khả năng:

> Bóc tách các công đoạn may dựa trên product hoặc sewing description.

Current prototype flow:

```text
Sewing Description
→ Description Analysis
→ Sewing Operation Extraction
→ Standardized Operation List
→ Expert Review
```

Kết quả hiện tại chứng minh khả năng chuyển description thành danh sách công đoạn may có cấu trúc.

### Current Output

* Danh sách công đoạn được bóc tách;
* Thứ tự hoặc nhóm công đoạn sơ bộ;
* Input chuẩn bị cho bước mapping với operation standard;
* Cơ sở để phát triển tiếp SMV, CM và Sew Cost.

### Next Actions — Sew

1. Tổ chức buổi demo trong tuần tiếp theo.
2. Cho Sew experts kiểm tra danh sách công đoạn.
3. Đánh giá:

   * Công đoạn đúng;
   * Công đoạn thiếu;
   * Công đoạn thừa;
   * Thứ tự sai;
   * Description không đủ thông tin.
4. Xác định accuracy baseline.
5. Mapping operation với machine type và standard time.
6. Chỉ phát triển tính Sew Cost sau khi operation extraction được validate.

### Latest Update — Wash Agent

Wash Agent đã được làm rõ theo hướng không bắt đầu từ Techpack parsing.

MVP phù hợp hơn là:

```text
User Free-text Description
+ Fabric Information
+ Base / Desired Color
+ Target Shade / Effect
+ Image hoặc Sample Reference
        ↓
Wash Attribute Extraction
        ↓
Missing Information Check
        ↓
Similar Recipe Retrieval
        ↓
Draft Process Recommendation
        ↓
Wash Expert Review
```

Agent phải nhận text tự do nhưng bên dưới vẫn extract thành structured fields để search và kiểm soát. Recipe cũ chỉ được dùng làm reference; mọi output phải được Wash expert review. 

### Primary Wash Output

* Structured Wash Request;
* Extracted Wash Attributes;
* Missing Information Warning;
* Similar Recipe List;
* Similarity Score và match reason;
* Draft Wash Process;
* Risk Warning;
* Expert Review Result.

### Next Actions — Wash

1. Thu 20–30 wash requests thực tế.
2. Thu recipe và process tương ứng.
3. Xây Wash Type Taxonomy.
4. Xác định output chính thức của phòng Wash.
5. Xác định nơi lưu recipe hiện tại.
6. Làm rõ integration với IED Wash và GTAS.
7. Xác định expert approval process.
8. Xây first similarity-search prototype.

### Risks / Decisions Required

* Sew operation extraction chưa đồng nghĩa với Sew Costing hoàn chỉnh;
* Description có thể thiếu technical details;
* Wash input không chuẩn hóa giữa hơn 150 buyers;
* Wash recipe có mức độ rủi ro cao và không được tự động áp dụng;
* Cần tách rõ expert recommendation và final approved costing.

## **`PUR.Material.Allocation.v1.1`**

**Material Allocation Automation**

**Domain:** Sourcing / Purchasing
**Current Status:** First Flow Validated

### Goal

Tự động hóa luồng xử lý nguyên phụ liệu dư giữa các OC đã được tách, đồng thời giảm thao tác thủ công và hạn chế sai allocation trên WFX.

### Tested Business Scenario

Team đã hoàn thành test cho trường hợp:

1. Một Style có OC nguyên phụ liệu còn dư;
2. Phạm vi hiện tại áp dụng cho các công đoạn:

   * May;
   * Thêu;
3. Nguyên phụ liệu dư đang được reserve tại OC nguồn;
4. Hệ thống thực hiện unreserve;
5. Hệ thống xác định các OC đích:

   * Cùng Style;
   * Cùng Buyer Reference;
   * Là các đơn hàng khách đã được tách;
6. Nguyên phụ liệu được allocate từ OC nguồn sang OC đích.

### Validated Flow

```text
Source OC có NPL dư
→ Kiểm tra lượng dư
→ Unreserve khỏi Source OC
→ Tìm Destination OC phù hợp
→ Validate cùng Style / Buyer Reference
→ Allocate sang Destination OC
→ Kiểm tra kết quả
```

### Primary Output

* Validated unreserve flow;
* Validated destination-OC matching;
* Validated allocation flow;
* Cơ sở để tiếp tục xây UI và controlled transaction process.

### Next Actions

1. Test nhiều source OCs cho một destination OC.
2. Test một source OC phân bổ cho nhiều destination OCs.
3. Test partial allocation.
4. Test insufficient quantity.
5. Test OC không cùng Buyer Reference.
6. Test duplicate allocation.
7. Test transaction failure và retry.
8. Xác định audit log.
9. Xác định user review trước khi post.
10. Chuẩn bị UAT với chị Tuyết và Precision users.

### Risks / Decisions Required

* Phạm vi hiện mới xác nhận cho May và Thêu;
* Chưa xác nhận các NPL flow khác;
* Cần kiểm soát trường hợp quantity thay đổi trong lúc xử lý;
* Cần xác định rollback khi unreserve thành công nhưng allocation thất bại;
* Không nên mở rộng trước khi exception cases được test.

## **`PPJ.ExpenseInvoices.v1.1`**

**Expense Invoice Self-service Application**

**Domain:** Finance / Accounting
**Current Status:** Pre-go-live / Mapping Validation / User Testing

### Goal

Triển khai quy trình xử lý hóa đơn chi phí cho toàn bộ phòng ban và nhà máy, ngoại trừ khối Xuất khẩu.

### Current Scope

* Tất cả phòng ban;
* Các nhà máy;
* Không bao gồm Xuất khẩu;
* Department users gửi mapping và dữ liệu;
* Accounting review và xác nhận;
* Team hỗ trợ mapping, thao tác và lỗi hệ thống.

### Latest Update

Đầu tuần, team và business users đã chốt kỳ hóa đơn chi phí cần xử lý.

Sau khi chốt kỳ:

* Các chị user bắt đầu gửi bảng mapping;
* Team bắt đầu chạy test trên dữ liệu thực tế;
* Team đang follow-up từng đơn vị;
* Mapping được cập nhật liên tục;
* User được hỗ trợ thao tác upload và xử lý;
* Các bug phát sinh được ghi nhận và sửa trong giai đoạn pre-go-live.

### Current Workflow

```text
Department / Factory
→ Chuẩn bị Invoice Mapping
→ Gửi Mapping và Input
→ Team Validate
→ Update Mapping
→ User Test Upload
→ Accounting Review
→ Bug Fix / Retest
→ Go-live Readiness
```

### Primary Output

* Approved Mapping Table;
* Validated User Upload;
* Error and Defect List;
* Corrected Records;
* Pre-go-live Checklist;
* User Support Guide.

### Next Actions

1. Theo dõi các đơn vị chưa gửi mapping.
2. Kiểm tra completeness của mapping.
3. Kiểm tra duplicate invoice.
4. Kiểm tra company, factory và department mapping.
5. Kiểm tra ledger/account mapping.
6. Kiểm tra lỗi upload.
7. Fix và retest.
8. Chốt cut-off cho mapping changes.
9. Chốt go-live date.
10. Chốt production support owner và escalation process.

### Risks / Decisions Required

* Mapping thay đổi liên tục sát go-live;
* User sử dụng template khác nhau;
* Một số phòng ban chưa hoàn thành input;
* Bug chỉ xuất hiện khi dùng dữ liệu thật;
* Cần tránh go-live khi mapping chưa được Accounting phê duyệt.

## **`SCP.SOURCING.CHATBOT.v2.3`**

**Sourcing Chatbot and Data Platform**

**Domain:** Sourcing / Purchasing
**Current Status:** Guided UAT / User Adoption

### Goal

Hỗ trợ Sourcing users tìm kiếm và truy xuất dữ liệu supplier, fabric, trims, material và sample.

### Latest Update

Team đã thực hiện buổi training hướng dẫn lần thứ ba cho:

* Chị Lâm;
* Chị Minh Anh.

Buổi training tập trung vào:

* Đăng nhập và sử dụng hệ thống;
* Truy cập đúng quyền;
* Cách đặt câu hỏi;
* Cách tìm kiếm dữ liệu;
* Cách kiểm tra kết quả;
* Cách ghi nhận feedback và báo lỗi.

### Primary Output

* User đã được hướng dẫn trực tiếp;
* Các use cases thực tế tiếp tục được kiểm thử;
* Feedback từ user được đưa vào backlog;
* Mức độ adoption được cải thiện.

### Next Actions

1. Theo dõi tần suất sử dụng sau training.
2. Thu câu hỏi thực tế từ chị Lâm và chị Minh Anh.
3. Đánh giá search success rate.
4. Phân loại:

   * Data issue;
   * Search issue;
   * Permission issue;
   * Answer-quality issue;
   * Training issue.
5. Fix và retest.
6. Chốt UAT acceptance owner.
7. Chuẩn bị quick user guide.

### Risk

Nếu user không sử dụng hệ thống sau training, cần phân biệt nguyên nhân là:

* Chưa có thói quen;
* Dữ liệu chưa đủ;
* Search chưa đúng;
* Permission phức tạp;
* Use case chưa tạo đủ value.

## **`HR.SSPFD.Workflow.v1.1`**

**HR / BHXH Workflow**

**Domain:** HR
**Current Status:** Transfer Preparation

### Goal ban đầu

Phân tích và audit dữ liệu HR, payroll và BHXH, với MVP ban đầu tập trung vào dữ liệu BHXH của GREA.

### Latest Update

Sau buổi họp, các bên nhận định dự án phù hợp hơn để chuyển giao cho team Phần mềm.

Điều này cho thấy solution có xu hướng nghiêng về:

* Business application;
* Workflow management;
* Data-processing software;
* Rule-based validation;
* User-facing system;

thay vì là một AI-led initiative trong giai đoạn hiện tại.

### Current Decision

Dự án chưa nên xem là hoàn thành.

Lifecycle phù hợp là:

> **Transfer Preparation / Pending Handover**

### Handover Outputs Required

1. Business context.
2. Current problem.
3. MVP scope.
4. Data sources.
5. Field inventory.
6. Audit rules đã thu thập.
7. Current process.
8. Target workflow.
9. User roles.
10. Security requirements.
11. Open questions.
12. Existing samples và meeting notes.

### Risks / Decisions Required

* Chưa xác định software-team owner;
* Chưa chốt phạm vi team AI còn tiếp tục hỗ trợ;
* Dữ liệu HR có mức bảo mật cao;
* Không nên chuyển giao chỉ bằng trao đổi miệng;
* Cần có handover acceptance rõ ràng.

## **`FD.Datamart.v2.2`**

**Fabric / Hanger / QR Datamart**

**Domain:** Fabric / Textiles Technique
**Current Status:** Maintenance / Support

### Goal

Quản lý dữ liệu Fabric, Hanger và QR phục vụ tra cứu, quản lý mẫu và vận hành FD.

### Latest Update

Project đã chuyển từ active delivery sang support.

Điều này xác nhận:

* Current implementation scope đã hoàn thành;
* Training và chuyển giao sử dụng đã thực hiện;
* Các yêu cầu tiếp theo không còn nằm trong active delivery scope;
* Defects và enhancement mới được đưa vào support backlog.

### Support Scope

* User support;
* Bug fixing;
* Data correction;
* QR/Hanger configuration support;
* Permission support;
* Minor enhancement assessment;
* Production monitoring.

### Required Governance

Cần tách rõ:

| Loại yêu cầu         | Cách xử lý                   |
| -------------------- | ---------------------------- |
| Production defect    | Support priority             |
| Data correction      | Data-support task            |
| Small configuration  | Maintenance                  |
| New function         | Enhancement request          |
| Major process change | New version hoặc new project |

## **`PPJxQSee.AI`**

**QC AI Vision PoC**

**Domain:** QC / TQM
**Current Status:** Formal Proposal Evaluation

### Goal

Đánh giá khả năng hợp tác với QSee trong các use cases:

* QC AI Vision;
* Defect detection;
* Visual inspection;
* Realtime quality data;
* Customer quality transparency;
* Potential reduction of third-party inspection.

### Latest Update

* QSee đã gửi proposal chính thức;
* Team QC PPJ đã nhận proposal;
* Chị Tiên đề nghị AI & Automation Team đánh giá;
* Team cần đưa ra khuyến nghị hợp tác chi tiết.

### Primary Output của giai đoạn hiện tại

> **QSee Collaboration Evaluation and Recommendation**

Đây chưa phải quyết định triển khai.

### Evaluation Dimensions

#### 1. Business Fit

* Pain point nào được giải quyết;
* Sản phẩm hoặc công đoạn nào được áp dụng;
* Internal QC value;
* Customer-facing value;
* Có giảm manual inspection hoặc third-party inspection không.

#### 2. PoC Scope

* Pilot product;
* Defect categories;
* Sample size;
* Factory/location;
* Camera/device;
* Process stage;
* PoC duration.

#### 3. Technical Feasibility

* Model architecture;
* Image requirements;
* Processing speed;
* Realtime capability;
* Integration;
* Dashboard/API;
* Deployment model;
* Infrastructure requirement.

#### 4. Accuracy and Acceptance

* Detection accuracy;
* False-positive rate;
* False-negative rate;
* Defect-class accuracy;
* Ground-truth process;
* QC validation owner;
* Acceptance threshold.

#### 5. Data and Security

* Data ownership;
* Image ownership;
* Customer-data confidentiality;
* Data-storage location;
* Model-training rights;
* Retention;
* Reuse of PPJ data.

#### 6. Commercial Model

* PoC cost;
* Hardware cost;
* Software/license cost;
* Implementation cost;
* Annual support cost;
* Customer cost-sharing;
* Payment milestone;
* Exit cost.

#### 7. Operational Readiness

* Factory setup;
* Lighting and environment;
* Operator training;
* Maintenance;
* Support SLA;
* Device replacement;
* Scalability across products and factories.

### Next Actions

1. Review proposal theo evaluation matrix.
2. Extract commitments, assumptions và exclusions.
3. Làm rõ pilot JC hoặc pilot scope chính thức.
4. Xác định dataset requirement.
5. Làm việc với QC để chốt top defects.
6. Xác định ground-truth labeling process.
7. Xây PoC success criteria.
8. Làm rõ data ownership.
9. Làm rõ cost và commercial terms.
10. Đưa ra recommendation:

* Proceed;
* Proceed with Conditions;
* Request Proposal Revision;
* Hold;
* Reject.

### Key Risks

* Proposal rộng hơn nhu cầu PPJ;
* KPI PoC không rõ;
* Dataset không đủ;
* Vendor giữ quyền sử dụng PPJ data;
* Customer-sharing concept chưa có governance;
* Cost phát sinh sau PoC;
* Model hoạt động tốt trong trial nhưng không ổn định tại factory.

## 4. Các thay đổi lifecycle trong tuần

| Dự án                                | Lifecycle cũ                        | Lifecycle mới                                          |
| ------------------------------------ | ----------------------------------- | ------------------------------------------------------ |
| **`PUR.Material.Allocation.v1.1`**   | First Flow Testing                  | First Flow Validated / Extended Testing                |
| **`COSTING.AGENTIC.PLATFORM.v1.1`**  | Analysis                            | Sew Prototype / Demo Preparation                       |
| **`PPJ.ExpenseInvoices.v1.1`**       | UAT                                 | Pre-go-live                                            |
| **`HR.SSPFD.Workflow.v1.1`**         | Analysis                            | Transfer Preparation                                   |
| **`SCP.SOURCING.CHATBOT.v2.3`**      | UAT                                 | Guided UAT / Adoption                                  |
| **`FD.Datamart.v2.2`**               | Closeout                            | Maintenance / Support                                  |
| **`PPJxQSee.AI`**                    | Awaiting Proposal                   | Formal Proposal Evaluation                             |
| **`FIN.AI.FINANCE.MANAGEMENT.v1.1`** | Finance Chatbot and Reporting Scope | Proposed update to `v1.2` — Financial Control Platform |

## 5. Ưu tiên tuần 20/07–25/07/2026

| Priority | Project                                    | Required Output                                                     |
| -------: | ------------------------------------------ | ------------------------------------------------------------------- |
|       P1 | **`FIN.AI.FINANCE.MANAGEMENT.v1.2`**       | OC sample set, exception catalogue và control-process specification |
|       P2 | **`COSTING.AGENTIC.PLATFORM.v1.1`**        | Sew extraction demo và expert-validation result                     |
|       P3 | **`PPJ.ExpenseInvoices.v1.1`**             | Completed mapping, defect closure và go-live readiness decision     |
|       P4 | **`PPJxQSee.AI`**                          | Proposal evaluation và collaboration recommendation                 |
|       P5 | **`PUR.Material.Allocation.v1.1`**         | Exception-case testing và UAT plan                                  |
|       P6 | **`HR.SSPFD.Workflow.v1.1`**               | Software-team handover package                                      |
|       P7 | **`SCP.SOURCING.CHATBOT.v2.3`**            | Post-training usage assessment và prioritized feedback              |
|       P8 | **`FD.Datamart.v2.2`**                     | Support ownership và maintenance backlog                            |
|       P9 | **`COSTING.AGENTIC.PLATFORM.v1.1 — Wash`** | Wash dataset request và MVP input/output confirmation               |

## 6. Management Attention

### Finance scope đã thay đổi đáng kể

Portfolio registry, WBS và roadmap cần được cập nhật theo latest BRD. Không nên tiếp tục quản lý Finance chỉ như hai sản phẩm chatbot và upload report. Trọng tâm trước mắt là financial-control foundation.

### Sew Costing mới hoàn thành operation extraction

Milestone này tích cực nhưng chưa đồng nghĩa với việc đã tính được SMV, CM hoặc total Sew Cost. Buổi demo tuần sau cần đánh giá đúng phạm vi này.

### Expense Invoices đang ở thời điểm nhạy cảm trước go-live

Mapping, user behavior và bug từ dữ liệu thật cần được ổn định trước khi chốt vận hành.

### Material Allocation cần ưu tiên exception testing

Happy path đã được chứng minh. Bước tiếp theo phải là transaction safety, rollback và auditability.

### HR cần handover chính thức

Việc chuyển cho team Phần mềm cần có tài liệu, owner và acceptance; không nên chỉ đổi người phụ trách trên portfolio board.

### QSee cần được đánh giá như một quyết định đầu tư

Không chỉ đánh giá model AI. Cần đánh giá business outcome, operational burden, data ownership, cost và khả năng scale.

## 7. Kết luận tuần

Trong tuần 13/07–18/07/2026, portfolio có tiến triển rõ từ analysis sang validation và operational decision.

* **`PUR.Material.Allocation.v1.1`** đã chứng minh được first business flow.
* **`COSTING.AGENTIC.PLATFORM.v1.1`** đã có prototype bóc tách công đoạn may và một hướng Wash Agent thực tế hơn.
* **`PPJ.ExpenseInvoices.v1.1`** bước vào pre-go-live với dữ liệu và mapping thực tế.
* **`SCP.SOURCING.CHATBOT.v2.3`** tiếp tục user adoption qua training lần ba.
* **`FD.Datamart.v2.2`** đã chuyển sang support.
* **`HR.SSPFD.Workflow.v1.1`** chuẩn bị chuyển giao.
* **`PPJxQSee.AI`** chuyển từ chờ proposal sang giai đoạn evaluation.
* **`FIN.AI.FINANCE.MANAGEMENT`** được tái định vị theo hướng kiểm soát dữ liệu, đối chiếu chi phí và quản lý ngoại lệ trước khi phát triển lớp phân tích và AI.

