# PPJ AI / Automation / Data Portfolio

## Full Project Description & Canonical Naming Dictionary

---

# 1. Nguyên tắc hiểu chung

Từ giờ, mỗi project sẽ được discuss theo **Canonical Code**. Các tên gọi miệng, tên file cũ, alias hoặc tên chưa chuẩn sẽ được map về một project chính để tránh tách scope sai.

Format chuẩn:

```text
[DEPT/DOMAIN].[OBJECT].[CHARACTERISTIC].vX.Y
```

Ví dụ:

```text
SCP.SOURCING.CHATBOT.v2.3
FD.Datamart.v2.2
CPD.Datamart.v1.1
PUR.Material.Allocation.v1.1
COSTING.AGENTIC.PLATFORM.v1.1
MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1
```

Các scope lock quan trọng:

- `FD.Datamart.v2.2` khác hoàn toàn `CPD.Datamart.v1.1`.
    
- `SCP.SOURCING.CHATBOT.v2.3` là project consolidated cho Sourcing, không tự tách nhỏ.
    
- `COSTING.AGENTIC.PLATFORM.v1.1` gom tất cả alias như Costing Intelligence, MER Costing, Merchandising Intelligence.
    
- `PPJ.AI.Hub.v2.1` là hub/index/app center, không phải project delivery để gộp toàn bộ note.
    
- `MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1` là MER-led, không tự chuyển thành Accounting project.
    

---

# 2. AI / Chatbot / Knowledge / Platform

---

## 2.1 `PPJ.AI.Hub.v2.1`

**Alias:** AI Hub, PPJ AI Hub  
**Cluster:** AI Hub / Internal App Hub  
**Phase:** Platform / Internal Hub  
**Owner:** AI / Automation Team

### Mô tả dự án

`PPJ.AI.Hub.v2.1` là hub trung tâm để gom các AI tools, chatbot, automation apps và internal utilities mà người dùng nội bộ có thể truy cập. Dự án này không phải là nơi gộp toàn bộ project note, mà là lớp “application hub” hoặc “tool center” giúp user tìm và mở đúng công cụ cần dùng.

Hub có thể đóng vai trò như một landing page cho các hệ thống như PERRI, Invoice Downloader, Sourcing Chatbot, FD Hanger, portal tools hoặc các assistant theo phòng ban.

### Mục tiêu

- Tạo điểm truy cập tập trung cho AI / Automation tools.
    
- Giúp user không phải nhớ nhiều link/tool riêng lẻ.
    
- Phân loại tool theo phòng ban hoặc nhóm nghiệp vụ.
    
- Tăng adoption cho các automation đã production.
    
- Làm nền cho việc quản lý quyền truy cập theo user/department.
    

### Output mong muốn

- Giao diện hub nội bộ.
    
- Danh sách tools/apps theo phòng ban.
    
- Link truy cập nhanh.
    
- Mô tả ngắn từng tool.
    
- Có thể tích hợp phân quyền với PERRI hoặc portal.
    

### Lưu ý scope

Không dùng `PPJ.AI.Hub.v2.1` để merge toàn bộ project documentation. Đây là hub truy cập tool, không phải registry nghiệp vụ duy nhất.

---

## 2.2 `PPJ.PERRI.Chatbot.v3.2`

**Alias:** PERRI Chatbot, PPJ PERRI, General Assistant  
**Cluster:** AI Orchestrator / Internal Chatbot  
**Phase:** Production / Permission Enhancement  
**Owner kỹ thuật:** Nam  
**Business coverage:** Multi-department

### Mô tả dự án

`PPJ.PERRI.Chatbot.v3.2` là chatbot/orchestrator nội bộ của PPJ, đóng vai trò lớp giao tiếp giữa người dùng và knowledge base, API, automation tools, agent theo phòng ban và workflow nội bộ.

PERRI không chỉ là chatbot hỏi đáp. Hướng phát triển mới là trở thành **AI Orchestrator**, có thể quản lý nhiều agent chuyên biệt như MER Agent, Sourcing Agent, Technical Agent, Accounting Agent, Purchasing Agent hoặc HR Agent.

### Mục tiêu

- Cung cấp chatbot nội bộ cho nhiều phòng ban.
    
- Cho phép user truy vấn knowledge base, tài liệu, dữ liệu hoặc API.
    
- Làm nền cho agent-enabled automation.
    
- Quản lý quyền truy cập theo phòng ban.
    
- Hỗ trợ gọi tool/API nội bộ một cách có kiểm soát.
    

### Cập nhật quan trọng

PERRI đã cập nhật phân quyền agent theo phòng ban. User hiện có thể được grant access tới đúng agent thuộc department của mình, thay vì chỉ dựa trên quyền admin hoặc quyền tổng quát.

### Output mong muốn

- Chatbot nội bộ production.
    
- Agent theo department.
    
- Permission model theo phòng ban.
    
- Logging/audit cho agent có khả năng gọi API hoặc trigger workflow.
    
- Kết nối với Invoice Downloader, Sourcing Chatbot, Costing Platform và các tool khác.
    

### Risk / Dependency

- Cần kiểm tra kỹ phân quyền theo department.
    
- Cần audit log khi agent gọi API.
    
- Cần tránh user truy cập sai dữ liệu phòng ban khác.
    
- Cần phân biệt agent chỉ hỏi đáp và agent có quyền action.
    

---

## 2.3 `PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0`

**Alias:** GLPI Helpdesk, Helpdesk AI  
**Cluster:** IT / ERP Helpdesk AI  
**Phase:** Maintenance and Support  
**Owner kỹ thuật:** Huy

### Mô tả dự án

`PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0` là chatbot hỗ trợ Helpdesk, đặc biệt cho các vấn đề liên quan đến ERP, IT support, GLPI ticket hoặc knowledge base nội bộ. Dự án giúp user tìm câu trả lời nhanh hơn trước khi tạo ticket hoặc trong quá trình xử lý ticket.

### Mục tiêu

- Hỗ trợ người dùng tra cứu hướng dẫn IT/ERP.
    
- Giảm tải câu hỏi lặp lại cho helpdesk.
    
- Chuẩn hóa knowledge base cho GLPI.
    
- Tăng tốc xử lý ticket.
    
- Hỗ trợ phân loại vấn đề hoặc gợi ý hướng xử lý ban đầu.
    

### Output mong muốn

- Chatbot hỗ trợ helpdesk.
    
- Knowledge base cho các lỗi/thắc mắc thường gặp.
    
- Gợi ý troubleshooting.
    
- Có thể tích hợp với GLPI ticket flow trong tương lai.
    

### Risk / Dependency

- Knowledge base cần được cập nhật liên tục.
    
- Cần phân biệt câu hỏi có thể tự trả lời và case cần tạo ticket.
    
- Cần kiểm soát độ chính xác khi hướng dẫn thao tác hệ thống.
    

---

## 2.4 `SCP.SOURCING.CHATBOT.v2.3`

**Alias:** SCP.Sourcing-Chatbot.ver2, Sourcing Chatbot, Sourcing Data Repository, External Sample Repository  
**Cluster:** Sourcing AI / Data Platform  
**Phase:** Development / Data Strategy Discussion  
**Members:** Huy, Khoa, Linh, Nghĩa  
**Progress:** khoảng 80%

### Mô tả dự án

`SCP.SOURCING.CHATBOT.v2.3` là project consolidated cho Sourcing, bao gồm cả **data platform** và **chatbot tra cứu**. Dự án phục vụ việc lưu trữ, chuẩn hóa và tra cứu dữ liệu liên quan đến nhà cung cấp, nguyên vật liệu, fabric, trims, external samples và các thông tin sourcing khác.

Dự án này không được tách thành nhiều project nhỏ như “Sourcing Repository”, “External Sample Management” hoặc “Sourcing Chatbot” nếu chưa có approval. Tất cả nằm dưới một code name duy nhất: `SCP.SOURCING.CHATBOT.v2.3`.

### Mục tiêu

- Xây dựng kho dữ liệu sourcing tập trung.
    
- Quản lý external samples.
    
- Chuẩn hóa dữ liệu supplier, fabric, trims, material.
    
- Cho phép Sourcing tra cứu dữ liệu qua chatbot.
    
- Hỗ trợ so sánh supplier hoặc material.
    
- Tạo nền cho AI-assisted sourcing hoặc recommendation trong tương lai.
    

### Scope chính

- Supplier data.
    
- Fabric data.
    
- Trims data.
    
- External sample data.
    
- Metadata cho mẫu.
    
- File/document storage nếu dữ liệu không structured.
    
- Chatbot tra cứu theo supplier, fabric, trims, color, size, material, sample code, metadata.
    

### Cập nhật gần nhất

Team tiếp tục trao đổi với anh Linh và anh Roberto về POC, external samples và hướng xử lý khi volume dữ liệu bên ngoài quá lớn. Trọng tâm hiện tại là **data strategy trước khi import lớn**.

### Output mong muốn

- Sourcing repository.
    
- Chatbot search.
    
- Metadata structure.
    
- Search result có nguồn dữ liệu rõ.
    
- Có thể mở rộng thành recommendation engine.
    

### Risk / Dependency

- External data có thể rất lớn.
    
- Chưa rõ metadata tối thiểu.
    
- Cần data owner.
    
- Cần naming convention.
    
- Nếu import dữ liệu quá sớm khi chưa chuẩn hóa, hệ thống sẽ khó tìm kiếm và khó scale.
    

---

## 2.5 `COSTING.AGENTIC.PLATFORM.v1.1`

**Alias:** Costing Intelligence, MER Costing, Merchandise Costing, Merchandising Intelligence, Costing Chatbot, PPJ.COSTING.AGENT.PLATFORM  
**Cluster:** Costing Agentic Platform  
**Phase:** Analysis / Strategic Platform  
**Members:** Lâm, Khoa, Uyên  
**Business output owner:** MER  
**Technical stakeholders:** BOM, Sew, Wash, Cut, Costing, Technical Department, BDE

### Mô tả dự án

`COSTING.AGENTIC.PLATFORM.v1.1` là một trong các dự án chiến lược mới nhất của portfolio. Đây không phải chatbot đơn lẻ. Đây là **agentic platform cho nhiều phòng kỹ thuật cùng tham gia tính costing theo từng công đoạn**.

Trong thực tế, khách hàng có thể xuống hàng và chọn hơn 100 mẫu để yêu cầu báo giá. Input từ khách hàng có thể là sketch, techpack, hình ảnh mẫu, buyer reference, mô tả sản phẩm, yêu cầu fabric, yêu cầu wash, construction hoặc fitting. Nếu MER phải hỏi từng phòng kỹ thuật thủ công cho từng mẫu, thời gian phản hồi sẽ rất dài và khó kiểm soát.

Nền tảng này sẽ phân rã customer request, route từng phần đến các agent/module kỹ thuật như BOM, Sew, Wash, Cut, Technical Knowledge và Historical Costing. Sau đó hệ thống tổng hợp kết quả thành **costing / quotation package** để MER review, điều chỉnh margin hoặc assumption nếu cần và gửi báo giá lại cho khách hàng.

### Mục tiêu

- Rút ngắn thời gian từ customer request đến quotation.
    
- Hỗ trợ báo giá hàng loạt nhiều mẫu.
    
- Tính costing theo từng công đoạn kỹ thuật.
    
- Tận dụng dữ liệu lịch sử và kinh nghiệm thực tế của các phòng kỹ thuật.
    
- Giảm số lần MER phải hỏi lại từng phòng ban.
    
- Chuẩn hóa output báo giá/costing.
    
- Tạo nền tảng agentic cho technical costing.
    

### Agent / Module dự kiến

|Agent / Module|Vai trò|
|---|---|
|BOM Agent|Ước tính BOM, fabric, trims, consumption, substitute material|
|Sew Technical Agent|Ước tính công đoạn may, định mức may, thời gian may, nhân công, SMV nếu có|
|Wash Technical Agent|Ước tính wash type, wash process, thời gian wash, chi phí wash|
|Cut Technical Agent|Ước tính cutting process, marker, fabric usage, cutting loss, cutting time|
|Technical Knowledge Agent|Truy xuất pattern, construction, fitting, buyer reference, techpack, tài liệu kỹ thuật|
|Historical Costing Agent|Tìm sản phẩm tương tự, costing cũ, quote history, actual cost nếu có|
|Quotation Consolidation Agent|Tổng hợp cost breakdown, assumption, confidence, warning, missing data|

### Output mong muốn

- Cost breakdown theo công đoạn.
    
- BOM/material estimate.
    
- Sewing cost estimate.
    
- Wash cost estimate.
    
- Cutting cost estimate.
    
- Historical reference.
    
- Missing data.
    
- Warning/risk.
    
- Confidence level.
    
- Suggested questions cần hỏi lại khách hàng.
    
- Batch quotation dashboard/file cho nhiều mẫu.
    

### Risk / Dependency

- Dữ liệu costing theo công đoạn đang phân tán.
    
- Kinh nghiệm thực tế chưa được chuẩn hóa thành rule/data.
    
- Cần source of truth cho BOM, Sew, Wash, Cut, Costing History.
    
- Cần sample request thực tế để thiết kế batch workflow.
    
- Cần human review trước khi MER gửi báo giá.
    

---

## 2.6 `TD.TechnicalKnowledge.Platform.v2.1`

**Alias:** TECH.KNOWLEDGE.PLATFORM.v2.1, TD.TechnicalPlatform_v2.1, Technical Platform, Anh Tứ platform  
**Cluster:** Technical Knowledge / Training  
**Phase:** New Request / Analysis  
**Members:** Huy, Khoa  
**Stakeholder chính:** Anh Tứ, Technical Department

### Mô tả dự án

`TD.TechnicalKnowledge.Platform.v2.1` là dự án nâng cấp nền tảng tri thức kỹ thuật của Technical Department. Mục tiêu là tạo một nơi có thể liên kết và tra cứu các dữ liệu kỹ thuật sản phẩm như buyer reference, pattern, BOM, costing cũ, hướng dẫn may đo, video hướng dẫn, tài liệu kỹ thuật và training material.

Dự án này có liên hệ chặt với `COSTING.AGENTIC.PLATFORM.v1.1`, vì Technical Knowledge Platform có thể trở thành một data node quan trọng để các technical agents truy xuất pattern, construction, fitting, BOM hoặc tài liệu kỹ thuật.

### Mục tiêu

- Tập trung hóa dữ liệu kỹ thuật.
    
- Cho phép search theo mã hàng, buyer reference, pattern, BOM, construction.
    
- Chuẩn hóa tài liệu kỹ thuật và video hướng dẫn.
    
- Tạo nền cho training platform.
    
- Hỗ trợ các agent costing truy vấn dữ liệu kỹ thuật.
    

### Scope chính

- Buyer reference.
    
- Pattern.
    
- BOM.
    
- Costing cũ.
    
- Tài liệu kỹ thuật.
    
- Video hướng dẫn.
    
- Quy trình may đo.
    
- Training material.
    
- Sync dữ liệu về Directus nếu phù hợp.
    

### Output mong muốn

- Technical knowledge database.
    
- Search flow cho technical data.
    
- Data structure rõ.
    
- Quyền truy cập theo user/department.
    
- Roadmap nâng cấp thành training platform.
    

### Risk / Dependency

- Dữ liệu kỹ thuật có thể phân tán.
    
- Naming convention chưa rõ.
    
- Cần phân biệt dữ liệu vận hành và dữ liệu training.
    
- Dữ liệu technical có thể nhạy cảm nên cần phân quyền.
    

---

# 3. Data / Portal / Datamart

---

## 3.1 `FD.Datamart.v2.2`

**Alias:** FD Hanger.ver2, FD.QR.HANGER.v2.3, QR Hanger, FD Fabric Datamart  
**Cluster:** FD / Fabric Datamart / QR Hanger  
**Phase:** Stabilize / Onboarding  
**Members:** Nghĩa, Nam, Khoa

### Mô tả dự án

`FD.Datamart.v2.2` là nền tảng dữ liệu cho FD liên quan đến mẫu vải, hanger, QR information và format hanger tag. Dự án này bao gồm Directus backend/admin, dữ liệu fabric sample, QR design, QR gắn trên hanger và QR Format Designer.

Dự án này phải tách biệt hoàn toàn với `CPD.Datamart.v1.1`. FD tập trung vào fabric sample/hanger/QR, còn CPD tập trung vào 3D Design, image search và visual sample assets.

### Mục tiêu

- Xây dựng kho dữ liệu mẫu vải FD.
    
- Chuẩn hóa thông tin fabric sample.
    
- Tạo QR information gắn với hanger.
    
- Cho phép thiết kế format hanger tag.
    
- Hỗ trợ in tem/hanger tag.
    
- Tăng khả năng tra cứu mẫu vải bằng QR.
    

### Cập nhật gần nhất

QR Format Designer đã hoàn thiện. Team đã tổ chức training session 3 và đang gather feedback cho next version.

### Output mong muốn

- FD fabric datamart.
    
- QR hanger tag.
    
- QR format designer.
    
- Template hanger tag.
    
- User training và onboarding.
    
- Feedback loop cho next version.
    

### Risk / Dependency

- Cần ổn định layout/format.
    
- Cần tối ưu tốc độ tạo/in tem.
    
- Cần đảm bảo QR link đúng dữ liệu.
    
- Cần user adoption sau training.
    

---

## 3.2 `CPD.Datamart.v1.1`

**Alias:** CPD.DataMart, CPD / 3D Design Datamart  
**Cluster:** CPD / 3D Sample Library  
**Phase:** Development / Data Foundation  
**Members:** Linh, Phát  
**Progress:** khoảng 70%

### Mô tả dự án

`CPD.Datamart.v1.1` là kho dữ liệu phục vụ CPD và 3D Design, tập trung vào image search, 3D sample library và visual sample assets. Dự án nhằm tạo nền dữ liệu để CPD có thể quản lý, tìm kiếm và tái sử dụng dữ liệu mẫu thiết kế, hình ảnh, 3D sample hoặc assets liên quan.

### Mục tiêu

- Xây dựng datamart cho CPD.
    
- Quản lý dữ liệu 3D sample.
    
- Hỗ trợ image search.
    
- Lưu trữ visual sample assets.
    
- Tạo nền cho AI search hoặc recommendation sau này.
    

### Scope chính

- 3D design sample.
    
- Image assets.
    
- Visual library.
    
- Metadata cho mẫu.
    
- Search theo hình ảnh hoặc thuộc tính.
    
- Data structure cho CPD.
    

### Output mong muốn

- CPD datamart.
    
- 3D sample library.
    
- Image search capability.
    
- Metadata chuẩn cho visual assets.
    
- Data foundation cho AI trong CPD.
    

### Risk / Dependency

- Cần chuẩn hóa metadata hình ảnh.
    
- Cần phân biệt rõ CPD data và FD fabric data.
    
- Cần chất lượng ảnh/mẫu tốt.
    
- Cần xác định user flow tìm kiếm của CPD.
    

---

## 3.3 `WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1`

**Alias:** RND.WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1, R&D Wash Sampling Portal  
**Cluster:** Wash R&D Portal  
**Phase:** New Booking / Analysis  
**Owner:** R&D Wash  
**Member:** Nam

### Mô tả dự án

`WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1` là dự án port ứng dụng/quy trình quản lý sampling của R&D Wash lên PPJ Group Portal. Mục tiêu là giúp R&D Wash và các phòng ban liên quan quản lý, theo dõi và truy cập dữ liệu sample tập trung hơn.

Dự án không chỉ là port giao diện. Đây là bước chuẩn hóa dữ liệu sampling, workflow, user access và trạng thái xử lý mẫu wash.

### Mục tiêu

- Đưa sampling management lên PPJ Group Portal.
    
- Chuẩn hóa dữ liệu sample wash.
    
- Cho phép nhiều phòng ban cùng theo dõi trạng thái sampling.
    
- Quản lý attachment, hình ảnh, result, comment.
    
- Tạo nền cho dashboard/search sampling.
    

### Scope chính

- Sample code.
    
- Style/item.
    
- Customer.
    
- Wash type.
    
- Status.
    
- Request date.
    
- Responsible person.
    
- Result/comment.
    
- Image/attachment.
    
- Approval nếu có.
    
- User role: R&D Wash, MER, Technical, Production, QA/QC.
    

### Output mong muốn

- Portal flow quản lý sampling.
    
- Data model cho wash sample.
    
- Permission model.
    
- UAT plan với R&D Wash.
    
- Danh sách màn hình/chức năng cần port.
    

### Risk / Dependency

- Cần khảo sát app/process hiện tại.
    
- Cần xác định data owner.
    
- Cần làm rõ phân quyền nếu nhiều phòng ban cùng dùng.
    
- Cần tránh chỉ port UI mà không chuẩn hóa data.
    

---

## 3.4 `MER.MARKET.INTELLIGENCE.v1.1`

**Alias:** Market Intelligence, E-commerce Market Intelligence, Ecommerce Opportunities Exploration  
**Cluster:** Market / Product Intelligence  
**Phase:** Analysis  
**Members:** Phát, Nghĩa, Khoa

### Mô tả dự án

`MER.MARKET.INTELLIGENCE.v1.1` là dự án phân tích dữ liệu thị trường và sản phẩm để hỗ trợ MER/Business tìm cơ hội sản phẩm, fitting, màu sắc, chất liệu và nhóm vải có tiềm năng. Dự án có hướng mới là kết hợp dữ liệu nội bộ như sales history, PO, tồn kho vải với dữ liệu bên ngoài như Quince consumer data.

### Mục tiêu

- Phân tích sản phẩm có tiềm năng thương mại.
    
- Kết nối dữ liệu thị trường với dữ liệu nội bộ.
    
- Tìm sản phẩm/vải có thể reboost.
    
- Hỗ trợ product showcase hoặc B2C proposal.
    
- Tạo insight cho MER và business development.
    

### Scope chính

- Sales history.
    
- Customer/PO data.
    
- Fabric inventory.
    
- Quince consumer data.
    
- Price point.
    
- Review/rating.
    
- Color trend.
    
- Fit trend.
    
- Material trend.
    

### Output mong muốn

- Market insight report.
    
- Product opportunity list.
    
- Fabric/product reboost suggestion.
    
- Product showcase input.
    
- Dashboard hoặc analysis workbook.
    

### Risk / Dependency

- Cần dữ liệu sales/PO/inventory đủ sạch.
    
- Cần định nghĩa rõ market signal nào được dùng.
    
- Cần tránh phân tích thị trường mà không gắn với khả năng sản xuất/tồn kho thực tế.
    

---

## 3.5 `PUR.Inventory.Report.v1.0`

**Alias:** Purchasing Inventory Report, Inventory Report  
**Cluster:** Purchasing Report  
**Phase:** Maintenance and Support  
**Member:** Nam

### Mô tả dự án

`PUR.Inventory.Report.v1.0` là báo cáo tồn kho phục vụ Purchasing. Dự án giúp user theo dõi số liệu inventory, hỗ trợ quyết định purchasing, kiểm soát tồn và tra cứu thông tin liên quan đến nguyên phụ liệu.

### Mục tiêu

- Tạo báo cáo tồn kho phục vụ Purchasing.
    
- Giảm thao tác tổng hợp thủ công.
    
- Chuẩn hóa output report.
    
- Hỗ trợ tra cứu nhanh tồn kho.
    

### Output mong muốn

- Report tồn kho.
    
- Data refresh ổn định.
    
- Format dễ đọc cho user.
    
- Maintenance/support khi có lỗi dữ liệu.
    

### Risk / Dependency

- Cần source data ổn định.
    
- Cần xử lý lệch dữ liệu nếu hệ thống nguồn thay đổi.
    
- Cần validate với user Purchasing.
    

---

# 4. Invoice / Accounting / EXIM / Audit Automation

---

## 4.1 `PPJ.InvoiceDownloader.v1.2`

**Alias:** SYS.INVOICES.DOWNLOAD&MERGING, SYS.INVOICES.DOWNLOAD.v1.2, Invoice Downloader  
**Cluster:** Invoice API / Download Automation  
**Phase:** Production / API Enhancement  
**Members:** Khoa, Nam

### Mô tả dự án

`PPJ.InvoiceDownloader.v1.2` là tool/API hỗ trợ tự động tải và gộp hóa đơn điện tử từ các portal hóa đơn. Dự án đã tiến thêm một bước quan trọng: có API và có thể download hóa đơn thông qua GPT/PERRI.

Đây là ví dụ rõ của việc chuyển từ tool automation riêng lẻ sang **agent-enabled automation**, nơi user có thể thao tác tự nhiên thông qua chatbot/agent nhưng hệ thống vẫn gọi API phía sau.

### Mục tiêu

- Tự động tải hóa đơn điện tử.
    
- Gộp hoặc chuẩn hóa file output.
    
- Giảm thao tác thủ công cho Accounting/Purchasing.
    
- Cho phép gọi qua GPT/PERRI.
    
- Tạo nền cho kiểm tra, đối chiếu và lưu trữ invoice.
    

### Output mong muốn

- API download hóa đơn.
    
- Output file chuẩn.
    
- Logging khi user gọi API.
    
- Permission theo user/department.
    
- Retry/fallback khi portal lỗi.
    
- Kiểm soát duplicate/missing invoice.
    

### Risk / Dependency

- Credential/session.
    
- Permission.
    
- Logging/audit.
    
- Portal thay đổi UI/API.
    
- Duplicate hoặc missing invoice.
    
- Sai metadata.
    

---

## 4.2 `PPJ.ExpenseInvoices.v1.1`

**Alias:** ACC.EXPENSE.INVOICES.v1.2, Accounting Expense Invoices, PPJ Expense-Invoices  
**Cluster:** Expense Invoice Platform  
**Phase:** Analysis / Design  
**Owner:** Accounting / related departments

### Mô tả dự án

`PPJ.ExpenseInvoices.v1.1` là nền tảng/workflow xử lý hóa đơn chi phí, hiện đang ở giai đoạn mapping dữ liệu và chờ Factory 0 / department mapping ledger. Dự án nhằm chuẩn hóa dữ liệu hóa đơn chi phí và chuẩn bị cho automation nhập liệu/kiểm tra trong hệ thống.

### Mục tiêu

- Chuẩn hóa quy trình expense invoices.
    
- Mapping dữ liệu hóa đơn chi phí.
    
- Xác định ledger/account mapping.
    
- Tạo nền cho automation kế toán.
    
- Chuẩn bị bước tiếp theo cho Imported GRN và reconciliation.
    

### Output mong muốn

- Data mapping document.
    
- Ledger mapping.
    
- Field-level validation.
    
- Workflow xử lý expense invoice.
    
- UAT sau khi mapping hoàn tất.
    

### Risk / Dependency

- Ledger mapping chưa hoàn tất.
    
- Cần Factory 0 / department xác nhận.
    
- Cần source of truth cho field kế toán.
    
- Không nên build workflow khi mapping chưa rõ.
    

---

## 4.3 `MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1`

**Alias:** MER.CHICOS.COSTING-INVOICE.RECHECK-AUDIT.v1.1, Chico’s Costing & Invoice Recheck Audit  
**Cluster:** MER Invoice / Costing Audit  
**Phase:** Stabilize  
**Members:** Hiền, Khoa  
**Business owner:** MER

### Mô tả dự án

`MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1` là use case phục vụ MER trong việc kiểm tra costing, chi phí và invoice audit cho khách hàng Chico’s. Dự án này không phải Accounting project mặc định. Trọng tâm là giúp MER rà soát chứng từ/costing, phát hiện mismatch, thiếu thông tin, sai lệch hoặc các case cần review.

Dự án có thể xem là pilot cho nhóm checking / rechecking / audit automation.

### Mục tiêu

- Hỗ trợ MER kiểm tra costing và invoice cho Chico’s.
    
- Chuẩn hóa checklist audit.
    
- Giảm kiểm tra thủ công.
    
- Phát hiện mismatch/missing data.
    
- Tạo output report để MER review.
    

### Output mong muốn

- Rule pass/fail/warning.
    
- Checklist kiểm tra.
    
- Output audit report.
    
- Danh sách mismatch.
    
- Confidence/recommended action.
    
- Source of truth cho từng field đối chiếu.
    

### Risk / Dependency

- Cần sample invoice/costing thực tế.
    
- Cần checklist từ MER.
    
- Cần xác định source of truth.
    
- Cần human review trước khi dùng output chính thức.
    

---

## 4.4 `ACC.GRN-SupplierInvoiceBot.v2.3`

**Alias:** Accounting.GRN - Supplier Invoices Automation, ACC.GRN-SupplierInvoiceBot.v1.1  
**Cluster:** Accounting ERP Bot  
**Phase:** Maintenance and Support  
**Members:** Hiền, Khoa

### Mô tả dự án

`ACC.GRN-SupplierInvoiceBot.v2.3` là bot tự động hóa quy trình tạo GRN và supplier invoice cho Accounting. Dự án hỗ trợ giảm thao tác nhập liệu thủ công, xử lý chứng từ nhà cung cấp và tăng tốc quá trình ghi nhận hóa đơn liên quan GRN.

Có lệch version giữa registry/rule cũ và file thực tế: rule cũ ghi `v1.1`, nhưng file thực tế đang là `v2.3`. Khi discuss hiện tại, dùng `ACC.GRN-SupplierInvoiceBot.v2.3`.

### Mục tiêu

- Tự động hóa tạo GRN.
    
- Tự động hóa tạo supplier invoice.
    
- Giảm manual entry.
    
- Chuẩn hóa input/output.
    
- Support user Accounting.
    

### Output mong muốn

- Bot production ổn định.
    
- Exception handling.
    
- Log thao tác.
    
- User support.
    
- Fix bug nhỏ khi phát sinh.
    

### Risk / Dependency

- Dữ liệu invoice/GRN phải đúng format.
    
- Cần xử lý exception.
    
- Cần audit khi bot tạo chứng từ.
    
- Cần thống nhất version naming.
    

---

## 4.5 `EXIM.ExpenseInvoices.Automation.v1.1`

**Alias:** EXIM.EXPENSE-INVOICES.Automation  
**Cluster:** EXIM ERP Automation  
**Phase:** Onboarding  
**Members:** Hiền, Khoa

### Mô tả dự án

`EXIM.ExpenseInvoices.Automation.v1.1` là automation nhập liệu hóa đơn chi phí xuất nhập khẩu vào WFX. Dự án phục vụ nhóm EXIM, giảm thao tác nhập liệu thủ công và chuẩn hóa dữ liệu hóa đơn chi phí liên quan xuất nhập khẩu.

### Mục tiêu

- Tự động hóa nhập liệu hóa đơn chi phí EXIM.
    
- Giảm manual effort.
    
- Chuẩn hóa mapping dữ liệu.
    
- Hỗ trợ onboarding user.
    
- Tăng tính ổn định khi vận hành.
    

### Output mong muốn

- Automation flow cho EXIM expense invoices.
    
- Mapping input/output.
    
- User onboarding.
    
- Exception handling.
    
- Support khi có lỗi.
    

### Risk / Dependency

- Dữ liệu đầu vào cần chuẩn.
    
- Cần xử lý case ngoại lệ.
    
- Cần kiểm tra logic WFX.
    
- Cần UAT với EXIM.
    

---

# 5. Purchasing / MER Workflow

---

## 5.1 `PUR.Material.Allocation.v1.1`

**Alias:** PUR.MATERIAL-ALLOCATION.AUTOMATION, PUR.MATERIAL.ALLOCATION.v1.1  
**Cluster:** Purchasing Workflow  
**Phase:** Analysis / Early Development  
**Members:** Uyên, Khoa  
**Progress:** khoảng 10%

### Mô tả dự án

`PUR.Material.Allocation.v1.1` là dự án automation/bán automation cho nghiệp vụ phân bổ, điều chuyển hoặc mượn nguyên phụ liệu giữa OC, mã hàng hoặc đơn hàng trên WFX. Dự án cần validation và user review trước khi lưu hoặc post transaction.

### Mục tiêu

- Hỗ trợ material allocation.
    
- Hỗ trợ điều chuyển/mượn NPL.
    
- Giảm thao tác thủ công trên WFX.
    
- Có validation trước khi lưu/post.
    
- Có user review để giảm rủi ro sai giao dịch.
    

### Cập nhật gần nhất

Team tiếp tục xin dữ liệu test từ Precision team và làm việc với chị Tuyết. Business users đang bận nên dữ liệu test chưa đầy đủ.

### Output mong muốn

- Workflow test được với dữ liệu thực tế.
    
- Checklist case nghiệp vụ.
    
- Validation rule.
    
- User review flow.
    
- Làm rõ WFX Save/edit draft nếu cần.
    

### Risk / Dependency

- Thiếu dữ liệu test thực tế.
    
- Business users bận.
    
- Phụ thuộc WFX.
    
- Cần rule nghiệp vụ rõ trước production.
    

---

## 5.2 `PUR.GDI.Automation.v1.0`

**Alias:** PUR.GDI.AUTOMATION  
**Cluster:** Purchasing Workflow  
**Phase:** On Hold  
**Members:** Hiền, Khoa

### Mô tả dự án

`PUR.GDI.Automation.v1.0` là dự án tự động hóa tạo GDI trong Purchasing. GDI là Goods Delivery Instruction, phục vụ quy trình hướng dẫn giao hàng hoặc điều phối giao nhận trong nghiệp vụ Purchasing.

### Mục tiêu

- Tự động hóa tạo GDI.
    
- Giảm manual entry.
    
- Chuẩn hóa input.
    
- Giảm lỗi khi tạo chứng từ.
    
- Hỗ trợ Purchasing vận hành nhanh hơn.
    

### Trạng thái hiện tại

Dự án đang on hold do phụ thuộc WFX modification hoặc điều kiện hệ thống nguồn chưa sẵn sàng.

### Risk / Dependency

- WFX dependency.
    
- Cần modification hoặc hỗ trợ từ hệ thống.
    
- Chưa nên tiêu tốn effort lớn khi blocker chưa được unblock.
    

---

## 5.3 `PUR.Adhoc.Indent.South.v1.0`

**Alias:** Adhoc Indent miền Nam  
**Cluster:** Purchasing Workflow  
**Phase:** Maintenance and Support  
**Member:** Hiền

### Mô tả dự án

`PUR.Adhoc.Indent.South.v1.0` là automation phục vụ nghiệp vụ Adhoc Indent khu vực miền Nam. Dự án đã ở trạng thái production/support, giúp user xử lý nghiệp vụ indent nhanh và ổn định hơn.

### Mục tiêu

- Tự động hóa adhoc indent.
    
- Giảm thao tác thủ công.
    
- Hỗ trợ user khu vực miền Nam.
    
- Duy trì ổn định production.
    

### Output mong muốn

- Automation vận hành ổn định.
    
- Support user khi có issue.
    
- Fix bug nhỏ nếu phát sinh.
    
- Theo dõi exception.
    

---

## 5.4 `PUR.HM.LabelO.Processing.Automation.v1.0`

**Alias:** PUR.H&M.LABEL-O.PROCESSING.AUTOMATION, H&M Label-O  
**Cluster:** Purchasing / Customer-specific Automation  
**Phase:** On Hold / Delayed  
**Members:** Khoa, Nam

### Mô tả dự án

`PUR.HM.LabelO.Processing.Automation.v1.0` là automation xử lý Label-O cho H&M. Đây là project customer-specific, phục vụ một quy trình tương đối đặc thù theo yêu cầu của khách hàng.

### Mục tiêu

- Tự động hóa xử lý Label-O.
    
- Giảm thao tác thủ công.
    
- Chuẩn hóa output theo yêu cầu H&M.
    
- Hỗ trợ Purchasing hoặc team liên quan xử lý nhanh hơn.
    

### Trạng thái hiện tại

Dự án đang on hold/delayed vì scope customer-specific và chưa đủ điều kiện scale hoặc chưa có priority cao.

### Risk / Dependency

- Customer-specific logic dễ hard-code.
    
- Khó scale nếu chỉ phục vụ một format.
    
- Cần business impact rõ trước khi tiếp tục.
    

---

## 5.5 `MER.PO.Commit.v1.1`

**Alias:** MER.PO Commit, MER.PO-Commit  
**Cluster:** MER Workflow  
**Phase:** Closed / Production Support  
**Members:** Lâm, Uyên

### Mô tả dự án

`MER.PO.Commit.v1.1` là automation tạo file template để tạo OC, file NPL và Packing List từ PO của khách hàng. Dự án hỗ trợ MER xử lý PO nhanh hơn và giảm thao tác chuẩn bị file thủ công.

### Mục tiêu

- Tự động hóa xử lý PO customer.
    
- Tạo OC template.
    
- Tạo NPL file.
    
- Tạo Packing List.
    
- Giảm thời gian xử lý PO.
    

### Cập nhật

Dự án được ghi nhận ở trạng thái Closed, nhưng vẫn có thể có production support hoặc enhancement nhỏ theo customer logic, ví dụ Canadian Tire.

### Risk / Dependency

- Mỗi customer có format riêng.
    
- Nếu không chuẩn hóa rule, dễ hard-code.
    
- Cần maintain khi format PO thay đổi.
    

---

# 6. Production / Factory / IoT / Wash

---

## 6.1 `PROD.IOT.CHuyenTreo.v1.0`

**Alias:** Chuyền treo ver1, PROD.IOT.CHuyenTreo_1  
**Cluster:** Production IoT / Dashboard  
**Phase:** Development  
**Member:** Linh  
**Progress:** khoảng 50%

### Mô tả dự án

`PROD.IOT.CHuyenTreo.v1.0` là dự án kéo dữ liệu từ các chuyền treo để dựng dashboard realtime và report sản xuất. Dự án hướng tới tăng visibility cho sản xuất thông qua dữ liệu realtime về output, efficiency, downtime hoặc trạng thái vận hành.

### Mục tiêu

- Kéo dữ liệu chuyền treo.
    
- Xây dashboard realtime.
    
- Hỗ trợ report sản xuất.
    
- Theo dõi efficiency/output/downtime.
    
- Tạo nền cho production analytics.
    

### Output mong muốn

- Dashboard realtime.
    
- Data pipeline ổn định.
    
- Report sản xuất.
    
- KPI theo chuyền/line.
    
- Theo dõi downtime hoặc output.
    

### Risk / Dependency

- Phụ thuộc dữ liệu từ IDS/WISER/INA hoặc hệ thống sản xuất liên quan.
    
- Cần chuẩn hóa KPI.
    
- Cần đảm bảo data refresh ổn định.
    
- Cần validate số liệu với production.
    

---

## 6.2 `PROD.COWASH.v2.0`

**Alias:** COWASH ver2, PROD.COWASH  
**Cluster:** Production / Wash Dashboard  
**Phase:** On Hold / Re-scope  
**Member:** Linh

### Mô tả dự án

`PROD.COWASH.v2.0` là dự án kéo dữ liệu từ phần mềm Cowash để làm dashboard realtime và report cho quy trình wash. Dự án hiện đang on hold hoặc cần re-scope do cần xác nhận lại technical approach và nguồn dữ liệu.

### Mục tiêu

- Kéo dữ liệu từ Cowash.
    
- Dựng dashboard/report wash.
    
- Theo dõi trạng thái, output hoặc efficiency của wash.
    
- Hỗ trợ quản lý vận hành wash bằng dữ liệu.
    

### Trạng thái hiện tại

On hold/re-scope. Chưa nên đẩy tiếp nếu chưa rõ data source, API/access, logic KPI và ownership.

### Risk / Dependency

- Cần xác nhận cách lấy dữ liệu từ Cowash.
    
- Cần data owner.
    
- Cần xác định dashboard/report requirement.
    
- Có thể overlap với Wash Sampling hoặc R&D Wash nếu scope không rõ.
    

---

# 7. HR / Internal Process

---

## 7.1 `HR.SSPFD.Workflow.v1.1`

**Alias:** HR.SS&PFD.v1.1, HR SS&PFD, BHXH WISER data  
**Cluster:** HR / Internal Process  
**Phase:** Analysis / Data Confirmation

### Mô tả dự án

`HR.SSPFD.Workflow.v1.1` là dự án/workflow liên quan HR, trong đó cập nhật mới nhất là đã confirm nhà máy WISER và cần lấy dữ liệu 3 tháng gần nhất phục vụ nghiệp vụ BHXH.

### Mục tiêu

- Hỗ trợ HR xử lý dữ liệu liên quan BHXH.
    
- Lấy dữ liệu từ WISER.
    
- Xác định dữ liệu 3 tháng gần nhất.
    
- Chuẩn hóa output cho HR.
    
- Kiểm tra/mapping dữ liệu nếu cần.
    

### Output mong muốn

- Dataset 3 tháng gần nhất từ WISER.
    
- Data fields phục vụ BHXH.
    
- Format output cho HR.
    
- Rule kiểm tra/mapping nếu có.
    
- Xác nhận source of truth.
    

### Risk / Dependency

- Cần rõ field nào lấy từ WISER.
    
- Cần đảm bảo dữ liệu đủ 3 tháng.
    
- Cần xác nhận format HR cần dùng.
    
- Dữ liệu HR có tính nhạy cảm nên cần phân quyền.
    

---

# 8. External / Vendor / Exploration

---

## 8.1 `PPJxQSee.AI`

**Alias:** QSEE.AI, PPJ x QSee.ai  
**Cluster:** External Collaboration  
**Phase:** NDA approved / Use case discussion  
**Stakeholder:** QC, Khoa

### Mô tả dự án

`PPJxQSee.AI` là hoạt động hợp tác/đánh giá vendor QSee.ai, liên quan đến use case QC, đặc biệt có thể phục vụ kiểm tra lỗi, measurement, hình ảnh hoặc quality inspection trong sản xuất.

### Mục tiêu

- Đánh giá QSee.ai cho QC/production use case.
    
- Làm rõ khả năng nhận diện lỗi.
    
- Xác định dữ liệu cần cung cấp.
    
- Thảo luận PoC sau NDA.
    
- Xem khả năng áp dụng vào GTAS/QC/Production.
    

### Output mong muốn

- Use case cụ thể.
    
- PoC scope.
    
- Data requirement.
    
- Success criteria.
    
- Timeline đánh giá.
    

### Risk / Dependency

- Cần dữ liệu ảnh/defect đủ đại diện.
    
- Cần chuẩn lỗi/measurement.
    
- Cần NDA và quyền dữ liệu.
    
- Chỉ chuyển thành delivery khi PoC rõ.
    

---

## 8.2 `PPJxNUNOX.ScanTrial`

**Alias:** PPJ x NUNOX, NUNOX  
**Cluster:** Hardware Trial  
**Phase:** Trials / Free of Charge  
**Stakeholder:** Sourcing, Khoa

### Mô tả dự án

`PPJxNUNOX.ScanTrial` là trial sử dụng máy scan chất lượng cao để lưu trữ dữ liệu hình ảnh mẫu vải. Dự án nhằm đánh giá khả năng số hóa mẫu vải bằng thiết bị scan, từ đó hỗ trợ lưu trữ, tìm kiếm, so sánh hoặc tạo data foundation cho AI.

### Mục tiêu

- Trial máy scan mẫu vải.
    
- Đánh giá chất lượng hình ảnh.
    
- Xem khả năng tích hợp vào fabric/sample database.
    
- Hỗ trợ Sourcing/FD/CPD nếu phù hợp.
    
- Xác định business case trước khi mua/triển khai.
    

### Output mong muốn

- Kết quả trial.
    
- Bộ ảnh scan mẫu.
    
- Đánh giá chất lượng.
    
- Chi phí/lợi ích nếu triển khai.
    
- Recommendation tiếp tục hoặc dừng.
    

### Risk / Dependency

- Cần mẫu vải đủ đại diện.
    
- Cần đánh giá chất lượng ảnh thực tế.
    
- Cần biết data sẽ dùng cho hệ thống nào.
    
- Không nên biến thành delivery nếu chưa có use case rõ.
    

---

## 8.3 `PPJxStratova.AI`

**Alias:** PPJ x Stratova AI, Stratova AI  
**Cluster:** External Collaboration / Closed  
**Phase:** Canceled  
**Member:** Khoa

### Mô tả dự án

`PPJxStratova.AI` là hoạt động hợp tác đánh giá Pattern AI cho TD/CPD. Dự án đã bị canceled do chưa có PoC rõ, chưa có demo đủ cụ thể và không đủ resource để tiếp tục theo đuổi.

### Mục tiêu ban đầu

- Đánh giá Pattern AI.
    
- Xem khả năng hỗ trợ TD/CPD.
    
- Tìm use case về pattern/technical/design.
    
- Xem feasibility trước khi triển khai.
    

### Lý do canceled

- Không có PoC rõ.
    
- Không đủ resource.
    
- Chưa chứng minh được impact.
    
- Chưa có demo cụ thể để đánh giá.
    

### Management note

Đưa ra khỏi active delivery để tránh phân tán nguồn lực.

---

## 8.4 `QC.Primo1D.RFID.Thread.v1.0`

**Alias:** PPJ XPrimo1D RFID Thread, QC.PRIMO1D.RFID.THREAD  
**Cluster:** RFID / QC Exploration  
**Phase:** Exploration  
**Stakeholder:** QC, Khoa  
**Progress:** khoảng 5%

### Mô tả dự án

`QC.Primo1D.RFID.Thread.v1.0` là hoạt động exploration về RFID thread của Primo1D, phục vụ định danh sản phẩm, truy xuất nguồn gốc hoặc tracking sản phẩm trong quy trình sản xuất/chất lượng.

### Mục tiêu

- Đánh giá RFID thread cho định danh sản phẩm.
    
- Xem khả năng áp dụng trong QC/production.
    
- Tìm use case tracking/traceability.
    
- Đánh giá chi phí, khả năng triển khai và integration.
    

### Output mong muốn

- Use case exploration.
    
- Feasibility note.
    
- Cost/benefit sơ bộ.
    
- Data/integration requirement.
    
- Recommendation có tiếp tục PoC hay không.
    

### Risk / Dependency

- Cần rõ business case.
    
- Cần đánh giá chi phí tag/thread.
    
- Cần biết hệ thống nào đọc/ghi dữ liệu.
    
- Cần xác định điểm gắn RFID trong quy trình.
    

---

## 8.5 `VITAS.Sharing.202606`

**Alias:** VITAS Sharing  
**Cluster:** External Sharing  
**Phase:** Follow-up / External Sharing

### Mô tả dự án

`VITAS.Sharing.202606` là hoạt động chia sẻ bên ngoài về AI/Automation trong ngành dệt may, phục vụ hình ảnh, tri thức và positioning của PPJ trong chuyển đổi số. Đây không phải delivery project thông thường.

### Mục tiêu

- Hệ thống hóa câu chuyện AI/Automation của PPJ.
    
- Chuẩn bị nội dung chia sẻ external.
    
- Làm rõ case study, approach và lesson learned.
    
- Hỗ trợ truyền thông chuyên môn với VITAS.
    

### Output mong muốn

- Nội dung chia sẻ.
    
- Slide/report nếu cần.
    
- Case study chọn lọc.
    
- Follow-up sau chia sẻ.
    

---

# 9. Workshop / Analysis / Command / Index

---

## 9.1 `AI.Automation.Workshop.202606`

**Alias:** AI Automation Workshop  
**Cluster:** Workshop / Event  
**Phase:** Closed

### Mô tả dự án

`AI.Automation.Workshop.202606` là workshop AI/Automation đã tổ chức cho nội bộ PPJ, nhằm giới thiệu hướng đi, thu thập nhu cầu, tạo nhận thức và mở ra các use case mới từ các phòng ban.

### Mục tiêu

- Truyền thông nội bộ về AI/Automation.
    
- Giới thiệu use case.
    
- Thu thập feedback.
    
- Kích hoạt nhu cầu từ các phòng ban.
    
- Tạo backlog cho giai đoạn sau workshop.
    

### Trạng thái

Workshop đã hoàn tất. Phần tiếp theo được tracking dưới `AI.Automation.Workshop.Analysis.202606`.

---

## 9.2 `AI.Automation.Workshop.Analysis.202606`

**Alias:** Workshop Analysis, Post-workshop Analysis  
**Cluster:** Feedback Intake / Analysis  
**Phase:** Analysis

### Mô tả dự án

`AI.Automation.Workshop.Analysis.202606` là hoạt động phân tích feedback sau AI/Automation Workshop. Mục tiêu là biến nhu cầu/mong muốn từ các phòng ban thành backlog có thể đánh giá, phân loại và đưa vào phase phù hợp.

### Mục tiêu

- Tổng hợp feedback sau workshop.
    
- Phân loại use case.
    
- Đánh giá readiness.
    
- Xác định owner nghiệp vụ.
    
- Đưa use case phù hợp vào backlog hoặc analysis.
    

### Output mong muốn

- Danh sách feedback.
    
- Phân loại use case.
    
- Readiness score.
    
- Owner/dependency.
    
- Recommendation ưu tiên.
    

---

## 9.3 `PROJECT_COMMAND_CENTER`

**Alias:** PROJECT_COMMAND_CENTER.md  
**Cluster:** Command / Index  
**Phase:** Internal Index

### Mô tả dự án

`PROJECT_COMMAND_CENTER` là command center/index cho project portfolio. Đây là nơi điều hướng, theo dõi, hoặc liên kết các project note, registry, lifecycle, backlog và report. Nó không phải project delivery nghiệp vụ.

### Mục tiêu

- Làm project index.
    
- Giữ danh mục canonical code.
    
- Liên kết project note.
    
- Hỗ trợ portfolio governance.
    
- Tránh mất context giữa nhiều project.
    

### Lưu ý scope

Không biến `PROJECT_COMMAND_CENTER` thành nơi chứa toàn bộ nội dung chi tiết của mọi project. Nó nên giữ vai trò navigation/index.

---

# 10. Candidate / Related Initiative cần xác nhận thêm

## 10.1 `PPJ.GenAI.Cloud.Infrastructure.POC.v1.0`

**Alias:** GenAI & Cloud Infrastructure, Gemini Enterprise, GCP Backup & GCE  
**Cluster:** Cloud / GenAI Infrastructure  
**Phase:** Discovery / Proposal  
**Stakeholders:** PPJ, Google Cloud, Cloud Ace

### Mô tả sơ bộ

Đây là initiative liên quan đến GenAI và Cloud Infrastructure, gồm hai workstream chính: backup/storage/GCE và GenAI/Gemini Enterprise. Use case có thể gồm AI Agent cho Product Design knowledge work, HR onboarding/training chatbot, Procurement/Supply Chain contract summarization, quote comparison, shipment/order lookup và Operations reporting automation.

### Lưu ý

Project này có dấu hiệu tồn tại trong context tài liệu, nhưng chưa nằm trong danh sách 26 project operational mapping mới nhất. Cần xác nhận có đưa vào official portfolio hay chỉ giữ ở nhóm exploration/vendor discussion.

---

# 11. Portfolio-level Understanding

## 11.1 Các project nền tảng chiến lược

|Project|Vì sao quan trọng|
|---|---|
|`COSTING.AGENTIC.PLATFORM.v1.1`|Giải quyết bài toán báo giá hàng loạt, liên quan nhiều phòng kỹ thuật|
|`PPJ.PERRI.Chatbot.v3.2`|Nền cho agent, permission, API/tool calling|
|`SCP.SOURCING.CHATBOT.v2.3`|Nền dữ liệu và chatbot cho Sourcing|
|`TD.TechnicalKnowledge.Platform.v2.1`|Data node quan trọng cho technical và costing agents|
|`PPJ.InvoiceDownloader.v1.2`|Bước chuyển sang agent-enabled automation qua GPT/PERRI|

## 11.2 Các project vận hành ổn định / support

|Project|Vai trò|
|---|---|
|`ACC.GRN-SupplierInvoiceBot.v2.3`|Accounting GRN / Supplier Invoice automation|
|`EXIM.ExpenseInvoices.Automation.v1.1`|EXIM invoice automation|
|`PUR.Adhoc.Indent.South.v1.0`|Adhoc indent automation miền Nam|
|`PUR.Inventory.Report.v1.0`|Purchasing inventory reporting|
|`MER.PO.Commit.v1.1`|MER PO processing support|
|`PPJ.GLPI.Helpdesk.AI.Chatbot.v1.0`|Helpdesk knowledge support|

## 11.3 Các project đang cần data governance mạnh

|Project|Data governance cần làm|
|---|---|
|`COSTING.AGENTIC.PLATFORM.v1.1`|Source of truth cho BOM, Sew, Wash, Cut, costing history|
|`SCP.SOURCING.CHATBOT.v2.3`|Metadata và ownership cho external samples|
|`TD.TechnicalKnowledge.Platform.v2.1`|Naming convention, permission, Directus structure|
|`PPJ.ExpenseInvoices.v1.1`|Ledger mapping và accounting fields|
|`MER.MARKET.INTELLIGENCE.v1.1`|Sales/PO/inventory/market signal quality|
|`FD.Datamart.v2.2`|Fabric metadata, QR data consistency|
|`CPD.Datamart.v1.1`|Visual asset metadata và image search quality|

---

# 12. Rule thảo luận từ giờ

Khi anh nói:

- “costing platform” → hiểu là `COSTING.AGENTIC.PLATFORM.v1.1`
    
- “sourcing chatbot” → hiểu là `SCP.SOURCING.CHATBOT.v2.3`
    
- “FD hanger” hoặc “QR hanger” → hiểu là `FD.Datamart.v2.2`
    
- “CPD datamart” → hiểu là `CPD.Datamart.v1.1`
    
- “technical platform của anh Tứ” → hiểu là `TD.TechnicalKnowledge.Platform.v2.1`
    
- “invoice downloader” → hiểu là `PPJ.InvoiceDownloader.v1.2`
    
- “Chico’s audit” → hiểu là `MER.CHICOS.INVOICE.RECHECK-AUDIT.v1.1`
    
- “expense invoice” → hiểu là `PPJ.ExpenseInvoices.v1.1`
    
- “GRN supplier invoice bot” → hiểu là `ACC.GRN-SupplierInvoiceBot.v2.3`
    
- “wash sampling portal” → hiểu là `WASH.SAMPLING.MANAGEMENT.PORTAL.v1.1`
    
- “market intelligence / e-commerce / Quince” → hiểu là `MER.MARKET.INTELLIGENCE.v1.1`
    
- “HR BHXH WISER data” → hiểu là `HR.SSPFD.Workflow.v1.1`
    
- “Primo1D / RFID thread” → hiểu là `QC.Primo1D.RFID.Thread.v1.0`
    

Không tự đổi tên, không tự tách project, không tự nâng version nếu chưa có xác nhận.