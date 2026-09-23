# PPJ AI & AUTOMATION PORTFOLIO

## Master Project Detail Registry

**Snapshot chuẩn hóa:** 11/07/2026  
**Nguồn chính:** Portfolio summary mới nhất được tải lên và toàn bộ scope correction đã xác nhận trong cuộc trao đổi.

## 1. Kết quả rà soát danh mục

Tài liệu hiện có thể được hiểu theo cấu trúc:

|Nhóm|Số lượng|Cách quản trị|
|---|--:|---|
|Đang tiếp tục triển khai|19|Strategic, Analysis, Development, UAT, Production, Trial hoặc Closeout|
|Vận hành và bảo trì|5|Không còn active development chính|
|On Hold / Chờ quyết định|2|Không cấp delivery capacity cho đến khi đủ điều kiện|
|Đã đóng / Hủy|6|Không đưa vào active WBS|
|**Tổng số note/project lịch sử**|**32**|26 current-registry items + 6 closed items|

Điểm cần khóa lại:

- **26 current-registry items** = 19 continuing + 5 maintenance + 2 on hold.
    
- **6 historical closed items** được giữ để bảo toàn lịch sử.
    
- `MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1` từng tồn tại trong portfolio trước nhưng không xuất hiện trong registry mới nhất; vì vậy cần giữ ở nhóm **status confirmation required**, không tự coi là active.
    
- `PROJECT_COMMAND_CENTER` là portfolio index, không phải delivery project.
    
- Finance project hiện dùng **scope hai workstream mới nhất**, thay cho mô hình ba workstream cũ.
    
- Costing Platform là project riêng; không gộp vào Finance.
    

---

# PHẦN A — 19 PROJECT ĐANG TIẾP TỤC TRIỂN KHAI

---

## A1. **`FIN.AI.FINANCE.MANAGEMENT.v1.1`**

### Project identity

|Thuộc tính|Nội dung|
|---|---|
|Display name|AI-assisted Finance Management|
|Domain|Finance / Accounting|
|Phase|Discovery / BRD / Specification|
|Executive Sponsor|Madame Hồng Phương|
|Business Owner|Accounting|
|Finance SME|Chị Minh|
|Target completion|04/12/2026|
|Strategic priority|Rất cao|

### Strategic scope correction

Scope mới nhất gồm **hai workstream chính thức**:

|Workstream|Sản phẩm|Mục tiêu|
|---|---|---|
|WS1|Finance Analysis Chatbot|Phân tích, truy vấn và giải thích dữ liệu Finance|
|WS2|Financial Reporting Consolidation Platform|Thu thập, validate, chuẩn hóa và tổng hợp báo cáo từ các công ty|

Điều này thay thế cấu trúc cũ gồm Financial Reporting, Costing Analysis và Order Efficiency.

`COSTING.AGENTIC.PLATFORM.v1.1` tiếp tục là project riêng.

---

### WS1 — Finance Analysis Chatbot

#### Business problem

Finance đã có Power BI, WFX, DWH và nhiều nguồn dữ liệu, nhưng để trả lời một câu hỏi quản trị, người dùng vẫn có thể phải:

- Mở nhiều dashboard.
    
- Tự lọc nhiều bảng.
    
- Kiểm tra nhiều OC.
    
- Đối chiếu công thức.
    
- Hỏi Finance SME giải thích số liệu.
    
- Tìm nguyên nhân bằng thao tác thủ công.
    

Management không chỉ cần biết một KPI bằng bao nhiêu, mà còn cần biết:

- KPI được tính như thế nào.
    
- Dữ liệu đến từ đâu.
    
- Kỳ nào đang được phân tích.
    
- Company, customer, style hay OC nào tạo ra biến động.
    
- Driver nào quan trọng nhất.
    
- Có thể drill-down về nguồn hay không.
    

#### Target data flow

```text
ERP WFX
→ Data Warehouse
→ Finance Source Tables
→ Power BI Structure and Calculations
→ Finance Analytical Schema
→ Finance Analysis Chatbot
```

#### Vai trò của Power BI

Power BI được dùng làm:

- Schema reference.
    
- Relationship reference.
    
- Calculation reference.
    
- Validation baseline.
    
- Analytical UX reference.
    
- Nguồn giúp reverse-engineer business logic.
    

Power BI **không phải production database** và không được mặc định là source of truth cuối cùng.

Nguồn chính vẫn là:

- WFX.
    
- DWH.
    
- Finance source tables.
    
- Approved Finance calculations.
    

#### Candidate analytical capabilities

Chatbot dự kiến có thể hỗ trợ:

- Total Sales.
    
- COGS.
    
- Gross Margin.
    
- Gross Margin Percentage.
    
- Allocated Expense.
    
- Final Margin.
    
- Efficiency.
    
- Company comparison.
    
- Customer comparison.
    
- Sales Group analysis.
    
- Style analysis.
    
- OC drill-down.
    
- Period comparison.
    
- Variance explanation.
    
- Root-cause analysis.
    
- Evidence display.
    
- Source-table traceability.
    

#### Required output

Mỗi câu trả lời quan trọng phải có:

- Entity được phân tích.
    
- Analysis period.
    
- KPI result.
    
- Supporting values.
    
- Applied formula.
    
- Data source.
    
- Relevant drill-down.
    
- Phân biệt rõ fact, calculation và inference.
    
- Warning khi dữ liệu không đủ.
    

#### Immediate deliverables

- Table Catalogue.
    
- Relationship Matrix.
    
- Calculation Register.
    
- Finance Semantic Dictionary.
    
- Golden Question Dataset.
    
- Reconciliation Baseline.
    
- RBAC Model.
    
- MVP Analytical Schema.
    
- Power BI-to-DWH Mapping.
    
- Approved KPI Definition Register.
    

#### Human control

- Accounting sở hữu Finance logic.
    
- AI Team không tự định nghĩa KPI.
    
- Chatbot MVP là read-only.
    
- AI không được tự tạo official financial numbers.
    
- AI không được giải thích nguyên nhân nếu không có evidence.
    
- Các câu trả lời quan trọng cần trace được về nguồn.
    

---

### WS2 — Financial Reporting Consolidation Platform

#### Business problem

Các company/entity có thể sử dụng các hệ thống hoặc phương pháp báo cáo khác nhau:

- Một số có dữ liệu trên WFX.
    
- Một số vẫn sử dụng Excel.
    
- Template không hoàn toàn đồng nhất.
    
- Group Finance phải tổng hợp lại.
    
- Một dữ liệu có thể bị copy nhiều lần.
    
- File có thể bị gửi lại nhiều version.
    
- Khó biết công ty nào đã submit.
    
- Khó biết file nào là version mới nhất.
    
- Mapping và validation phụ thuộc người xử lý.
    

#### Target process

```text
Company Accounting User
→ Login
→ Select Company
→ Select Report Type
→ Select Period
→ Upload Report
→ Template Validation
→ Data Parsing
→ Standard Mapping
→ Exception Handling
→ Accounting Review
→ SharePoint
→ Power BI
→ Management Reporting
```

#### Candidate functions

- Secure login.
    
- Company-level access.
    
- Report-type selection.
    
- Period selection.
    
- File upload.
    
- Template validation.
    
- Required-field validation.
    
- Data-type validation.
    
- Data parsing.
    
- Standard mapping.
    
- Error display.
    
- Data preview.
    
- Correction and resubmission.
    
- Submission tracking.
    
- Version history.
    
- Audit trail.
    
- Accounting review.
    
- Approval/rejection.
    
- SharePoint integration.
    
- Power BI refresh trigger hoặc downstream flow.
    

#### Immediate deliverables

- Report Inventory.
    
- Target Report Template.
    
- Source Report Samples.
    
- Source-to-Target Mapping.
    
- Company Coverage Matrix.
    
- Pilot Company.
    
- Pilot Report Type.
    
- Pilot Period.
    
- SharePoint Folder Structure.
    
- Submission Workflow.
    
- Approval Workflow.
    
- Exception Process.
    
- Power BI Downstream Design.
    
- Legal-consolidation boundary definition.
    

#### Key distinction

```text
Combined Group Report
≠
Legal Consolidated Financial Statement
```

Legal consolidation có thể cần:

- Intercompany elimination.
    
- Revenue elimination.
    
- Balance elimination.
    
- Adjustment entries.
    
- Manual accounting approval.
    

Không được coi Group Consolidation chỉ là cộng số liệu của các công ty.

---

### Current status

Team đang:

- Làm việc với chị Minh và Accounting.
    
- Tiếp nhận Power BI.
    
- Phân tích source tables.
    
- Phân tích table relationships.
    
- Phân tích DAX.
    
- Phân tích calculated columns.
    
- Phân tích measures.
    
- Làm rõ official KPI.
    
- Thu report templates.
    
- Document manual reporting process.
    
- Xác định các bước Excel trung gian.
    
- Chuẩn bị Finance Analytical Schema.
    

### Main risks

- Reverse-engineer Power BI chưa đầy đủ.
    
- KPI chưa được Accounting approve.
    
- Source table grain chưa rõ.
    
- Join sai giữa SalesRegister, COGS, OCLIST hoặc các bảng liên quan.
    
- Company reports không đồng nhất.
    
- File upload sai template.
    
- Data leakage.
    
- Chatbot trả lời không có evidence.
    
- Scope WS1 và WS2 mở rộng cùng lúc.
    
- Stakeholder muốn AI trước khi data model được chuẩn hóa.
    

### WBS anchors

1. Project governance.
    
2. Finance discovery.
    
3. Power BI reverse-engineering.
    
4. Source-table analysis.
    
5. Calculation register.
    
6. Semantic model.
    
7. Golden questions.
    
8. Chatbot architecture.
    
9. RBAC.
    
10. Evidence and lineage.
    
11. Reconciliation.
    
12. Consolidation portal discovery.
    
13. Upload and validation engine.
    
14. Mapping engine.
    
15. Approval workflow.
    
16. SharePoint integration.
    
17. Power BI downstream integration.
    
18. UAT.
    
19. Deployment.
    
20. Training and handover.
    

---

## A2. **`COSTING.AGENTIC.PLATFORM.v1.1`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Domain|Merchandising / Technical Costing|
|Phase|Analysis / Data Acquisition / Sew-first MVP|
|BA|Khoa, Uyên|
|Technical|Lâm|
|Primary users|MER và các technical costing teams|

### Core business purpose

Xây dựng nền tảng hỗ trợ tạo costing để Merchandising review và sử dụng khi chuẩn bị quotation cho khách hàng.

Đây không phải:

- Finance profitability platform.
    
- Chatbot Q&A đơn lẻ.
    
- Hệ thống tự gửi quotation.
    
- Công cụ thay thế chuyên gia Technical hoặc MER.
    

### Business context

Trong một đợt customer review, khách hàng có thể chọn hơn 100 mẫu và yêu cầu báo giá.

MER có thể phải follow-up:

- Sew.
    
- BOM.
    
- Wash.
    
- Technical.
    
- Fabric Consumption.
    
- Historical Costing.
    
- Supplier/material information.
    

Pain points:

- Thời gian quotation dài.
    
- Nhiều lần trao đổi.
    
- Dữ liệu thiếu.
    
- Assumption không đồng nhất.
    
- Knowledge phụ thuộc chuyên gia.
    
- Khó xử lý batch lớn.
    
- Không dễ tìm lại style tương tự.
    
- Khó biết yếu tố nào đang làm costing không chắc chắn.
    

### Primary output

**Costing / Quotation Package for Merchandising Review**

Package dự kiến gồm:

- Cost breakdown.
    
- Technical assumptions.
    
- Missing information.
    
- Confidence.
    
- Risk.
    
- Similar historical products.
    
- Previous quotation references.
    
- Questions cần hỏi customer.
    
- Expert-review points.
    
- Version và source references.
    

### Target modules

|Module|Scope|
|---|---|
|Requirement Decomposition|Chuẩn hóa customer request và technical requirements|
|Sew Costing|Operation List, SMV, CM hoặc Total Sew Cost|
|BOM Costing|Main fabric, trims, packaging và related material cost|
|Wash Costing|Wash route, process, time, chemical/process assumptions và cost|
|Fabric Consumption Costing|Consumption, allowances, marker và fabric cost|
|Historical Costing|Similar style, previous costing và previous quotations|
|Consolidation|Tổng hợp thành costing package|

### Fabric Consumption Costing

Tên đúng là **Fabric Consumption Costing**, không phải cutting labor costing.

Candidate calculations:

- Consumption per piece.
    
- Consumption per dozen.
    
- Consumption by size.
    
- Size ratio.
    
- Fabric width.
    
- Marker length.
    
- Marker efficiency.
    
- Grain direction.
    
- Stripe/check matching.
    
- Shrinkage.
    
- End loss.
    
- Spreading loss.
    
- Cutting waste.
    
- Defect allowance.
    
- Recut allowance.
    
- Total fabric requirement.
    
- Fabric price.
    
- Estimated fabric cost.
    

### Current strategy — Sew-first MVP

```text
Collect Sew Data
→ Understand Existing Calculation
→ Capture Expert Knowledge
→ Define Inputs and Outputs
→ Build Sew Costing MVP
→ Validate with Sew Experts
→ Expand to BOM, Wash and Fabric Consumption
```

### Current status

- Đã làm việc với team Sew.
    
- Đang xin sample data.
    
- Đang xin historical data.
    
- Đang phân tích phương pháp tính hiện tại.
    
- Đang xác định input.
    
- Đang xác định output.
    
- Đang xác định expert adjustment.
    
- Target là có first MVP/demo sau khoảng ba tuần.
    

### Immediate deliverables

- Sew Process Map.
    
- Sew Data Inventory.
    
- Sew Input Schema.
    
- Sew Output Schema.
    
- Current Calculation Specification.
    
- Similar-style Matching Logic.
    
- Expert Adjustment Register.
    
- Validation Dataset.
    
- Acceptable Error Threshold.
    
- First Sew Costing Prototype.
    
- Human Review Workflow.
    
- Expansion Roadmap.
    

### Open decisions

- Output chính là Operation List, SMV, CM hay Total Sew Cost?
    
- Source of historical sewing data?
    
- Similar style được xác định bằng field nào?
    
- Expert adjustment có được lưu thành dữ liệu không?
    
- Sai số bao nhiêu là chấp nhận được?
    
- Ai approve MVP result?
    
- Khi dữ liệu thiếu, system fallback như thế nào?
    

### Risks

- Tacit knowledge chưa được document.
    
- Historical data không sạch.
    
- Similar styles không comparable.
    
- Demo nhanh nhưng thiếu validation.
    
- Mở rộng sang nhiều modules quá sớm.
    
- Người dùng nghĩ AI thay chuyên gia.
    
- Output costing bị dùng trực tiếp mà không có MER review.
    

---

## A3. **`TD.TechnicalKnowledge.Platform.v2.1`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Domain|Technical Department|
|Phase|Analysis / Data Source Mapping|
|Stakeholder|Anh Tứ|
|BA|Khoa|
|Technical|Huy|

### Goal

Xây dựng technical data và knowledge foundation để:

- Tập trung dữ liệu kỹ thuật.
    
- Tăng khả năng tìm kiếm.
    
- Liên kết dữ liệu theo Buyer, Style, Pattern và BOM.
    
- Hỗ trợ các anh chị Technical.
    
- Cải thiện phối hợp Technical–Merchandising.
    
- Hỗ trợ training.
    
- Cung cấp knowledge foundation cho Costing Platform.
    

### Candidate data domains

- Buyer.
    
- Customer.
    
- Buyer reference.
    
- Style.
    
- Item.
    
- Pattern.
    
- Pattern version.
    
- BOM.
    
- Fabric.
    
- Trims.
    
- Construction.
    
- Fitting.
    
- Measurement.
    
- Sewing instruction.
    
- Process video.
    
- Technical document.
    
- Historical costing.
    
- Sample image.
    
- Approval status.
    
- Owner.
    
- Effective date.
    
- Version.
    

### Primary output

Searchable Technical Knowledge Platform hỗ trợ:

- Search theo Buyer Reference.
    
- Search theo Style.
    
- Search theo Pattern.
    
- Search theo BOM.
    
- Linked technical records.
    
- Document/video access.
    
- Version tracking.
    
- Approval status.
    
- Document ownership.
    
- Role/department permissions.
    

### Current status

Team đã làm việc với anh Tứ để:

- Xác định fields.
    
- Xác định source systems.
    
- Làm rõ dữ liệu cần sync.
    
- Làm rõ nhu cầu search.
    
- Làm rõ nhu cầu phối hợp Technical–MER.
    

### Immediate deliverables

- Field Inventory.
    
- Source System Inventory.
    
- Canonical Data Model.
    
- Metadata Standard.
    
- Master-key Definition.
    
- Sync Design.
    
- Version-control Rules.
    
- Permission Model.
    
- Search MVP.
    
- Pilot Dataset.
    
- Data Ownership Matrix.
    

### Main risks

- Duplicate technical records.
    
- User truy cập nhầm version.
    
- Metadata không thống nhất.
    
- Buyer data bị expose.
    
- Platform trở thành file archive.
    
- Không có data owner duy trì.
    
- Sync một chiều hoặc hai chiều không rõ.
    
- Operational content và training content bị trộn.
    

### Boundary

```text
Technical Knowledge Platform
= Knowledge, Data, Search and Version Control

Costing Agentic Platform
= Costing Workflow, Estimation and Quotation Support
```

---

## A4. **`HR.SSPFD.Workflow.v1.1`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Scope name|HR / Payroll / BHXH Data Audit|
|Phase|Analysis / Data Collection|
|Initial factory|GREA|
|Initial period|2025|
|MVP|BHXH data audit|

### Goal

Audit dữ liệu BHXH nhằm xác định:

- Missing records.
    
- Duplicate records.
    
- Employee mapping issues.
    
- Period mismatch.
    
- Contribution mismatch.
    
- Abnormal records.
    
- Data-quality issues.
    

### Current MVP boundary

Chỉ tập trung:

- Nhà máy GREA.
    
- Dữ liệu năm 2025.
    
- BHXH data audit.
    

Chưa bao gồm:

- Full payroll automation.
    
- Full HR master.
    
- Employee self-service.
    
- BHXH submission automation.
    
- Salary payment.
    
- HR chatbot.
    

### Candidate inputs

Cần HR xác nhận chính thức:

- Employee ID.
    
- Employee name.
    
- Company/factory.
    
- Department.
    
- Employment status.
    
- Join date.
    
- Leave date.
    
- Salary basis.
    
- BHXH contribution basis.
    
- Contribution period.
    
- Employee contribution.
    
- Employer contribution.
    
- Adjustment record.
    
- BHXH status.
    

### Primary outputs

- BHXH Audit Dataset.
    
- Error and Mismatch List.
    
- Missing-data List.
    
- Duplicate List.
    
- Summary by Factory and Period.
    
- HR Review Report.
    
- Source Traceability.
    
- Audit Rule Register.
    

### Current status

- Đã bắt đầu phân tích HR/payroll data.
    
- Xác định BHXH là MVP đầu tiên.
    
- Đang thu dữ liệu 2025.
    
- Đang xác định các bảng BHXH.
    
- Chuẩn bị audit rules.
    

### Risks

- Dữ liệu lương và nhân sự rất nhạy cảm.
    
- Employee key không ổn định.
    
- Nhiều version.
    
- Audit rule chưa được document.
    
- AI tự suy luận mức đóng.
    
- Không có HR validation owner.
    
- Data access vượt quá least privilege.
    

---

## A5. **`PPJ.UIT.ACADEMIC.COLLABORATION.v1.1`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Partner|Khoa Hệ thống Thông tin – UIT|
|Phase|Confirmed Direction / Problem Framing|
|Sponsor|Madame Hồng Phương|
|Contacts|Khoa, cô Nhạn, cô Phụng|

### Goals

- Đưa bài toán PPJ vào thesis/student project.
    
- Xây prototype.
    
- Tạo innovation pipeline.
    
- Tạo talent pipeline.
    
- Kết nối doanh nghiệp và trường đại học.
    
- Hợp tác qua AISC, mentoring hoặc competition.
    

### Current priority topic

**Fabric Waste Optimization / 2D Pattern Nesting**

### Problem direction

Tối ưu sắp xếp pattern pieces trên fabric để:

- Giảm waste.
    
- Tăng utilization.
    
- Đáp ứng constraints.
    
- So sánh algorithms.
    
- Đánh giá runtime.
    

### Candidate inputs

- Pattern polygons.
    
- Simplified DXF.
    
- Fabric width.
    
- Piece quantity.
    
- Rotation constraints.
    
- Grain direction.
    
- Size ratio.
    
- Spacing allowance.
    
- Matching constraints.
    

### Candidate outputs

- Proposed layout.
    
- Fabric utilization percentage.
    
- Waste percentage.
    
- Runtime.
    
- Constraint violations.
    
- Algorithm explanation.
    
- Evaluation report.
    
- Prototype/demo.
    

### Important guardrail

Academic prototype không thay thế Gerber/CAD production software.

### Current status

- Direction đã được duyệt.
    
- Fabric Waste topic đang được làm rõ.
    
- Đang cân nhắc thesis, student project, AISC hoặc competition.
    
- Data-sharing và IP chưa chốt.
    

### Required decisions

- Academic format.
    
- PPJ mentor.
    
- UIT mentor.
    
- Dataset.
    
- Synthetic data option.
    
- NDA.
    
- IP ownership.
    
- Evaluation criteria.
    
- Academic timeline.
    
- Handover requirement.
    

### Risks

- Scope quá lớn.
    
- Student prototype bị kỳ vọng như production.
    
- Production data nhạy cảm.
    
- Timeline không khớp.
    
- Không có PPJ owner review.
    
- IP chưa rõ.
    

---

## A6. **`MER.MARKET.INTELLIGENCE.v1.1`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Phase|Data Crawling / Product Intelligence Analysis|
|Business stakeholder|Chị Helen|
|Data/technical|Phát, Nghĩa|

### Scope lock

Đây là **Market Intelligence**, không phải một e-commerce platform riêng.

Các alias như:

- E-commerce Opportunities Exploration.
    
- Quince Analysis.
    
- E-commerce Market Intelligence.
    

đều map về project này.

### Goal

Kết hợp external market signals và internal PPJ data để xác định:

- Mặt hàng bán tốt.
    
- Product có commercial potential.
    
- Fit/color/silhouette/material có tín hiệu.
    
- Internal fabric capability phù hợp.
    
- Candidate products để pitch customer.
    
- Fabric reboost opportunities.
    

### Internal data

- Sales history.
    
- PO history.
    
- Customer.
    
- Style.
    
- Product description.
    
- Season.
    
- Quantity.
    
- Fabric inventory.
    
- Sample library.
    
- Historical product results.
    

### External data

- Product.
    
- Category.
    
- Price.
    
- Rating.
    
- Review.
    
- Color.
    
- Fit.
    
- Silhouette.
    
- Material.
    
- Composition.
    
- Availability.
    
- Seasonal signals.
    

### Analytical flow

```text
External Data
+ Internal Sales / PO / Product Data
+ Fabric Capability
→ Standardized Product Dataset
→ Commercial Scoring
→ Product/Fabric Opportunity
→ Pitching Insight
```

### Current status

- Tiếp tục crawling.
    
- Cleaning và normalization.
    
- Xác định products có commercial value.
    
- Chuẩn bị insight cho chị Helen.
    

### Required outputs

- Standardized Product Dataset.
    
- Product Taxonomy.
    
- Commercial Scoring Model.
    
- Internal–External Mapping.
    
- Top Product Opportunity List.
    
- Fabric Opportunity Summary.
    
- Pitching Insight Package.
    
- Data Refresh Process.
    

### Main risks

- Crawl nhiều nhưng không có business output.
    
- Rating/review không đồng nghĩa với sales.
    
- External source không đầy đủ.
    
- Product matching sai.
    
- Insight không phù hợp năng lực PPJ.
    
- Phụ thuộc một market source.
    

---

## A7. **`PUR.Material.Allocation.v1.1`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Phase|Early Development / UI and First Flow Testing|
|Stakeholder|Chị Tuyết / Precision Team|
|BA|Khoa, Uyên|

### Goal

Giảm thao tác thủ công và tăng validation cho:

- Material allocation.
    
- Material transfer.
    
- Borrowing.
    
- OC split.
    
- Related WFX material transactions.
    

### Primary output

Validated Material Allocation Flow gồm:

- Request intake.
    
- Source-data retrieval.
    
- Proposed allocation.
    
- Validation.
    
- User review.
    
- Approval.
    
- Save/post.
    
- Audit trail.
    

### Current status

- First flow cho request tách OC/internal user đã có bản cơ bản.
    
- UI đang được hoàn thiện.
    
- Chuẩn bị user trial.
    
- Cần xác nhận có cover các NPL flows khác hay không.
    

### Key business questions

- First flow cover chính xác case nào?
    
- Luồng NPL nào có thể dùng chung?
    
- Luồng nào phải tách?
    
- Có Save Draft không?
    
- Có edit trước post không?
    
- Ai approve?
    
- Khi nào user review bắt buộc?
    
- Rollback như thế nào?
    

### Risks

- Post sai ảnh hưởng inventory/order.
    
- First flow không đại diện case khác.
    
- WFX behavior khác kỳ vọng.
    
- Mở rộng quá sớm.
    
- Thiếu test data.
    
- Hidden business rules.
    

---

## A8. **`SCP.SOURCING.CHATBOT.v2.3`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Phase|UAT / User Adoption / Iterative Improvement|
|Team|Huy, Khoa, Linh, Nghĩa|

### Consolidated scope

Project bao gồm:

- Sourcing chatbot.
    
- Supplier/material data.
    
- Fabric data.
    
- Trims data.
    
- External sample repository.
    
- Structured search.
    
- Document retrieval.
    
- RAG.
    

Không tự tách thành nhiều project.

### Search dimensions

- Supplier.
    
- Fabric.
    
- Trims.
    
- Material.
    
- Composition.
    
- Color.
    
- Weight.
    
- Width.
    
- MOQ.
    
- Lead time.
    
- Price.
    
- Sample.
    
- Customer.
    
- Season.
    
- Division.
    

### Current status

- Demo rounds đã hoàn thành.
    
- Link đã được chia sẻ.
    
- Users bắt đầu đăng nhập.
    
- Users đăng ký.
    
- Users xin quyền.
    
- Chuyển từ internal demo sang UAT thực tế.
    

### Immediate deliverables

- User Registration List.
    
- Permission Matrix.
    
- UAT Scenarios.
    
- Search Quality Evaluation.
    
- Feedback Backlog.
    
- Defect Fixes.
    
- Retest Results.
    
- UAT Acceptance.
    
- Production Readiness Checklist.
    

### Feedback taxonomy

- Bug.
    
- Data issue.
    
- Search issue.
    
- Permission issue.
    
- UI/UX.
    
- Enhancement.
    
- Training issue.
    

### Risks

- Login/access issue.
    
- Permission sai.
    
- Search sai do data quality.
    
- External sample volume lớn.
    
- Feedback tạo scope creep.
    
- Import trước governance.
    
- User mất trust trong UAT.
    

---

## A9. **`PPJ.ExpenseInvoices.v1.1`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Display name|Expense Invoice Self-service Application|
|Phase|UAT / Cross-department Expansion|
|Stakeholders|Accounting, chị Minh, department users|

### Goal

Chuẩn hóa expense invoice processing và cho phép users tự:

- Upload.
    
- Update.
    
- Kiểm tra lỗi.
    
- Gửi dữ liệu.
    
- Theo dõi trạng thái.
    

Accounting tiếp tục đóng vai trò review và kiểm soát.

### Functional scope

- File upload.
    
- Manual update.
    
- Input validation.
    
- Mapping.
    
- Error feedback.
    
- Accounting review.
    
- Processing status.
    
- Upload history.
    
- Audit history.
    
- Permission.
    

### Current status

- Mapping đã cập nhật theo nhu cầu chị Minh.
    
- UI đã được bổ sung.
    
- Users có thể tự update.
    
- Users có thể tự upload.
    
- Accounting đang sử dụng thử.
    
- Chuẩn bị chốt go-live/handover.
    

### Required controls

- File-format validation.
    
- Mandatory-field validation.
    
- Duplicate detection.
    
- Ledger validation.
    
- Company mapping.
    
- Department mapping.
    
- Amount/tax validation nếu áp dụng.
    
- Error feedback.
    
- Role-based access.
    
- User/action audit.
    
- Correction and rollback.
    

### Risks

- Upload sai format.
    
- Mapping sai ledger.
    
- Duplicate.
    
- Rollout trước khi UAT xong.
    
- Thiếu audit trail.
    
- Không rõ cách sửa rejected record.
    
- User được phép edit quá mức.
    

### Relationship

```text
EXIM.ExpenseInvoices.Automation.v1.1
= specialist project đã đóng

PPJ.ExpenseInvoices.v1.1
= broader cross-department project đang UAT
```

---

## A10. **`PPJxQSee.AI`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Display name|QC AI Vision PoC|
|Phase|PoC / QC Sample Data Preparation|
|Initial pilot|JC|
|Stakeholders|QC, Factory, anh Cường, QSee|

### Goal

Đánh giá AI vision và QC equipment/data cho:

- Defect detection.
    
- Defect classification.
    
- Visual inspection.
    
- QC evidence.
    
- Realtime quality data.
    
- Customer transparency.
    
- Potential reduction in third-party inspection.
    

### Primary outputs

- JC QC Dataset.
    
- Defect Taxonomy.
    
- PoC Result.
    
- Technical Validation.
    
- Business Case.
    
- Go/No-go Recommendation.
    

### Candidate data

- Normal images.
    
- Defect images.
    
- Defect labels.
    
- Product/style metadata.
    
- Measurement standards.
    
- Quality standards.
    
- Lighting/camera context.
    
- Ground truth.
    

### Current status

- Đã làm việc với QC/factory team.
    
- MVP pivot về JC.
    
- Đang chuẩn bị data.
    
- Chờ detailed proposal.
    
- Có discussion về customer cost-sharing và realtime QC visibility.
    

### Critical PoC metrics

- Detection accuracy.
    
- False-positive rate.
    
- False-negative rate.
    
- Defect-level recall.
    
- Image capture stability.
    
- Processing speed.
    
- QC validation rate.
    
- Operational feasibility.
    

### Risks

- Dataset nhỏ.
    
- Labels không nhất quán.
    
- Factory conditions khác trial.
    
- Proposal vượt MVP.
    
- Investment trước proof.
    
- Customer-facing data chưa có governance.
    
- Confidentiality chưa rõ.
    

---

## A11. **`QC.Primo1D.RFID.Thread.v1.0`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Phase|Business Case Clarification / Pre-contact|
|Stakeholders|QC, MER, Factory, Khoa, anh Cường|
|Vendor status|Chưa official initial contact|

### Goal

Đánh giá RFID thread cho:

- Product identification.
    
- Traceability.
    
- Production-stage tracking.
    
- QC history linkage.
    
- Digital product identity.
    
- Customer transparency.
    

### Current status

- Chưa vendor meeting.
    
- Chưa sample.
    
- Chưa technical trial.
    
- Chưa confirmed customer case.
    
- Chưa confirmed cost owner.
    
- Business feasibility phụ thuộc MER/customer.
    

### Critical commercial questions

- MER có muốn propose không?
    
- Customer nào quan tâm?
    
- Customer có chấp nhận cost?
    
- Cost có đưa vào quotation không?
    
- Ai chi trả?
    
- Factory thay đổi gì?
    
- RFID được gắn lúc nào?
    
- Đọc ở đâu?
    
- System nào lưu data?
    

### Primary output hiện tại

Không phải PoC.

Output hiện tại phải là:

- Business Case.
    
- Customer Value Proposition.
    
- Incremental Cost Estimate.
    
- Factory Feasibility.
    
- Internal Owner.
    
- Vendor Contact Decision.
    

---

## A12. **`PUR.GDI.Automation.v1.0`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Phase|Scope Reassessment / Technical Feasibility Confirmed|
|Technical|Hiền|
|Domain|Purchasing / WFX|

### Goal

Giảm effort tạo Goods Delivery Instruction bằng việc tự động lấy dữ liệu từ nhiều nguồn/màn hình WFX.

### Proposed input

User chỉ cần:

1. Style.
    
2. Item Code.
    
3. Company Branch.
    

Company Branch không phải warehouse.

### Target flow

```text
Style + Item Code + Company Branch
→ WFX Data Retrieval
→ Consolidation
→ Validation
→ GDI Preparation
→ Review / Draft / Final Creation
```

### Current status

- Có thể lấy đủ data.
    
- Data nằm ở khoảng 5–6 screens/sources.
    
- Technical complexity có thể xử lý.
    
- Cần quyết định automation boundary.
    

### Possible automation levels

1. Prepare-only.
    
2. Prepare + User Review.
    
3. Create Draft.
    
4. Create Final after Confirmation.
    
5. Full Automatic Creation.
    

Hướng an toàn ban đầu:

**Prepare + User Review** hoặc **Create Draft**.

### Risks

- Wrong branch.
    
- Wrong style/item.
    
- Duplicate GDI.
    
- Screens không đồng bộ.
    
- WFX UI thay đổi.
    
- Bypass confirmation tăng transaction risk.
    
- Technical feasibility bị hiểu nhầm thành business approval.
    

---

## A13. **`PPJ.InvoiceDownloader.v1.2`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Phase|Production / Business Adoption|
|Team|Khoa, Nam|

### Goal

Tự động tải e-invoice, tổ chức file và tạo structured data cho reporting.

### Evolution

```text
Standalone Downloader
→ Download & Merge Tool
→ API-enabled Automation
→ PERRI/GPT Callable Tool
→ Business Data Source
```

### Primary outputs

- Invoice XML.
    
- Invoice PDF.
    
- Supplier.
    
- Invoice number.
    
- Invoice date.
    
- Tax code.
    
- Amount.
    
- File path.
    
- Download status.
    
- Error status.
    
- Duplicate status.
    
- API response.
    

### Current status

- Production.
    
- Chị Bình đã nhận data.
    
- Đang dùng data để làm report/dashboard.
    
- Value đã mở rộng ra downstream reporting.
    

### Operational focus

- Monitoring.
    
- Retry.
    
- Session handling.
    
- Missing detection.
    
- Duplicate detection.
    
- Metadata validation.
    
- Credential protection.
    
- API audit.
    
- Dashboard ownership.
    
- Support process.
    

### Risks

- Portal thay đổi.
    
- Session expiry.
    
- Credential issue.
    
- Missing/duplicate invoice.
    
- Wrong metadata.
    
- Agent access quá rộng.
    
- Downstream dashboard owner không rõ.
    

---

## A14. **`PPJ.PERRI.Chatbot.v3.2`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Display name|Internal AI Orchestrator|
|Phase|Production / Permission Enhancement|
|Technical owner|Nam|

### Goal

Cung cấp conversational and orchestration layer cho:

- Internal Q&A.
    
- Knowledge retrieval.
    
- Department agents.
    
- API calls.
    
- Tool execution.
    
- Workflow triggers.
    
- Automation access.
    

### Target architecture

```text
User
→ Authentication
→ Department Permission
→ Agent Selection
→ Knowledge / Data / API / Tool
→ Answer or Controlled Action
```

### Current status

- Production.
    
- Department-level permissions đã được cải thiện.
    
- User có thể được grant agent theo department.
    
- Đang chuyển từ general chatbot sang governed orchestrator.
    

### Required governance

- Agent Registry.
    
- Tool Registry.
    
- Department Mapping.
    
- Permission Matrix.
    
- Data Scope.
    
- Read/write separation.
    
- Audit logging.
    
- Owner by agent.
    
- Safe-failure rules.
    
- Production support.
    

### Critical distinction

**Read-only agent**

- Search.
    
- Retrieve.
    
- Explain.
    
- Summarize.
    

**Action agent**

- Download.
    
- Trigger.
    
- Update.
    
- Create transaction.
    

Action agents cần control mạnh hơn.

### Risks

- Cross-department leakage.
    
- Tool action không approval.
    
- Over-privileged users.
    
- Missing audit.
    
- Prompt injection.
    
- Không rõ owner.
    
- Agent thực hiện action ngoài scope.
    

---

## A15. **`WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Phase|New Booking / Analysis|
|Business owner|R&D Wash|
|Technical|Nam|

### Goal

Port và chuẩn hóa Wash Sampling Management lên PPJ Group Portal.

Đây là:

- Workflow-standardization project.
    
- Data-standardization project.
    
- Permission project.
    
- Cross-department collaboration project.
    

Không chỉ là UI migration.

### Target lifecycle

```text
Sample Request
→ Sample Creation
→ Assignment
→ Wash Trial
→ Result / Image / Comment
→ Review / Approval
→ Search / History
```

### Candidate functions

- Create request.
    
- Edit request.
    
- Assign owner.
    
- Update status.
    
- Upload image/file.
    
- Enter result.
    
- Add comment.
    
- Search/filter.
    
- View history.
    
- Approve/reject.
    
- Role-based access.
    

### Candidate data

- Sample code.
    
- Style/item.
    
- Customer.
    
- Buyer.
    
- Wash type.
    
- Request date.
    
- Due date.
    
- Responsible person.
    
- Status.
    
- Result.
    
- Comment.
    
- Images.
    
- Attachments.
    
- Approval.
    
- Version.
    
- Audit fields.
    

### Current status

- New booking.
    
- Cần survey current application.
    
- Cần inventory screens/functions.
    
- Cần data model.
    
- Cần role model.
    
- Chưa có confirmed development completion.
    

### Risks

- Port nguyên vấn đề cũ.
    
- Status không rõ.
    
- Không có data owner.
    
- Permission phức tạp.
    
- Nhầm với Cowash operational dashboard.
    
- Migration mất lịch sử.
    

---

## A16. **`PROD.IOT.CHuyenTreo.v1.0`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Display name|Hanger-line Production Dashboard|
|Phase|Development|
|Technical|Linh|

### Goal

Đưa dữ liệu chuyền treo vào realtime hoặc near-realtime dashboards để theo dõi production performance.

### Candidate KPIs

- Output.
    
- Target versus Actual.
    
- Efficiency.
    
- Downtime.
    
- Line Status.
    
- WIP.
    
- Production Trend.
    
- Operation Status.
    
- Hourly Output.
    

### Primary outputs

- Line-level Dashboard.
    
- Factory-level Report.
    
- Management View.
    
- Downtime View.
    
- Data Pipeline.
    
- Refresh Monitoring.
    

### Current status

- Development.
    
- Source architecture vẫn cần xác nhận giữa hanger-line systems, IDS, WISER, INA hoặc các nguồn liên quan.
    

### Risks

- Data latency.
    
- Missing events.
    
- KPI không thống nhất.
    
- Factory configuration khác nhau.
    
- Dashboard không khớp reality.
    
- Source system không ổn định.
    

---

## A17. **`PPJxNUNOX.ScanTrial`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Display name|Fabric Scanner Trial|
|Phase|Hardware Trial / Feasibility Assessment|
|Stakeholder|Sourcing|

### Goal

Đánh giá scanner chất lượng cao cho fabric sample digitization.

### Evaluation criteria

- Color accuracy.
    
- Texture visibility.
    
- Resolution.
    
- Scan speed.
    
- Repeatability.
    
- File size.
    
- Ease of use.
    
- Integration.
    
- Operating cost.
    
- Downstream usefulness.
    

### Potential value

- Ảnh fabric nhất quán.
    
- Fabric archive tốt hơn.
    
- Sourcing comparison.
    
- FD data.
    
- CPD visual library.
    
- Image search.
    
- Customer sample reference.
    

### Current status

Hardware trial.

Chưa đủ cơ sở để triển khai chỉ vì hình ảnh đẹp hơn.

### Required output

- Trial Assessment.
    
- Sample Scan Dataset.
    
- Quality Comparison.
    
- Operational Assessment.
    
- Integration Assessment.
    
- Business Recommendation.
    
- Go/No-go.
    

---

## A18. **`FD.Datamart.v2.2`**

### Identity

|Thuộc tính|Nội dung|
|---|---|
|Display name|Fabric / Hanger / QR Datamart|
|Phase|Final Stabilization / Closeout|
|Team|Nghĩa, Nam, Khoa|

### Goal

Quản lý dữ liệu fabric sample, hanger và QR để hỗ trợ FD.

### Primary outputs

- Fabric Sample Datamart.
    
- Hanger Data.
    
- QR Information.
    
- QR attached to Hanger.
    
- QR Format Designer.
    
- Hanger Templates.
    
- User Training.
    

### Current status

- Main update hoàn thành.
    
- Training hoàn thành.
    
- Feedback đã thu.
    
- Current scope đã update.
    
- Chờ formal acceptance và closeout.
    

### Closure requirements

Chưa chuyển Completed cho đến khi:

- Delivered scope được xác nhận.
    
- Formal acceptance được ghi nhận.
    
- Defects và enhancements được tách.
    
- Support owner được bàn giao.
    
- Maintenance backlog được tạo.
    

### Boundary

```text
FD = Fabric + Hanger + QR
CPD = 3D + Visual + Image Search
```

---

## A19. **`PPJ.AI.Hub.v2.1`**

### Classification

Internal Platform / Application Hub.

### Goal

Tạo điểm truy cập tập trung đến:

- AI tools.
    
- Chatbots.
    
- Department agents.
    
- Internal applications.
    
- Automation utilities.
    
- User guidance.
    

### Primary output

Application Catalog gồm:

- Application name.
    
- Description.
    
- Department.
    
- Access link.
    
- Permission-aware visibility.
    
- Status.
    
- User instructions.
    
- Support contact.
    

### Boundary

AI Hub không phải:

- Master Project Registry.
    
- Project documentation repository.
    
- PERRI replacement.
    
- Project hợp nhất tất cả AI systems.
    

### Relationship

```text
AI Hub
= Application discovery and access

PERRI
= Conversational orchestration and tool interaction
```

---

# PHẦN B — 5 PROJECT MAINTENANCE & SUPPORT

---

## B1. **`CPD.Datamart.v1.1`**

**Status:** Maintenance and Support  
**Technical:** Linh, Phát

### Purpose

Quản lý:

- CPD/3D Design data.
    
- 3D sample library.
    
- Image search.
    
- Visual assets.
    
- Reusable design references.
    

### Current work

- Support.
    
- Issue handling.
    
- Data assistance.
    
- Search-quality maintenance.
    
- Minor enhancement intake.
    

### Risks

- Metadata yếu.
    
- Visual search kém chính xác.
    
- Asset version không rõ.
    
- Nhầm scope với FD.
    
- Storage tăng nhanh.
    

---

## B2. **`PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0`**

**Status:** Maintenance and Support  
**Technical:** Huy

### Purpose

Hỗ trợ IT/ERP users về:

- Knowledge retrieval.
    
- Troubleshooting.
    
- FAQs.
    
- Helpdesk guidance.
    
- Potential ticket classification.
    

### Current work

- Knowledge maintenance.
    
- Answer-quality monitoring.
    
- Issue correction.
    
- User support.
    
- Escalation improvement.
    

### Risks

- Outdated knowledge.
    
- Incorrect troubleshooting.
    
- Không escalate đúng lúc.
    
- Knowledge chưa gắn đầy đủ ticket lifecycle.
    
- User xem chatbot answer như technical approval.
    

---

## B3. **`PUR.Inventory.Report.v1.0`**

**Status:** Maintenance and Support  
**Technical:** Nam

### Purpose

Cung cấp inventory visibility theo:

- Material.
    
- Material code.
    
- Quantity.
    
- Location.
    
- Company.
    
- Status.
    
- Availability.
    
- Refresh period.
    

### Current work

- Monitoring.
    
- Refresh validation.
    
- User support.
    
- Data discrepancy investigation.
    
- Minor report improvements.
    

### Risks

- Report không khớp source.
    
- Refresh fail.
    
- User dùng stale data.
    
- Source structure thay đổi.
    
- Không rõ inventory source of truth.
    

---

## B4. **`ACC.GRN-SupplierInvoiceBot.v2.3`**

**Status:** Maintenance and Support  
**Team:** Hiền, Khoa

### Version note

`v1.1` là alias/version cũ. Current discussion sử dụng `v2.3`.

### Purpose

Automate:

- GRN.
    
- Supplier invoice.
    
- WFX/ERP entry.
    
- Invoice-to-GRN mapping.
    
- Transaction support.
    

### Scenarios

- One PO → One GRN → One Invoice.
    
- Multiple POs.
    
- Multiple GRNs.
    
- Multiple Invoices.
    
- Partial Receipt.
    
- Mismatch.
    
- Exception.
    

### Current work

- Production stability.
    
- Exception handling.
    
- Bug fixing.
    
- User support.
    
- Input-format monitoring.
    
- Audit.
    

### Risks

- GRN/invoice mismatch.
    
- Wrong amount.
    
- Duplicate transaction.
    
- Missing reference.
    
- WFX changes.
    
- Exception chưa cover.
    
- Audit trail thiếu.
    

---

## B5. **`PUR.Adhoc.Indent.South.v1.0`**

**Status:** Maintenance and Support  
**Technical:** Hiền

### Purpose

Automate Adhoc Indent workflow cho khu vực miền Nam.

### Current work

- Stable operation.
    
- User support.
    
- Small bug fixes.
    
- Exception handling.
    
- Process-change monitoring.
    

### Risks

- Input/template thay đổi.
    
- WFX process thay đổi.
    
- Regional exceptions.
    
- User bypass flow.
    
- Không có monitoring rõ.
    

---

# PHẦN C — 2 PROJECT ON HOLD / CHỜ QUYẾT ĐỊNH

---

## C1. **`PROD.COWASH.v2.0`**

**Status:** On Hold / Re-scope  
**Technical:** Linh

### Goal

Lấy operational data từ Cowash để xây:

- Realtime dashboard.
    
- Wash report.
    
- Operational visibility.
    
- Production/Wash KPI monitoring.
    

### Candidate data

- Style.
    
- Order.
    
- Wash type.
    
- Process status.
    
- Start/end time.
    
- Output.
    
- Machine.
    
- Delay.
    
- Rework.
    
- Issue.
    

### Current blockers

- Chưa rõ API/export.
    
- Chưa rõ data access.
    
- Chưa rõ business owner.
    
- Chưa thống nhất KPI.
    
- Chưa rõ technical feasibility.
    
- Chưa rõ dashboard requirement.
    

### Reactivation criteria

- Confirmed business owner.
    
- Confirmed source.
    
- Feasible access.
    
- KPI Register.
    
- Defined output.
    
- Available resources.
    
- No overlap with Wash Sampling Portal.
    

### Boundary

```text
Cowash
= Operational Wash Data

Wash Sampling Portal
= Sampling Workflow
```

---

## C2. **`PUR.HM.LabelO.Processing.Automation.v1.0`**

**Status:** On Hold / Delayed  
**Team:** Khoa, Nam

### Goal

Automate H&M-specific Label-O processing.

### Potential scope

- Receive input.
    
- Parse customer-specific data.
    
- Apply Label-O rules.
    
- Generate output.
    
- Interact with WFX.
    
- User review.
    

### Main concern

Customer-specific logic có nguy cơ hard-code cao.

```text
Customer-specific Rule
→ Hard-code
→ Frequent Change
→ High Maintenance
→ Low Scalability
```

### Reactivation criteria

- Clear business priority.
    
- Stable format.
    
- Confirmed H&M requirement.
    
- Measurable manual effort.
    
- Maintainable architecture.
    
- Available resources.
    

---

# PHẦN D — 6 PROJECT ĐÃ ĐÓNG / HỦY

---

## D1. **`MER.PO.Commit.v1.1`**

**Final status:** Done / Closed

### Delivered purpose

Hỗ trợ/tự động hóa customer PO processing cho MER, gồm historical scope như:

- OC-related template.
    
- NPL file.
    
- Packing List.
    
- PO transformation.
    

### Closure rule

- Không đưa vào active WBS.
    
- Không xem là active production support.
    
- Issue production nếu có chuyển sang support ticket.
    
- Enhancement lớn phải được đánh giá như change request hoặc new version.
    

---

## D2. **`EXIM.ExpenseInvoices.Automation.v1.1`**

**Final status:** Done / Closed

### Delivered purpose

Automate expense-invoice processing cho EXIM.

### Relationship

Logic và lesson learned được sử dụng để mở rộng:

`PPJ.ExpenseInvoices.v1.1`

Nhưng lifecycle riêng biệt:

- EXIM project: closed.
    
- PPJ Expense Invoices: active UAT.
    

---

## D3. **`AI.Automation.Workshop.202606`**

**Final status:** Done / Closed

### Delivered purpose

Workshop giới thiệu:

- AI & Automation direction.
    
- Internal use cases.
    
- Team capabilities.
    
- Department opportunities.
    
- Adoption awareness.
    

### Closure treatment

- Event hoàn thành.
    
- Feedback chuyển thành backlog/project riêng.
    
- Không tiếp tục active workshop tasks.
    

---

## D4. **`AI.Automation.Workshop.Analysis.202606`**

**Final status:** Closed / Historical

### Delivered purpose

Phân tích:

- Workshop feedback.
    
- Candidate use cases.
    
- Department opportunities.
    
- Potential backlog.
    

### Closure treatment

Là historical analysis artifact, không phải implementation project.

---

## D5. **`VITAS.Sharing.202606`**

**Final status:** Done / Closed  
**Event date:** 17/06/2026

### Delivered purpose

Chuẩn bị và thực hiện external sharing với VITAS về:

- AI.
    
- Automation.
    
- Digital initiatives.
    
- PPJ practical use cases.
    

### Closure treatment

- Event deliverables hoàn thành.
    
- Follow-up opportunity mới phải tạo initiative riêng.
    
- Không tiếp tục báo cáo như active project.
    

---

## D6. **`PPJxStratova.AI`**

**Final status:** Canceled / Closed

### Historical purpose

Đánh giá khả năng hợp tác/Pattern AI cho:

- Technical.
    
- CPD.
    
- Pattern/design processes.
    

### Final outcome

- Không tiến hành PoC.
    
- Không active development.
    
- Chưa chứng minh được business impact.
    
- Resource không đủ.
    
- Không có proposal đủ rõ.
    

### Reopen conditions

Chỉ reopen khi có:

- Business problem rõ.
    
- Internal sponsor.
    
- Data.
    
- PoC proposal.
    
- Success criteria.
    
- Timeline.
    
- Resource commitment.
    

---

# PHẦN E — PROJECT CẦN XÁC NHẬN LẠI TRẠNG THÁI

## **`MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1`**

Project này tồn tại trong registry/context trước nhưng không xuất hiện trong portfolio summary mới nhất.

### Known historical scope

- MER-led.
    
- Check costing.
    
- Check invoice.
    
- Detect mismatch.
    
- Detect missing/duplicate data.
    
- Produce pass/fail/warning report.
    
- Require MER human review.
    

### Current treatment

Không tự coi:

- Active.
    
- Closed.
    
- Maintenance.
    

Trạng thái nên là:

**Status Confirmation Required**

Cần xác nhận một trong các option:

1. Vẫn active.
    
2. Đã merge vào project khác.
    
3. On hold.
    
4. Closed.
    
5. Chỉ còn historical note.
    

---

# PHẦN F — RANH GIỚI BẮT BUỘC GIỮ

## 1. Finance và Costing

```text
COSTING.AGENTIC.PLATFORM
→ Proposed technical/commercial costing for MER

FIN.AI.FINANCE.MANAGEMENT
→ Finance analysis chatbot and reporting consolidation
```

Future integration có thể là:

```text
Quoted Cost
→ Planned Cost
→ Actual Cost
→ Variance
→ Margin Analysis
```

Nhưng không phải current MVP dependency.

---

## 2. Invoice ecosystem

```text
PPJ.InvoiceDownloader
= Download and structured metadata

PPJ.ExpenseInvoices
= User upload, validation and Accounting review

ACC.GRN-SupplierInvoiceBot
= GRN and supplier-invoice transaction

EXIM.ExpenseInvoices
= Closed specialist automation
```

Không merge bốn lifecycle.

---

## 3. Fabric and visual data

```text
NUNOX = Image Capture
FD Datamart = Fabric + Hanger + QR
CPD Datamart = 3D + Visual + Image Search
```

---

## 4. Wash ecosystem

```text
Wash Sampling Portal = Sample workflow
Cowash = Operational production data
```

---

## 5. PERRI and AI Hub

```text
PERRI = Conversational orchestration
AI Hub = Application catalogue and access point
```

---

# PHẦN G — CURRENT PORTFOLIO PRIORITY

## Priority Tier 1 — Tập trung delivery

1. **`FIN.AI.FINANCE.MANAGEMENT.v1.1`**
    
2. **`COSTING.AGENTIC.PLATFORM.v1.1`**
    
3. **`PPJ.ExpenseInvoices.v1.1`**
    
4. **`SCP.SOURCING.CHATBOT.v2.3`**
    
5. **`PUR.Material.Allocation.v1.1`**
    
6. **`TD.TechnicalKnowledge.Platform.v2.1`**
    
7. **`PPJxQSee.AI`**
    

## Priority Tier 2 — Production / Closeout

- **`PPJ.InvoiceDownloader.v1.2`**
    
- **`PPJ.PERRI.Chatbot.v3.2`**
    
- **`FD.Datamart.v2.2`**
    

## Priority Tier 3 — Business gate trước khi tiếp tục

- **`QC.Primo1D.RFID.Thread.v1.0`**
    
- **`PPJxNUNOX.ScanTrial`**
    
- **`PUR.GDI.Automation.v1.0`**
    
- **`PPJ.UIT.ACADEMIC.COLLABORATION.v1.1`**
    

## Priority Tier 4 — Maintenance

- **`CPD.Datamart.v1.1`**
    
- **`PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0`**
    
- **`PUR.Inventory.Report.v1.0`**
    
- **`ACC.GRN-SupplierInvoiceBot.v2.3`**
    
- **`PUR.Adhoc.Indent.South.v1.0`**
    

## No active capacity

- **`PROD.COWASH.v2.0`**
    
- **`PUR.HM.LabelO.Processing.Automation.v1.0`**
    

## Closed

- **`MER.PO.Commit.v1.1`**
    
- **`EXIM.ExpenseInvoices.Automation.v1.1`**
    
- **`AI.Automation.Workshop.202606`**
    
- **`AI.Automation.Workshop.Analysis.202606`**
    
- **`VITAS.Sharing.202606`**
    
- **`PPJxStratova.AI`**
    

---

# FINAL PORTFOLIO INTERPRETATION

Portfolio hiện không còn là danh sách các automation rời rạc. Nó đang hình thành theo capability stack:

```text
Manual Business Process
→ Process Standardization
→ Structured Data
→ Automation
→ Shared Data Platform
→ System Integration
→ AI Assistant
→ Domain Agent
→ Management Intelligence
```

Ba nguyên tắc quan trọng nhất để quản lý toàn bộ danh mục:

1. **Không bắt đầu bằng AI khi process, source và business rule chưa rõ.**
    
2. **Không merge project chỉ vì dùng chung dữ liệu hoặc cùng phòng ban.**
    
3. **Không giữ project ở trạng thái active vô thời hạn; phải tách rõ Delivery, UAT, Production, Maintenance, On Hold và Closed.**