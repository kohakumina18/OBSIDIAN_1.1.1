---
type: weekly_portfolio_report
reporting_period: "2026-07-27 to 2026-08-01"
planning_period: "2026-08-03 to 2026-08-08"
source_event: "PPJ-WEEKLY-20260727-20260801"
evidence: "User-approved Weekly Portfolio Update for 2026-07-27 to 2026-08-01"
last_verified: "2026-08-01"
---
# PPJ AI & AUTOMATION TEAM

# WEEKLY PORTFOLIO UPDATE

**Kỳ báo cáo:** 27/07/2026–01/08/2026  
**Kỳ kế hoạch tiếp theo:** 03/08/2026–08/08/2026  
**Phạm vi:** Các dự án có cập nhật mới trong tuần  
**Phân loại:** Theo Primary Business Domain và lifecycle

## 1. Executive Summary

Trong tuần 27/07–01/08/2026, portfolio ghi nhận bốn chuyển động chính:

1. **Các dự án chiến lược đã tiến sâu hơn vào data foundation và rule definition**
    
    - **`FIN.AI.FINANCE.MANAGEMENT.v1.2`** gần hoàn tất danh mục nguồn dữ liệu cho nhóm kiểm soát chi phí và hiệu quả đơn hàng.
        
    - Phần lớn nguồn cần thiết hiện nằm trong Databricks nhưng team chưa có tài khoản truy cập, tạo thành blocker lớn nhất.
        
    - Rule Engine cho phân tích theo OC đang được tổng hợp và dự kiến chốt trong tuần tiếp theo.
        
2. **Các giải pháp nghiệp vụ đã bắt đầu chuyển từ prototype sang triển khai**
    
    - **`HR.SSPFD.Workflow.v1.1`** đã hoàn thành demo/UAT, có User Manual và bắt đầu triển khai chuẩn hóa dữ liệu nhân sự toàn tập đoàn.
        
    - **`COSTING.AGENTIC.PLATFORM.v1.1`** đã hoàn thành demo Sew Costing v1.1 và bắt đầu phát triển v1.2.
        
    - **`TD.TechnicalKnowledge.Platform.v2.1`** đã hoàn thành ETL cho các nguồn Technical hiện được xác định.
        
3. **Hướng tích hợp hệ thống chuyển từ thao tác mô phỏng sang API-first**
    
    - **`PUR.GDI.Automation.v1.0`** chuyển định hướng từ Selenium sang sử dụng API create/update.
        
    - Luồng nghiệp vụ đã được xác nhận với Purchasing và một số MER leaders/managers.
        
4. **Một số dự án bước vào closeout, support hoặc chờ quyết định nguồn lực**
    
    - **`SCP.SOURCING.CHATBOT.v2.3`** đang chốt output cuối và dự kiến nghiệm thu, bàn giao trong tuần tiếp theo.
        
    - **`PPJxQSee.AI`** chưa đủ nguồn lực nội bộ để tiếp tục follow-up, dù NDA đã được ký.
        
    - **`PPJxNUNOX.ScanTrial`** đang chờ ý kiến lãnh đạo về buổi làm việc ngày 17–18/08 và định hướng Digital Library.
        
    - **`PPJxStratova.AI`** xuất hiện cơ hội hợp tác mới liên quan funding từ Google nhưng commercial model và chi phí cloud vẫn chưa rõ.
        

## 2. Portfolio Movement Summary

|Dự án|Domain|Cập nhật chính|Trạng thái đề xuất|
|---|---|---|---|
|**`FIN.AI.FINANCE.MANAGEMENT.v1.2`**|Finance / Accounting|Gần hoàn tất source inventory cho nhóm công việc 2; bị block tài khoản Databricks; đang chốt Rule Engine|Data Discovery / Access Blocked / Rule Design|
|**`HR.SSPFD.Workflow.v1.1`**|HR|Hoàn thành demo, UAT, User Manual và bắt đầu rollout|Initial Deployment / Group Rollout|
|**`PUR.GDI.Automation.v1.0`**|Sourcing / Purchasing|Confirm business flow; chuyển từ Selenium sang API-first|Solution Redesign / API Integration Discovery|
|**`TD.TechnicalKnowledge.Platform.v2.1`**|Fabric / Textiles Technique|Hoàn thành ETL các nguồn Technical vào v2.1|Data Foundation Completed / Application Layer Next|
|**`PPJxStratova.AI`**|Fabric / Textiles Technique|Có cơ hội mới liên quan funding Google; chờ làm việc và direction lãnh đạo|Reopened Discussion / Pending Direction|
|**`COSTING.AGENTIC.PLATFORM.v1.1`**|Merchandising|Demo hoàn tất Sew Costing v1.1; bắt đầu v1.2 và integration với GTAS/IED|v1.2 Development|
|**`SCP.SOURCING.CHATBOT.v2.3`**|Sourcing / Purchasing|Chốt output format; chuẩn bị nghiệm thu và bàn giao|Closeout Preparation|
|**`PPJ.ExpenseInvoices.v1.1`**|Finance / Accounting|Tiếp tục UAT, bổ sung supplier và mapping|UAT / Mapping Expansion|
|**`PUR.Inventory.Report.v2.1`**|Sourcing / Purchasing|Hoàn thiện thêm báo cáo cho Purchasing|Production Enhancement / v2.1|
|Accounting Inventory Report|Finance / Accounting|Được đưa vào backlog nhưng chưa có nguồn lực|Backlog / Pending Resource|
|**`PPJxNUNOX.ScanTrial`**|Fabric / Textiles Technique|Đề xuất buổi làm việc ngày 17–18/08 và Digital Library|Partnership Discussion / Pending Approval|
|**`PPJxQSee.AI`**|QC / TQM|QC/TQM chưa đủ nguồn lực follow-up; NDA đã ký|On Hold / Resource Constraint|

## 3. Detailed Project Updates

## **`FIN.AI.FINANCE.MANAGEMENT.v1.2`**

**Nền tảng kiểm soát và phân tích tài chính tập trung**

**Domain:** Finance / Accounting  
**Current Status:** Data Discovery / Databricks Access Blocked / Rule Engine Design

### Goal

Xây dựng nền tảng giúp Kế toán:

- Đối chiếu kế hoạch và thực tế theo từng OC;
    
- Phát hiện thiếu chi phí, sai OC và sai kỳ;
    
- Kiểm tra tính đầy đủ của nguyên phụ liệu và chi phí gia công;
    
- Quản lý ngoại lệ;
    
- Phân tích hiệu quả từng đơn hàng;
    
- Drill-down từ cấp tập đoàn xuống công ty và nhà máy;
    
- Cung cấp dữ liệu đáng tin cậy cho báo cáo, Power BI và AI.
    

### Latest Update

Team đã tổng hợp lại các nguồn dữ liệu cần thiết cho:

- **Nhóm công việc 2:** Kiểm soát chi phí và hiệu quả đơn hàng;
    
- Một phần **Nhóm công việc 3:** Phân tích chi phí và hiệu quả khi drill-down xuống từng nhà máy.
    

Danh mục nguồn dữ liệu cho Nhóm công việc 2 hiện đã gần hoàn tất, bao gồm các nguồn liên quan đến:

- Costing plan;
    
- BOM và consumption;
    
- Nguyên phụ liệu xuất và trả kho;
    
- Chi phí gia công;
    
- PO;
    
- Receipt hoặc xác nhận hoàn thành;
    
- Supplier invoice;
    
- Accounting posting;
    
- Overhead;
    
- OC;
    
- Style;
    
- Customer;
    
- Company;
    
- Factory;
    
- Revenue và COGS.
    

### Current Data Architecture Finding

Phần lớn các nguồn dữ liệu cần thiết:

- Không nằm sẵn trong Data Warehouse hiện tại;
    
- Đang tồn tại trong Databricks database hoặc Databricks data environment;
    
- Cần được xác định đúng table, schema, grain và linking key trước khi xây Rule Engine.
    

Team đang chuẩn bị hoặc đã gửi request nhằm:

- Xác định đúng nguồn dữ liệu trong Databricks;
    
- Xin quyền đọc dữ liệu;
    
- Xin tài khoản truy cập trực tiếp;
    
- Xác định owner của từng dataset;
    
- Xác định phương thức truy cập được phê duyệt.
    

### Current Blocker

Blocker chính hiện tại là:

> Team chưa có tài khoản được cấp quyền để truy cập Databricks.

Điều này ảnh hưởng trực tiếp đến khả năng:

- Profile dữ liệu;
    
- Kiểm tra completeness;
    
- Xác định grain;
    
- Kiểm tra join key;
    
- Xây dữ liệu mẫu;
    
- Xác nhận source of truth;
    
- Chạy thử Rule Engine.
    

Team đã thực hiện tờ trình xin tài khoản truy cập Databricks và đang chờ phê duyệt.

### Rule Engine Progress

Team đã tổng hợp bước đầu các Rule Engine cần thiết để phân tích chi tiết theo từng đơn hàng và OC.

Các nhóm rule dự kiến gồm:

#### Nguyên phụ liệu

- Đơn hàng đã bán nhưng chưa có đầy đủ chi phí nguyên phụ liệu;
    
- Thực tế vượt kế hoạch;
    
- Thực tế thấp bất thường;
    
- Vật tư thực tế không có trong BOM;
    
- Ghi nhận sai OC;
    
- Ghi nhận sai kỳ;
    
- Chưa ghi nhận hoàn trả;
    
- Duplicate warehouse issue;
    
- Sai đơn vị tính;
    
- Sai hoặc thiếu tỷ giá.
    

#### Chi phí gia công

- Có kế hoạch nhưng chưa có PO;
    
- Có PO nhưng chưa xác nhận hoàn thành;
    
- Đã hoàn thành nhưng chưa có invoice;
    
- Có invoice nhưng chưa accounting posting;
    
- Ghi nhận sai OC;
    
- Ghi nhận sai kỳ;
    
- Duplicate invoice hoặc posting;
    
- Chi phí vượt kế hoạch;
    
- OC đã bán nhưng vòng đời chi phí chưa hoàn tất.
    

#### Hiệu quả đơn hàng

- Lợi nhuận âm;
    
- Lợi nhuận thấp hơn ngưỡng;
    
- Lợi nhuận cao bất thường;
    
- Gross Margin tốt nhưng Final Margin thấp;
    
- COGS ratio tăng mạnh;
    
- Thiếu một hoặc nhiều cost components;
    
- Lợi nhuận bị sai lệch do chi phí khác kỳ hoặc sai OC.
    

### Next Actions

1. Theo dõi phê duyệt tài khoản Databricks.
    
2. Chốt Databricks access model:
    
    - Account;
        
    - Role;
        
    - Catalog;
        
    - Schema;
        
    - Table;
        
    - Read-only permission.
        
3. Hoàn thiện Source Inventory cho Nhóm công việc 2.
    
4. Xác nhận source owner và source of truth.
    
5. Profile dữ liệu theo từng nguồn.
    
6. Chốt OC và các linking keys.
    
7. Hoàn thành Rule Engine Catalogue.
    
8. Xác nhận rule với Accounting.
    
9. Chọn 20–30 OC mẫu.
    
10. Chạy Rule Engine thử nghiệm trên dữ liệu mẫu.
    
11. So sánh kết quả với cách kiểm tra thủ công của Kế toán.
    
12. Chỉ mở rộng nhóm công việc 3 sau khi nhóm công việc 2 ổn định.
    

### Risks / Decisions Required

- Chưa có Databricks access;
    
- Dữ liệu không nằm trong DWH được quản trị chính thức;
    
- Chưa rõ một số table có phải source of truth hay chỉ là intermediate table;
    
- OC linking key có thể không đầy đủ;
    
- Nhiều rule cần Accounting phê duyệt;
    
- Chưa chốt ngưỡng cảnh báo;
    
- Phạm vi nhóm công việc 3 có nguy cơ mở rộng quá sớm.
    

## **`HR.SSPFD.Workflow.v1.1`**

**HR Data Standardization and Applicant Intake Workflow**

**Domain:** HR  
**Current Status:** UAT Completed / Initial Deployment / Group Rollout

### Goal

Dự án hiện được xác định gồm hai workflow riêng biệt.

### Workflow 1 — Employee Master Data Standardization

Mục tiêu:

- Chuẩn hóa toàn bộ dữ liệu nhân viên trên phạm vi tập đoàn;
    
- Liên kết dữ liệu dựa trên các định danh chính;
    
- Giảm duplicate và inconsistent employee records;
    
- Tạo employee master đáng tin cậy cho các hệ thống HR downstream.
    

Các trường định danh quan trọng gồm:

- Số căn cước công dân;
    
- Mã nhân viên;
    
- Họ tên;
    
- Công ty;
    
- Nhà máy;
    
- Phòng ban;
    
- Trạng thái làm việc;
    
- Ngày vào làm;
    
- Các trường liên quan khác theo data model HR.
    

### Workflow 2 — Applicant Data Extraction and Application Form Prefill

Mục tiêu:

- Giảm việc ứng viên điền nhiều biểu mẫu thủ công;
    
- Giảm việc HR nhập lại dữ liệu từ hồ sơ ứng tuyển;
    
- Trích xuất dữ liệu từ hồ sơ hoặc input của ứng viên;
    
- Tự động điền dữ liệu vào form ứng tuyển theo format chuẩn.
    

Target flow:

```text
Applicant submits information or documents
→ System extracts applicant data
→ System validates required fields
→ Application form is prefilled
→ Applicant or HR reviews
→ Confirmed application is submitted
→ HR system receives structured data
```

### Latest Update

Trong tuần, dự án đã:

- Thực hiện buổi demo;
    
- Thực hiện UAT;
    
- Hoàn thành kiểm thử bước đầu;
    
- Bắt đầu push solution lên hệ thống;
    
- Hoàn thành User Manual;
    
- Bắt đầu triển khai trên toàn tập đoàn để chuẩn hóa dữ liệu.
    

### Next Actions

1. Theo dõi rollout theo công ty và nhà máy.
    
2. Chốt employee matching rules.
    
3. Xác định cách xử lý:
    
    - Một CCCD có nhiều mã nhân viên;
        
    - Một mã nhân viên có nhiều hồ sơ;
        
    - Nhân viên nghỉ và quay lại;
        
    - CCCD thay đổi hoặc nhập sai.
        
4. Theo dõi UAT issues.
    
5. Fix và retest.
    
6. Chốt data owner và correction authority.
    
7. Xây rollout status dashboard.
    
8. Bổ sung hướng dẫn cho Workflow 2.
    
9. Xác định applicant consent và privacy requirements.
    
10. Bàn giao production support.
    

### Risks / Decisions Required

- Dữ liệu nhân sự nhạy cảm;
    
- Matching sai có thể merge nhầm hồ sơ;
    
- Chưa rõ owner xử lý conflicting records;
    
- Workflow 2 cần kiểm soát dữ liệu ứng viên và consent;
    
- Cần xác nhận ownership giữa AI Team và Software Team sau rollout.
    

## **`PUR.GDI.Automation.v1.0`**

**Goods Delivery Instruction Automation**

**Domain:** Sourcing / Purchasing  
**Current Status:** Business Flow Confirmed / API-first Redesign

### Goal

Tự động hóa việc tạo GDI và giảm thao tác thủ công của Purchasing trên WFX.

### Latest Business Confirmation

Trong tuần 27/07–01/08/2026, team đã xác nhận luồng GDI Automation với:

- Các nhóm Purchasing liên quan;
    
- Một số MER leaders;
    
- Một số MER managers.
    

Business flow đã rõ hơn về:

- User input;
    
- Dữ liệu cần lấy;
    
- Điều kiện tạo GDI;
    
- Review và confirmation;
    
- Vai trò của Purchasing và MER;
    
- Output cần tạo trên hệ thống.
    

### Architecture Change

Hướng cũ:

```text
User input
→ Selenium mở nhiều màn hình
→ Mô phỏng click và nhập liệu
→ Tạo GDI
```

Hướng mới:

```text
User input
→ Validate
→ Retrieve required data
→ Call approved API
→ Create or update GDI record
→ Return transaction result
→ Audit
```

Việc chuyển từ Selenium sang API giúp:

- Giảm phụ thuộc giao diện WFX;
    
- Giảm lỗi do screen change;
    
- Tăng tốc xử lý;
    
- Tăng khả năng kiểm soát dữ liệu;
    
- Dễ audit;
    
- Dễ xử lý exception;
    
- Dễ scale hơn.
    

### Critical Architecture Clarification

Cần làm rõ chính xác hệ thống đích của API.

GDI là một giao dịch nghiệp vụ, vì vậy API create/update nên:

- Gọi API chính thức của WFX;
    
- Hoặc gọi service được WFX/vendor phê duyệt;
    
- Hoặc ghi vào transactional system có governance chính thức.
    

Không nên mặc định ghi trực tiếp GDI transaction vào Databricks table nếu Databricks chỉ là data lakehouse hoặc analytical database.

```text
Recommended:
Application → WFX API → WFX Transaction → Databricks/DWH Sync

High-risk:
Application → Direct Write to Databricks → Assume WFX Updated
```

### Next Actions

1. Xin API documentation từ WFX.
    
2. Xác định API hỗ trợ:
    
    - Create;
        
    - Update;
        
    - Draft;
        
    - Submit;
        
    - Cancel;
        
    - Query status.
        
3. Xác định authentication method.
    
4. Xác định request/response schema.
    
5. Xác định idempotency và duplicate rules.
    
6. Xác định transaction rollback.
    
7. Xác định audit requirements.
    
8. Chốt review/approval trước khi submit.
    
9. Build API prototype.
    
10. Chạy integration test với test environment.
    
11. Không ghi trực tiếp production records nếu chưa có vendor approval.
    

## **`TD.TechnicalKnowledge.Platform.v2.1`**

**Technical Data and Knowledge Platform**

**Domain:** Fabric / Textiles Technique  
**Current Status:** ETL Completed / Data Foundation Available

### Goal

Xây dựng Technical data foundation hỗ trợ:

- Technical search;
    
- Pattern;
    
- BOM;
    
- Construction;
    
- Consumption;
    
- Technical documentation;
    
- Historical data;
    
- Costing Agentic Platform;
    
- Future Technical AI capability.
    

### Latest Update

Team đã hoàn thành ETL cho các nguồn dữ liệu Technical hiện được xác định trong scope v2.1.

Dữ liệu đã được:

- Extract từ các source systems;
    
- Transform;
    
- Chuẩn hóa bước đầu;
    
- Load vào data layer của Technical Platform;
    
- Tổ chức phục vụ search, retrieval và AI layer trong tương lai.
    

### Business Value

Việc hoàn thành ETL tạo nền tảng cho:

- Search Technical records;
    
- Linking Style, Buyer Reference, BOM và Pattern;
    
- Truy xuất dữ liệu consumption;
    
- Tìm historical cases;
    
- Hỗ trợ Sew Costing;
    
- Hỗ trợ Fabric Consumption Costing;
    
- Hỗ trợ Wash Costing;
    
- Xây RAG hoặc domain AI trên dữ liệu Technical.
    

### Next Actions

1. Chạy data-quality validation.
    
2. Xác định ETL coverage.
    
3. Kiểm tra duplicate.
    
4. Kiểm tra missing keys.
    
5. Xác định record version.
    
6. Xác định approved/latest version.
    
7. Chạy reconciliation với source systems.
    
8. Xây search và retrieval layer.
    
9. Xác định permissions.
    
10. Kết nối dữ liệu consumption với Costing Platform.
    
11. Chuẩn bị Technical user UAT.
    

### Risk

ETL complete không đồng nghĩa dữ liệu đã production-ready.

Cần xác nhận:

- Completeness;
    
- Accuracy;
    
- Freshness;
    
- Version;
    
- Ownership;
    
- Source lineage;
    
- Permission.
    

## **`COSTING.AGENTIC.PLATFORM.v1.1`**

**Costing Agentic Platform**

**Domain:** Merchandising  
**Current Status:** Sew Costing v1.1 Demo Completed / v1.2 Development

### Goal

Tạo Costing / Quotation Package để Merchandising review và propose quotation tới khách hàng.

### Latest Update — Sew Costing

Team đã hoàn tất demo version 1.1 của Sew Costing.

Version 1.1 đã chứng minh được khả năng:

- Nhận description;
    
- Bóc tách sewing operations;
    
- Chuẩn hóa danh sách công đoạn;
    
- Tạo dữ liệu đầu vào ban đầu cho tính SAM và Sew Cost.
    

### Version 1.2 Focus

Version 1.2 tập trung vào:

- Cải thiện độ chính xác của SAM;
    
- Mapping operation với standard time;
    
- Mapping operation với machine type;
    
- Xử lý các description không đầy đủ;
    
- Tìm historical similar products;
    
- Bổ sung confidence;
    
- Bổ sung expert review;
    
- Chuẩn bị truyền dữ liệu sang GTAS/IED.
    

Target flow:

```text
Product / Sewing Description
→ Operation Extraction
→ Operation Standardization
→ Machine and Standard Time Mapping
→ SAM Calculation
→ Expert Review
→ GTAS/IED Data Transfer
```

### Wash Agent Parallel Workstream

Wash Agent đang được phát triển song song với Sew Costing.

Wash Agent tập trung:

- Free-text wash intake;
    
- Attribute extraction;
    
- Fabric, color, shade và effect;
    
- Similar recipe retrieval;
    
- Draft process suggestion;
    
- Risk warning;
    
- Expert review.
    

### Technical Platform Dependency

**`TD.TechnicalKnowledge.Platform.v2.1`** là dependency quan trọng cho Costing Platform, đặc biệt với:

- Consumption data;
    
- Pattern;
    
- BOM;
    
- Construction;
    
- Historical Technical records;
    
- Similar styles.
    

Khi dữ liệu Technical đã được ETL và chuẩn hóa, việc xây lớp AI tạo sinh hoặc recommendation sẽ nhanh và chính xác hơn.

### Next Actions

1. Đánh giá demo v1.1 với Sew experts.
    
2. Xây accuracy baseline.
    
3. Phân tích lỗi operation extraction.
    
4. Cải thiện SAM calculation.
    
5. Chốt data contract với GTAS/IED.
    
6. Xác định API hoặc integration format.
    
7. Kết nối Technical consumption data.
    
8. Tiếp tục Wash Agent dataset collection.
    
9. Tách rõ:
    
    - AI suggestion;
        
    - Expert-approved result;
        
    - Final data transferred to GTAS/IED.
        

## **`SCP.SOURCING.CHATBOT.v2.3`**

**Sourcing Chatbot and Data Platform**

**Domain:** Sourcing / Purchasing  
**Current Status:** Output Finalization / Closeout Preparation

### Latest Update

Team đang chốt output format chính thức cuối cùng của current release.

Project dự kiến trong tuần tiếp theo sẽ:

- Nghiệm thu;
    
- Bàn giao;
    
- Đóng active development scope.
    

### Remaining Work Before Closeout

1. Chốt output format.
    
2. Xác nhận UAT acceptance.
    
3. Hoàn thành User Manual.
    
4. Hoàn thành support handover.
    
5. Tách defect và enhancement.
    
6. Chốt data owner.
    
7. Chốt permission owner.
    
8. Chuyển remaining issues sang maintenance backlog.
    

### Future MER Usage

Việc mở rộng để MER sử dụng vẫn cần:

- Stress test;
    
- Performance test;
    
- Permission review;
    
- Search-quality testing;
    
- Data normalization;
    
- Chuẩn hóa supplier, material và sample metadata;
    
- Kiểm soát completeness của external data.
    

### External Data Problem

Sourcing hiện gặp nhiều vấn đề khi nhập dữ liệu bên ngoài:

- Phải nhập tay;
    
- Thiếu nhiều field;
    
- Không thống nhất template;
    
- Numeric và category values bị trộn;
    
- Naming không chuẩn;
    
- Duplicate;
    
- Missing supplier hoặc material attributes;
    
- Không có data validation tại thời điểm nhập.
    

### Recommendation

Có thể close active-development scope nhưng phải mở riêng:

> **Sourcing External Data Standardization Backlog**

Backlog này nên xử lý:

- Standard input template;
    
- Required fields;
    
- Data types;
    
- Controlled vocabulary;
    
- Duplicate checks;
    
- Validation;
    
- Import tool;
    
- Data-quality dashboard.
    

## **`PPJ.ExpenseInvoices.v1.1`**

**Expense Invoice Automation**

**Domain:** Finance / Accounting  
**Current Status:** UAT / Supplier and Mapping Expansion

_Tôi đang hiểu cụm “spending voice” trong phần cập nhật là dự án Expense Invoices._

### Latest Update

Team tiếp tục:

- Chạy UAT;
    
- Bổ sung mapping;
    
- Bổ sung các nhà cung cấp thường xuyên giao dịch;
    
- Điều chỉnh bot để hỗ trợ nhập phiếu Expense Invoice;
    
- Ghi nhận lỗi từ dữ liệu thực tế;
    
- Fix và retest.
    

### Current Focus

- Supplier master;
    
- Supplier-specific mapping;
    
- Department/factory mapping;
    
- Ledger/account mapping;
    
- Input validation;
    
- Duplicate detection;
    
- Error handling;
    
- User guidance.
    

### Next Actions

1. Chốt danh sách frequent suppliers.
    
2. Chuẩn hóa supplier codes.
    
3. Chốt mapping ownership.
    
4. Đóng các critical defects.
    
5. Chạy regression test.
    
6. Chốt go-live boundary.
    
7. Chuẩn bị production monitoring.
    
8. Chốt support và escalation process.
    

## **`PUR.Inventory.Report.v2.1`**

**Purchasing Inventory Report**

**Domain:** Sourcing / Purchasing  
**Current Status:** v2.1 Enhancement Completed / Production Support

### Latest Update

Inventory Report đã được nâng lên version 2.1 nhằm hoàn thiện thêm:

- Reports;
    
- Tables;
    
- Filters;
    
- Purchasing visibility;
    
- Operational analysis.
    

### Primary Users

- Purchasing;
    
- Material planning;
    
- Related inventory users.
    

### Next Actions

1. Thu feedback sau v2.1.
    
2. Validate report totals.
    
3. Kiểm tra refresh.
    
4. Kiểm tra source reconciliation.
    
5. Chốt enhancement backlog.
    
6. Theo dõi production stability.
    

## Accounting Inventory Report

**Proposed Project / Backlog Item**

**Domain:** Finance / Accounting  
**Current Status:** Backlog / Pending Resource

### Goal

Xây dựng Inventory Report dành cho Accounting, tạo data input hoặc control baseline trước khi dữ liệu được sử dụng trong các bước Purchasing và Finance liên quan.

### Current Status

- Đã được đưa vào backlog;
    
- Chưa có đủ nhân lực triển khai;
    
- Chưa có confirmed timeline;
    
- Chưa có detailed requirement package.
    

### Required Clarification

Trước khi triển khai cần xác định:

- Accounting business questions;
    
- Source of truth;
    
- Relationship với Purchasing Inventory Report;
    
- Report grain;
    
- Closing period logic;
    
- Valuation logic;
    
- Inventory aging;
    
- Ownership;
    
- Acceptance criteria.
    

Không nên mặc định đây chỉ là một tab bổ sung của Purchasing report nếu Finance cần logic và source khác.

## **`PPJxNUNOX.ScanTrial`**

**Fabric and Garment Digital Library Opportunity**

**Domain:** Fabric / Textiles Technique  
**Current Status:** Vendor Visit Proposed / Pending Leadership Approval

### Latest Update

NUNOX đề xuất đến làm việc và hướng dẫn chính thức trong khoảng ngày:

- 17/08/2026;
    
- 18/08/2026.
    

Mục tiêu của buổi làm việc có thể bao gồm:

- Hướng dẫn sử dụng thiết bị;
    
- Push adoption;
    
- Xây quy trình digitization;
    
- Thảo luận Digital Online Library;
    
- Kết nối dữ liệu fabric và garment samples.
    

### Potential Business Vision

Digital Library có thể phục vụ:

- Merchandising;
    
- Sourcing;
    
- Technical;
    
- CPD;
    
- Ban Giám đốc;
    
- Customer presentation;
    
- Partner showcase.
    

Potential content:

- Fabric samples;
    
- Hanger;
    
- Garment samples;
    
- Historical products;
    
- Texture images;
    
- Color references;
    
- Product images;
    
- Buyer references;
    
- Technical metadata.
    

### Next Actions

1. Xin direction từ lãnh đạo.
    
2. Xác nhận lịch 17–18/08.
    
3. Chốt mục tiêu buổi làm việc.
    
4. Chọn sample dataset.
    
5. Xác định user groups.
    
6. Đánh giá scanner workflow.
    
7. Đánh giá storage và access.
    
8. Xác định relationship với FD Datamart, CPD Datamart và Technical Platform.
    
9. Xây business case trước khi ký commercial agreement.
    

## **`PPJxStratova.AI`**

**Pattern and Technical AI Collaboration**

**Domain:** Fabric / Textiles Technique  
**Current Status:** Reopened Discussion / Pending Leadership Direction

### Latest Update

Theo cập nhật từ phía đối tác:

- Stratova vừa nhận được funding hoặc support liên quan đến Google;
    
- Dự kiến có buổi gặp Google tại Park Hyatt, TP.HCM vào thứ Tư;
    
- Buổi làm việc nhằm làm rõ các nội dung Google có thể hỗ trợ.
    

### Key Commercial Concerns

- Chi phí cloud của Google không thấp;
    
- Chi phí license hoặc bản quyền Stratova vẫn có thể phát sinh;
    
- Funding chưa chắc bao phủ toàn bộ implementation cost;
    
- Chưa rõ PPJ nhận được credit, service hay technical support;
    
- Chưa rõ chi phí sau funding period;
    
- Chưa rõ quyền sở hữu dữ liệu và model;
    
- Chưa có direction chính thức từ lãnh đạo.
    

### Portfolio Governance Note

**`PPJxStratova.AI`** trước đây được ghi nhận là Canceled / Closed.

Không nên tự động đổi lifecycle sang active project chỉ vì xuất hiện funding opportunity.

Có hai lựa chọn quản trị:

1. Giữ project cũ ở trạng thái Closed và tạo một opportunity mới;
    
2. Chính thức reopen project sau khi lãnh đạo phê duyệt.
    

### Next Actions

1. Tham gia buổi làm việc với Google/Stratova.
    
2. Làm rõ funding scope.
    
3. Làm rõ Google Cloud credits.
    
4. Làm rõ Stratova license.
    
5. Làm rõ implementation và support cost.
    
6. Làm rõ data ownership.
    
7. Làm rõ model ownership.
    
8. Xác định PPJ use case cụ thể.
    
9. Chuẩn bị option paper cho lãnh đạo:
    
    - Proceed;
        
    - Pilot with credits;
        
    - Negotiate;
        
    - Hold;
        
    - Reject.
        

## **`PPJxQSee.AI`**

**QC AI Vision PoC**

**Domain:** QC / TQM  
**Current Status:** On Hold / Resource Constraint

### Latest Update

Sau khi nhận đánh giá từ QC và TQM:

- Các đơn vị nhận thấy hiện chưa đủ nguồn lực để tiếp tục follow-up dự án;
    
- NDA với đối tác đã được ký;
    
- Chưa có thông tin đầy đủ về quyết định dừng, hoãn hoặc thời điểm đánh giá lại.
    

### Recommended Lifecycle

```text
On Hold / Internal Resource Constraint
```

### Conditions to Resume

- Có QC owner;
    
- Có TQM owner;
    
- Có dataset owner;
    
- Có nguồn lực label và validate;
    
- Có pilot scope;
    
- Có success criteria;
    
- Có thời gian của factory/QC;
    
- Có budget hoặc sponsor;
    
- Có go/no-go authority.
    

### Important Note

Việc đã ký NDA không đồng nghĩa PPJ phải tiếp tục PoC hoặc commercial engagement.

NDA chỉ tạo khung bảo mật cho việc trao đổi thông tin. Quyết định đầu tư cần dựa trên:

- Business value;
    
- Resources;
    
- Data readiness;
    
- Technical feasibility;
    
- Commercial terms.
    

Phần cập nhật QSee trong nội dung bạn gửi đang kết thúc ở câu “mặc dù đã ký NDA”, nên chưa có đủ thông tin để xác nhận vendor đã được thông báo hay chưa và project sẽ hold trong bao lâu.

## 4. Cross-project Dependencies

### Finance và Databricks

```text
Databricks Sources
→ Finance Source Inventory
→ Data Profiling
→ Rule Engine
→ OC Exception Detection
→ Accounting Validation
```

Không có Databricks access thì Finance Rule Engine chưa thể bước sang data validation thực tế.

### Technical Platform và Costing

```text
Technical Platform ETL
→ Pattern / BOM / Consumption / Construction
→ Sew and Consumption Costing
→ Costing Package
```

### GDI và WFX Integration

```text
Confirmed Purchasing Workflow
→ WFX API
→ Controlled GDI Transaction
→ Audit and Status
```

### Sourcing Chatbot và External Data

```text
External Manual Input
→ Data Validation
→ Standardization
→ Sourcing Data Platform
→ Chatbot Search Quality
```

Nếu external data chưa sạch, stress test hệ thống cũng không thể chứng minh đúng chất lượng chatbot.

## 5. Management Attention

### 5.1 Databricks access là blocker cấp portfolio

Không chỉ Finance, các dự án Technical, Costing và reporting có thể tiếp tục phụ thuộc Databricks.

Cần xác định một access model chính thức thay vì xin tài khoản riêng lẻ theo từng dự án.

### 5.2 Không ghi transaction trực tiếp vào Databricks nếu chưa xác nhận kiến trúc

Databricks phù hợp cho data engineering và analytics. GDI transaction cần đi qua WFX hoặc service được phê duyệt.

### 5.3 HR đã rollout nhưng ownership cần được chốt

Cần làm rõ Software Team, AI Team hay HR IT là owner vận hành sau triển khai.

### 5.4 Sourcing có thể close project nhưng chưa thể coi data foundation đã hoàn thiện

Closeout sản phẩm chatbot nên tách khỏi backlog chuẩn hóa external Sourcing data.

### 5.5 Technical ETL completed cần Data Acceptance

ETL hoàn thành là technical milestone. Cần Technical users nghiệm thu completeness, accuracy và version.

### 5.6 Stratova cần business case, không chỉ funding story

Google funding hoặc credits có thể giảm chi phí thử nghiệm nhưng không tự động làm solution có ROI tốt.

## 6. Priority Plan for 03/08–08/08/2026

|Priority|Project|Required Output|
|--:|---|---|
|P1|**`FIN.AI.FINANCE.MANAGEMENT.v1.2`**|Databricks access decision và finalized Rule Engine Catalogue|
|P2|**`PUR.GDI.Automation.v1.0`**|WFX API request và target integration architecture|
|P3|**`COSTING.AGENTIC.PLATFORM.v1.1`**|Sew Costing v1.2 accuracy plan và GTAS/IED data contract|
|P4|**`SCP.SOURCING.CHATBOT.v2.3`**|UAT acceptance, handover và closeout package|
|P5|**`HR.SSPFD.Workflow.v1.1`**|Rollout monitoring và production ownership|
|P6|**`TD.TechnicalKnowledge.Platform.v2.1`**|ETL reconciliation và Technical data acceptance|
|P7|**`PPJ.ExpenseInvoices.v1.1`**|Supplier mapping completion và UAT defect closure|
|P8|**`PPJxStratova.AI`**|Google/Stratova meeting note và leadership option paper|
|P9|**`PUR.Inventory.Report.v2.1`**|Post-release validation và enhancement backlog|
|P10|**`PPJxNUNOX.ScanTrial`**|Leadership decision và visit preparation|
|P11|**`PPJxQSee.AI`**|Formal hold status và reactivation criteria|

## 7. Weekly Conclusion

Trong tuần 27/07–01/08/2026, portfolio tiếp tục chuyển từ prototype sang data integration, rollout và production governance.

Các tiến triển quan trọng nhất gồm:

- Finance gần hoàn thành source inventory cho kiểm soát chi phí theo OC nhưng đang bị block bởi Databricks access.
    
- HR đã hoàn thành UAT và bắt đầu rollout hai workflow về chuẩn hóa employee data và applicant intake.
    
- GDI Automation chuyển sang hướng API-first sau khi business flow được xác nhận.
    
- Technical Platform đã hoàn thành ETL data foundation v2.1.
    
- Sew Costing v1.1 đã demo hoàn tất và bắt đầu v1.2.
    
- Sourcing Chatbot chuẩn bị nghiệm thu và bàn giao.
    
- Expense Invoices tiếp tục UAT và mở rộng supplier mapping.
    
- Inventory Report Purchasing đã lên v2.1; Accounting Inventory Report đang chờ nguồn lực.
    
- NUNOX và Stratova mở ra các cơ hội hợp tác mới nhưng vẫn cần direction và commercial assessment.
    
- QSee chuyển sang trạng thái On Hold do hạn chế nguồn lực nội bộ.
    


