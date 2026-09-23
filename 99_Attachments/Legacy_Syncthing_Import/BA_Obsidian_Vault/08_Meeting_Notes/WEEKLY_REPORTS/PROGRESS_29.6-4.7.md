# WEEKLY EXECUTIVE RECAP

## AI / Automation / Data Portfolio

## Tuần 29/06–05/07/2026

---

# 1. Executive Summary

Trong tuần 29/06–05/07/2026, portfolio AI / Automation / Data ghi nhận một số thay đổi quan trọng về strategic direction, project lifecycle, testing, business adoption và external collaboration.

Thay đổi lớn nhất trong tuần là việc chính thức kick-off dự án **`FIN.AI.FINANCE.MANAGEMENT.v1.1`** vào ngày **04/07/2026**. Đây được xác định là một trong các dự án trọng tâm mới của AI & Automation Team.

Sau buổi kick-off, scope dự án đã được làm rõ đáng kể. Dự án hiện **không tập trung vào Cash Flow Analysis hoặc Cash Flow Forecasting** như ý tưởng ban đầu. Phạm vi thực tế được tổ chức thành ba workstream:

1. **Financial Reporting Automation** — ưu tiên số 1 và là MVP đầu tiên.
    
2. **Costing Analysis** — so sánh Target/Planned Cost với Actual Cost.
    
3. **Order / Sales Efficiency Analysis** — giải thích hiệu quả mã hàng/đơn hàng theo góc nhìn Finance.
    

Mục tiêu trước mắt là giảm quy trình báo cáo tài chính thủ công, hạn chế copy/paste và nhập lại dữ liệu nhiều lần, chuẩn hóa luồng từ nguồn dữ liệu đến báo cáo Finance, đồng thời xây dựng nền dữ liệu có khả năng truy vết và tái sử dụng. Sau khi reporting foundation được thiết lập, dự án mới mở rộng sang phân tích costing và hiệu quả đơn hàng.

Dự án chiến lược thứ hai tiếp tục có tiến triển là **`COSTING.AGENTIC.PLATFORM.v1.1`**. Team đã bắt đầu chuyển từ định hướng multi-agent tổng thể sang triển khai thực tế theo hướng **Sew-first**. Lâm tiếp tục follow-up, phân tích nghiệp vụ và bắt đầu xin dữ liệu lịch sử, thông tin kỹ thuật và kinh nghiệm thực tế của phòng Sew để xây domain costing đầu tiên trước khi mở rộng sang Wash, Cut và BOM.

**`SCP.SOURCING.CHATBOT.v2.3`** tiếp tục đi sâu vào quá trình kiểm thử. Trong tuần, project đã hoàn thành **demo lần thứ ba**, tiếp tục thu thập feedback và các yêu cầu chỉnh sửa liên quan đến chatbot, search logic, data retrieval và trải nghiệm người dùng.

Ở nhóm external AI collaboration, **`PPJxQSee.AI`** đã chính thức kick-off và bắt đầu quá trình thu thập, chuẩn hóa và gửi sample data cho PoC QC AI. Trong khi đó, **`QC.Primo1D.RFID.Thread.v1.0`** vẫn chưa có initial contact chính thức với vendor; project hiện mới ở giai đoạn internal alignment sau khi đã report với anh Cường và đang chờ phía QC xác định nhân sự phụ trách.

Nhóm invoice automation tiếp tục có thay đổi quan trọng về lifecycle. **`EXIM.ExpenseInvoices.Automation.v1.1`** đã hoàn tất và đóng toàn bộ scope. Từ nền tảng đó, **`PPJ.ExpenseInvoices.v1.1`** đang được mở rộng cho Accounting và các phòng ban liên quan, hiện đã bước vào UAT, tiếp tục sửa lỗi và kiểm thử. **`PPJ.InvoiceDownloader.v1.2`** bắt đầu tạo business value thực tế khi chị Bình đã nhận dữ liệu và bắt đầu xây dựng báo cáo, dashboard và các phần việc nghiệp vụ tiếp theo.

**`PUR.GDI.Automation.v1.0`** có bước tiến đáng kể về technical feasibility. Team kỹ thuật đã xác định được cách lấy đầy đủ dữ liệu cần thiết từ nhiều màn hình hệ thống và có thể bypass bước user confirmation. User cuối có thể chỉ cần cung cấp ba thông tin chính: **style, mã hàng và chi nhánh công ty**. Dự án hiện cần được re-scope để xác định mức độ automation phù hợp và đánh giá rủi ro trước khi tiếp tục.

**`FD.Datamart.v2.2`** đã hoàn thành toàn bộ các cập nhật chính trong tuần và chuẩn bị project closeout từ tuần bắt đầu ngày 06/07/2026.

**`MER.MARKET.INTELLIGENCE.v1.1`** tiếp tục được khóa đúng scope là Market Intelligence, không phải một project e-commerce độc lập. Team tiếp tục follow-up dữ liệu đa nguồn từ sales history, PO, customer, inventory, product history và Quince consumer signals.

Về partnership, **`PPJ.UIT.ACADEMIC.COLLABORATION.v1.1`** đã có bước tiến quan trọng khi Madame Hồng Phương và phía Khoa Hệ thống Thông tin – UIT xác nhận định hướng hợp tác. Bước tiếp theo là chuyển từ định hướng chung sang các workstream cụ thể về khóa luận, đồ án, AISC, mentoring và các bài toán thực tế của PPJ.

Trong tuần, các project **`MER.PO.Commit.v1.1`**, **`EXIM.ExpenseInvoices.Automation.v1.1`**, **`AI.Automation.Workshop.202606`** và **`VITAS.Sharing.202606`** cũng được chính thức đóng toàn bộ scope.

---

# 2. Portfolio Movement Summary

|Project Code|Phase hiện tại|Cập nhật chính trong tuần|
|---|---|---|
|`FIN.AI.FINANCE.MANAGEMENT.v1.1`|Discovery / BRD / Strategic Program|Kick-off ngày 04/07; khóa lại 3 workstream; Financial Reporting Automation là MVP P1|
|`COSTING.AGENTIC.PLATFORM.v1.1`|Analysis / Data Acquisition|Chuyển sang Sew-first approach; bắt đầu xin dữ liệu và phân tích costing cho phòng Sew|
|`SCP.SOURCING.CHATBOT.v2.3`|UAT / Iterative Improvement|Hoàn thành demo lần 3; tiếp tục ghi nhận và xử lý change requests|
|`PPJxQSee.AI`|PoC / Sample Data Collection|Đã kick-off và bắt đầu gửi sample data|
|`QC.Primo1D.RFID.Thread.v1.0`|Pre-contact / Internal Alignment|Chưa initial contact; đã report anh Cường; QC đang xác định nhân sự|
|`PUR.GDI.Automation.v1.0`|Scope Reassessment|Technical feasibility được xác nhận; có thể bypass user confirm|
|`PPJ.ExpenseInvoices.v1.1`|UAT / Cross-department Expansion|Đang mở rộng scope, sửa lỗi và kiểm thử với Accounting/liên phòng ban|
|`PPJ.InvoiceDownloader.v1.2`|Production / Business Adoption|Chị Bình đã nhận dữ liệu và bắt đầu xây report/dashboard|
|`FD.Datamart.v2.2`|Final Stabilization / Closeout|Fully updated; chuẩn bị project closeout từ tuần 06/07|
|`MER.MARKET.INTELLIGENCE.v1.1`|Analysis / Multi-source Data Follow-up|Tiếp tục follow-up dữ liệu đa nguồn; khóa scope là Market Intelligence|
|`PPJ.UIT.ACADEMIC.COLLABORATION.v1.1`|Partnership Follow-up|Management và UIT đã xác nhận định hướng hợp tác|
|`MER.PO.Commit.v1.1`|Closed|Hoàn tất và đóng toàn bộ scope|
|`EXIM.ExpenseInvoices.Automation.v1.1`|Closed|Hoàn tất project|
|`AI.Automation.Workshop.202606`|Closed|Hoàn tất toàn bộ project|
|`VITAS.Sharing.202606`|Closed|Hoàn tất sharing/conference và đóng toàn bộ scope|

---

# 3. Strategic Project Updates

## 3.1 `FIN.AI.FINANCE.MANAGEMENT.v1.1`

**Tên hiển thị:** AI-assisted Finance Management  
**Phase:** Discovery / BRD / Strategic Program  
**Kick-off:** 04/07/2026  
**Executive Sponsor:** Madame Hồng Phương  
**Primary Business Domain:** Finance / Accounting

### Strategic Scope Correction

Sau kick-off, project được làm rõ rằng:

**Không phải Cash Flow Analytics project trong giai đoạn hiện tại.**

Các nội dung sau chưa thuộc MVP:

- Cash flow analysis.
    
- Cash flow forecasting.
    
- Banking integration.
    
- Payment recommendation.
    
- Predictive finance.
    
- AI chatbot cho Finance.
    

Thay vào đó, project hiện có ba workstream chính.

### Workstream 1 — Financial Reporting Automation

**Priority:** P1  
**Status:** Start First

Đây là use case ưu tiên số 1 và là MVP đầu tiên.

Current process hiện có nhiều bước thủ công:

```text
WFX / Source System
        ↓
Export Report
        ↓
Excel Processing
        ↓
Mapping / Calculation
        ↓
Finance Template
        ↓
Email to Management
        ↓
Further Excel Processing
        ↓
Power BI / Dashboard
```

Mục tiêu là chuyển sang:

```text
Business Source
        ↓
Data Extraction
        ↓
DWH / Staging
        ↓
Mapping & Transformation
        ↓
Central Finance Dataset
        ↓
Approved Financial Report
        ↓
Management Output / Power BI
```

Đối với các công ty chưa có trên hệ thống:

```text
Subsidiary User
        ↓
Standard Input / Secure Portal
        ↓
Validation
        ↓
Central Finance Dataset
        ↓
Group Reporting
```

### Business Objectives

- Giảm export/copy/paste thủ công.
    
- Giảm nhập lại cùng một dữ liệu nhiều lần.
    
- Tập trung dữ liệu tại một nơi.
    
- Chuẩn hóa source-to-report flow.
    
- Cho phép source update được refresh xuống downstream output.
    
- Tăng traceability.
    
- Giảm workload cuối kỳ.
    
- Hỗ trợ nhiều company/entity.
    

### MVP 1

MVP đầu tiên nên giới hạn ở:

- Một company.
    
- Một period.
    
- Một financial report.
    
- Một approved Finance template.
    

Input:

- WFX source report.
    
- Finance mapping.
    
- Finance target template.
    

Process:

```text
Extract
→ Map
→ Transform
→ Store
→ Output
```

Acceptance principle:

**Automated Report phải reconcile được với Manual Approved Report.**

Các field và total đã được approve cần match 100%, hoặc mọi chênh lệch phải được giải thích.

---

### Workstream 2 — Costing Analysis

**Priority:** P2

Sau khi reporting foundation đủ ổn định, project sẽ mở rộng sang phân tích:

```text
Target / Planned Cost
        vs
Actual Cost
        ↓
Variance
        ↓
Major Cost Driver
        ↓
Root Cause
        ↓
Management Insight
```

Trọng tâm phân tích là:

**Style / Mã hàng**

OC được sử dụng như một linking entity khi cần kết nối:

- Sales.
    
- Order.
    
- Production.
    
- Factory.
    
- Cost.
    

Potential dimensions:

- Company.
    
- Factory.
    
- Customer.
    
- Style.
    
- OC.
    
- Quantity.
    
- Revenue.
    
- Major cost group.
    

### Main Requirement

Finance cần xác định chính thức:

- Target Cost definition.
    
- Actual Cost definition.
    
- Cost buckets.
    
- Allocation rule.
    
- Finance Efficiency.
    
- Mapping Target ↔ Actual.
    

---

### Workstream 3 — Order / Sales Efficiency Analysis

**Priority:** P3

Workstream này sử dụng foundation từ Costing Analysis để trả lời:

- Mã hàng này có hiệu quả thực tế như thế nào?
    
- Tại sao hiệu quả khác kế hoạch?
    
- Cost driver chính là gì?
    
- Chênh lệch đến từ material, manufacturing hay allocation?
    
- Cần drill-down vào factory hoặc production ở đâu?
    

Flow mục tiêu:

```text
Style Selected
        ↓
Aggregate Relevant OCs
        ↓
Finance Efficiency Calculation
        ↓
Expected vs Actual
        ↓
Major Variance
        ↓
Main Drivers
        ↓
Optional Drill-down
```

### Long-Term Vision

Về dài hạn, project có thể kết nối:

```text
Finance
+ Costing
+ Order
+ Sales
+ Production
+ Factory
+ Quality
+ Material
+ Operational Data
```

để hỗ trợ:

- Factory comparison.
    
- Product efficiency analysis.
    
- Order allocation support.
    
- Investment decision support.
    
- Natural-language analytics.
    
- Predictive intelligence.
    

Tuy nhiên, các capability này chưa thuộc MVP.

---

### Main Principles

#### Data First, AI Second

Các bước extraction, mapping, calculation, reconciliation phải dùng deterministic logic.

AI chỉ nên dùng để:

- Phân tích.
    
- Giải thích.
    
- Tổng hợp.
    
- Xếp hạng driver.
    
- Tìm pattern.
    
- Natural-language interaction.
    

#### Finance Owns Finance Logic

Finance chịu trách nhiệm approve:

- Formula.
    
- Mapping.
    
- KPI.
    
- Allocation.
    
- Financial interpretation.
    

AI Team không tự quyết định Finance logic.

#### One Input, Multiple Uses

Mục tiêu:

**Input once → Reuse many times**

#### Analyze Broad First, Drill Down Second

Flow phân tích:

```text
Overall Result
→ Major Cost Bucket
→ Abnormal Area
→ Drill Down
```

---

### Immediate Next Actions

|#|Action|Output|
|---|---|---|
|1|Thu thập current Finance report template|Report Inventory|
|2|Thu thập WFX source report|Source Inventory|
|3|Mapping current manual process|AS-IS Process|
|4|Document mapping logic|Mapping Specification|
|5|Chọn một pilot company/month|MVP Scope|
|6|Reconcile manual và source data|Baseline|
|7|Thiết kế Phase 1 architecture|Solution Design|
|8|Xác định non-system companies|Coverage Matrix|
|9|Quyết định central input approach|Portal/Storage Decision|
|10|Review Target Costing data|Costing Data Assessment|
|11|Tạo KPI Definition Register|Approved KPI Spec|
|12|Build delivery backlog|Prioritized Backlog|

### Main Risks

- Scope explosion.
    
- Finance/Sales definitions khác nhau.
    
- Historical costing methodology không đồng nhất.
    
- Một số công ty vẫn gửi Excel.
    
- Legal consolidation phức tạp hơn simple aggregation.
    
- Cross-system key mapping sai.
    
- AI hallucination.
    
- Finance data exposure.
    
- Phụ thuộc availability của Finance SMEs.
    

### Management Note

Đây là project strategic program có khả năng mở rộng lớn nhất hiện tại.

Tuy nhiên, không nên build AI trước.

Critical path hiện tại là:

```text
Current Report
        ↓
Source Report
        ↓
Mapping
        ↓
Calculation
        ↓
One Pilot
        ↓
100% Reconciliation
        ↓
Scale
        ↓
Costing Analysis
        ↓
Order Efficiency
        ↓
AI Insight
```

---

## 3.2 `COSTING.AGENTIC.PLATFORM.v1.1`

**Phase:** Analysis / Data Acquisition / Sew-first Implementation

Project tiếp tục chuyển sang hướng triển khai thực tế hơn.

Lâm đang follow-up nghiệp vụ và bắt đầu xin dữ liệu để xây costing cho phòng **Sew** trước.

### Current Focus

- Current Sew costing process.
    
- Historical sewing data.
    
- Similar product history.
    
- Construction complexity.
    
- Sewing operation.
    
- Time.
    
- Labor.
    
- SMV nếu có.
    
- Expert judgement.
    

### Next Actions

- Lấy sample data.
    
- Interview technical experts.
    
- Mapping process.
    
- Define input/output.
    
- Build first Sew costing module.
    
- Validate trước khi scale sang Wash, Cut và BOM.
    

---

## 3.3 `SCP.SOURCING.CHATBOT.v2.3`

**Phase:** UAT / Iterative Improvement

Project đã hoàn thành demo lần thứ ba.

### Current Activities

- Testing chatbot.
    
- Testing search.
    
- Testing data retrieval.
    
- Gathering feedback.
    
- Recording change requests.
    
- Refining output.
    

### Next Actions

Phân loại feedback thành:

- Bug.
    
- Data issue.
    
- Search issue.
    
- UI/UX.
    
- Enhancement.
    

Sau đó fix và retest trước vòng tiếp theo.

---

# 4. Other Project Movements

## `PPJxQSee.AI`

**Phase:** PoC / Sample Data Collection

- Đã kick-off.
    
- Bắt đầu gửi sample data.
    
- Đang chuẩn hóa defect/image data.
    
- Cần chốt success criteria cho PoC.
    

---

## `QC.Primo1D.RFID.Thread.v1.0`

**Phase:** Pre-contact / Internal Alignment

- Chưa initial contact.
    
- Đã report anh Cường.
    
- QC đang xác định nhân sự.
    
- Chưa vendor meeting hoặc PoC.
    

---

## `PUR.GDI.Automation.v1.0`

**Phase:** Scope Reassessment

- Technical feasibility đã được xác nhận.
    
- Có thể lấy đủ dữ liệu từ nhiều màn hình.
    
- Có thể bypass user confirmation.
    
- User chỉ cần cung cấp style, mã hàng và chi nhánh công ty.
    
- Cần đánh giá risk và final automation scope.
    

---

## `PPJ.ExpenseInvoices.v1.1`

**Phase:** UAT / Cross-department Expansion

- Đang mở rộng từ EXIM solution.
    
- Tiếp tục fix lỗi.
    
- Đã vào UAT.
    
- Đang validate data mapping và accounting rules.
    

---

## `PPJ.InvoiceDownloader.v1.2`

**Phase:** Production / Business Adoption

- Chị Bình đã nhận dữ liệu.
    
- Đã bắt đầu xây report.
    
- Đã bắt đầu xây dashboard.
    
- Business user tiếp tục phần việc phía sau.
    

---

## `FD.Datamart.v2.2`

**Phase:** Final Stabilization / Closeout

- Fully updated trong tuần.
    
- Chuẩn bị closeout từ tuần 06/07.
    
- Sau acceptance dự kiến chuyển sang Closed / Maintenance Only.
    

---

## `MER.MARKET.INTELLIGENCE.v1.1`

**Phase:** Analysis / Multi-source Data Follow-up

- Khóa scope là Market Intelligence.
    
- Không tồn tại e-commerce project riêng.
    
- Tiếp tục follow-up dữ liệu đa nguồn.
    
- Kết hợp internal data với Quince consumer signals.
    

---

## `PPJ.UIT.ACADEMIC.COLLABORATION.v1.1`

**Phase:** Partnership Follow-up / Confirmed Direction

- Madame đã confirm direction.
    
- UIT đã đồng ý định hướng chung.
    
- Bước tiếp theo là chốt workstream.
    
- Cần mapping bài toán PPJ vào khóa luận, đồ án, AISC, mentoring hoặc contest riêng.
    

---

# 5. Projects Closed

|Project|Final Status|
|---|---|
|`MER.PO.Commit.v1.1`|DONE / CLOSED|
|`EXIM.ExpenseInvoices.Automation.v1.1`|DONE / CLOSED|
|`AI.Automation.Workshop.202606`|DONE / CLOSED|
|`VITAS.Sharing.202606`|DONE / CLOSED|

---

# 6. Priority cho tuần bắt đầu 06/07/2026

|Priority|Project|Trọng tâm|
|---|---|---|
|1|`FIN.AI.FINANCE.MANAGEMENT.v1.1`|Thu current report, source report, mapping, pilot company/month và hoàn thiện Discovery|
|2|`COSTING.AGENTIC.PLATFORM.v1.1`|Thu thập Sew data và mapping costing process|
|3|`SCP.SOURCING.CHATBOT.v2.3`|Tổng hợp feedback demo 3, fix và retest|
|4|`PPJ.ExpenseInvoices.v1.1`|Tiếp tục UAT và fix defects|
|5|`PPJxQSee.AI`|Hoàn thiện sample dataset và PoC success criteria|
|6|`PUR.GDI.Automation.v1.0`|Re-scope và đánh giá bypass confirmation|
|7|`FD.Datamart.v2.2`|Project closeout|
|8|`PPJ.UIT.ACADEMIC.COLLABORATION.v1.1`|Chốt workstream và danh sách bài toán PPJ|
|9|`PPJ.InvoiceDownloader.v1.2`|Theo dõi business adoption và data quality|

---

# 7. Management Attention

## 7.1 Finance project cần khóa MVP rất chặt

`FIN.AI.FINANCE.MANAGEMENT.v1.1` có tầm nhìn lớn nhưng phải bắt đầu bằng một pilot nhỏ:

**One Company + One Period + One Report**

Không mở cùng lúc Reporting, Costing, Sales, Factory và AI.

---

## 7.2 Finance logic phải do Finance approve

AI & Automation Team không được tự định nghĩa:

- Cost.
    
- Efficiency.
    
- Allocation.
    
- Consolidation.
    
- Financial KPI.
    

---

## 7.3 Costing Agentic Platform cần dữ liệu chuyên môn thật

Sew-first approach chỉ có giá trị khi lấy được:

- historical data;
    
- actual process;
    
- technical rules;
    
- expert experience.
    

---

## 7.4 Agent/API projects cần governance

PERRI, Invoice Downloader và các future Finance/Costing agents cần:

- RBAC;
    
- logging;
    
- audit;
    
- source traceability;
    
- human review với output quan trọng.
    

---

# 8. Executive Recap ngắn

Trong tuần 29/06–05/07/2026, thay đổi lớn nhất của portfolio là việc chính thức kick-off **`FIN.AI.FINANCE.MANAGEMENT.v1.1`** vào ngày 04/07. Sau kick-off, scope dự án đã được làm rõ thành ba workstream: Financial Reporting Automation, Costing Analysis và Order/Sales Efficiency Analysis. Financial Reporting Automation được xác định là MVP đầu tiên, với mục tiêu giảm các bước export, Excel processing, copy/paste, mapping và tổng hợp báo cáo thủ công. Project sẽ bắt đầu từ một pilot nhỏ gồm một company, một period và một approved financial report, sau đó reconcile 100% với báo cáo thủ công trước khi scale.

`COSTING.AGENTIC.PLATFORM.v1.1` tiếp tục chuyển sang Sew-first implementation và bắt đầu xin dữ liệu kỹ thuật thực tế. `SCP.SOURCING.CHATBOT.v2.3` hoàn thành demo lần thứ ba và tiếp tục refinement. `PPJxQSee.AI` đã kick-off và bắt đầu sample data collection. `PPJ.ExpenseInvoices.v1.1` đã vào UAT. `PPJ.InvoiceDownloader.v1.2` bắt đầu được business sử dụng để xây report/dashboard.

`PUR.GDI.Automation.v1.0` đã xác nhận technical feasibility tốt hơn, `FD.Datamart.v2.2` chuẩn bị closeout, `MER.MARKET.INTELLIGENCE.v1.1` tiếp tục follow-up dữ liệu đa nguồn và `PPJ.UIT.ACADEMIC.COLLABORATION.v1.1` đã được management cùng UIT xác nhận định hướng hợp tác.

Song song đó, `MER.PO.Commit.v1.1`, `EXIM.ExpenseInvoices.Automation.v1.1`, `AI.Automation.Workshop.202606` và `VITAS.Sharing.202606` đã hoàn tất và chính thức được đóng.