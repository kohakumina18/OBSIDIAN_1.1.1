---
type: meeting
date: 2026-09-24
project: PPJ AI & Automation Portfolio (all)
meeting_title: BOD review of the AI & Automation portfolio - Madame Q3 report
source: recording "MADAME Q3 - REPORT - 2026 09 24 14 16 41" (YouTube fwtAsSgDXHA) + two AI-written analyses of it
source_reliability: speech-to-text, noisy; transcript received only up to 1:14:54 (message cut at 50,000 characters)
last_verified: 2026-09-25
---

# BOD review 24/09/2026 - Madame Phương

## Độ tin cậy của ghi chú này

Ba nguồn, độ tin khác nhau. Mỗi ý bên dưới gắn nhãn:

- **[T mm:ss]** - có trong transcript, kèm mốc thời gian để nghe lại.
- **[A]** - chỉ có trong hai bản phân tích, transcript nhận được **không chứa** (có thể nằm sau phút 1:14:54 hoặc là suy diễn). Chưa xác minh.
- **[X]** - transcript **mâu thuẫn** với bản phân tích hoặc với vault.

Transcript là chữ nhận dạng giọng nói: tên riêng và thuật ngữ bị méo (ví dụ "smart mining", "file name", "ID" cho IED). Chỗ nào diễn giải là suy đoán thì ghi "có thể là".

## Yêu cầu về cách trình bày portfolio

1. **Slide đầu là bản đồ hệ sinh thái WFX**: vòng lõi là các module WFX, gắn dấu hiệu nhỏ (ngôi sao, "màu nhỏ thôi") lên **mỗi module đã có AI/automation**. Module không có thì để trống. Sau đó mới đi vào từng nhóm dự án. [T 00:00-01:59, 21:29-22:18, 25:07-25:49]
2. **Mỗi dự án phải trả lời: dùng module nào, lấy dữ liệu từ đâu, phục vụ phòng ban nào, đầu ra gì, tiến độ ra sao.** Ghi cả người dùng ở phía dưới. [T 00:59, 10:28-11:15, 16:11]
3. **Gom các dự án cùng một luồng thành một mắt xích**, không trình bày rời. Ví dụ PO Commit và các dự án liền kề; nhóm Inventory - Allocation - Indent - GDI; nhóm kho và kế toán. [T 12:15-13:54]
4. **Gom Technical và Costing về một cụm** để người trình bày đi một mạch logic (Style, BOM, Consumption, Sampling, Costing). Tên cụm trong bản ghi là "smart mining", có thể là "Smart Merchandising". [T 15:42-19:23]
5. **Finance và Admin để riêng**; Admin không phải module WFX - ứng dụng Admin Expense nằm ngoài WFX. [T 04:13, 19:23]
6. **Liệt kê hết, thu nhỏ card**, để dành chỗ cho phần mô tả dự án. Chú ý người nghe không cần biết hết chi tiết. [T 11:44-12:15]
7. **Demo nên chuẩn bị nhiều câu hỏi**, không chỉ một câu; câu demo Costing và 3D chạy quá nhanh. [T 37:37-38:42]
8. Trình bày ai làm phần nào, ai demo phần nào. [T 25:49-26:56] Ý phê bình về việc chuyền lời giữa nhiều người [A] không tìm thấy trong phần transcript nhận được.

## Gắn dự án vào module - những gì transcript nói thật

| Dự án | Transcript | So với hai bản phân tích |
| --- | --- | --- |
| Expense invoice | Dùng nhiều nhất cho **Finance** và **Inbound**, cả export/import; Admin dùng nhưng Admin không thuộc WFX. Người trình bày nói sẽ "mở rộng cho những đơn vị nhận hóa đơn" và giữ tên tập trung. [T 03:09-04:39] | **[X]** Phân tích 1 nói "không được gộp `PPJ.ExpenseInvoices` với `LOG.EXPENSE.INVOICES`". Đoạn này nghe như **một** ứng dụng mở rộng ra nhiều đơn vị - khớp với việc vault đã gộp thành `LOG_ExpenseInvoiceProcessing_v1.2.2`. Chưa đủ chắc để kết luận. |
| Order processing | Ba kênh: WFX, một file theo dõi cho sales, và danh sách cho sales nhập liệu; đi qua **Style** và **Buyer Order Management**, xuống nhà máy song song. Giá trị lớn nhất ở division có đơn lớn, nhiều màu/size, đổi liên tục, gia công ngoài. [T 05:10-10:28] | Khớp phân tích 2. |
| Sourcing chatbot | Thông tin nhà cung cấp nằm **trong Inventory**. [T 14:41] | **[X]** Phân tích 1 gắn chính vào **MMX**, phụ vào Inventory. Canvas hiện vẽ tới MMSx. Đoạn ghi âm rất méo, cần hỏi lại. |
| FD Datamart | Lấy dữ liệu từ nhiều module: Inventory, Material, **Style Library**; không lấy Finance. Một phần là "tương lai". [T 20:52-21:29] | Phân tích 1 coi là nền dữ liệu, không nối từng module. Transcript cho thấy có phụ thuộc dữ liệu thật. |
| Chuyền treo (IoT hanger) | Hỏi gắn vào đâu; người trình bày thấy "ở giữa là reporting analytics" - tức phần **Reporting & Analysis** ở tâm sơ đồ. [T 27:59-28:32] | **[X]** Phân tích 1 gắn vào Production. Canvas đang vẽ Production Management. |
| QC, Production Planning, Production Management | Madame chốt **không gắn sao**: chưa có tự động. QC vẫn ở mức nghiên cứu. [T 21:29-22:18, 28:32-29:20] | **[X]** Phân tích 1 gắn nhiều dự án vào Production. Canvas cũng vẽ đường affinity tới QC và Production Management. Vì là AFFINITY (chưa tích hợp) nên không sai, nhưng BOD sẽ đọc "không có sao = chưa có". |
| GTAS Compliance | Đề nghị **bỏ ra khỏi vòng ngoài**, không ai dùng. [T 22:18-22:42] | Canvas hiện vẫn hiển thị. |
| GTAS Transportation | "mình chưa có cái gì" - không có dự án nào gắn. [T 22:42-23:47] | **[X]** Thẻ AWB trên canvas ghi "Also relates to: GTAS Transportation" (lấy từ baseline cũ). Transcript không ủng hộ. |
| HR | Dùng **Production** và **Salary** (có thể là GTAS Production / GTAS Salary) và có một mục "retard"/"regional" không rõ. [T 19:23-20:52] | Khớp với canvas Finance AI (GTAS Production, Salary, HRIS). |
| Admin Expense - E-office | E-office **đã ngừng dịch vụ lâu**, mở lại phải **trả phí**; nhà cung cấp đang báo giá lại. Không tự động kết nối được nếu chưa mở lại. [T 24:31-25:07] | Canvas vẽ `PLANNED | E-office`. Nên ghi thêm là **bị chặn bởi phí và báo giá**. |
| Costing | Nguồn lấy từ **IED** (và Consumption). [T 17:25] | Khớp với đường PLANNED tới GTAS IED. |
| GLPI chatbot | Không thấy trong transcript nhận được. | **[A]** "Merchandising AI Helpdesk" chưa xác minh. Vault đang xếp Internal Chatbot & AI Platforms. |
| Stratova | Không thấy trong transcript nhận được. | **[A]** "Active PoC" chưa xác minh; vault ghi Closed. |

## Finance AI (WS2 / WS3) - transcript xác nhận

- **Chỉ so sánh OC đã xuất hàng trong kỳ**; OC chưa xuất chưa đủ cơ sở kết luận. [T 51:47-52:27]
- Có **177 OC "lệch kỳ"**: giá vốn và doanh thu không ghi nhận cùng kỳ; đề xuất yêu cầu tờ khai xuất và xuất kho cùng kỳ. [T 50:11, 1:13:59-1:14:54] *(chi tiết này không có trong hai bản phân tích)*
- **Ngưỡng 5% quá chặt**: 5,01% - 5,3% đều bị đánh dấu, gần như đỏ hết; đang cân nhắc 7%, 8%, 10%, 15%. **Chưa chốt số nào**, chờ Finance / Control xác nhận. [T 53:55-57:51, 1:12:33-1:13:17]
- Phân tích nguyên nhân lệch theo **nguyên phụ liệu, chi phí gia công, overhead**; overhead chỉ có theo tháng nên OC trong tháng chưa có. [T 54:24, 57:51-58:29, 1:03:52-1:05:32]
- Bộ lọc **Company** đã có; cần thêm **Division** và **nhóm Sales** để phòng kiểm soát nội bộ đi từ tổng thể xuống nhóm cần kiểm. [T 1:06:20-1:09:53, 1:12:07-1:12:33]
- Dashboard hiện lấy overhead của công ty đang làm; các công ty khác chưa. [T 1:07:05]

## Cắt vải và tối ưu hóa - từ ngữ nhạy cảm

Ý tưởng của anh Tứ về xếp mảnh trải bàn cắt theo nhóm ánh màu / độ co vẫn ở **nghiên cứu**; nhà máy nhỏ, chật, OC đã gán cứng cho nhà máy nên khó áp dụng. Việc đang nhờ bên trường nghiên cứu. [T 29:20-35:58]

**Madame dặn tránh hai từ khi trình bày: "plan" và "tối ưu / optimize"** - "nhạy cảm", dễ bị hiểu là nhà máy đang làm chưa tốt. Dùng "nghiên cứu", "hỗ trợ". [T 34:05-34:47] *(hai bản phân tích không ghi điều này)*

## Chỉ có trong hai bản phân tích, chưa xác minh (nằm ngoài phần transcript nhận được)

- Order Profitability Risk (dự báo lợi nhuận trước khi nhận đơn).
- Tách OC gia công / subcontract khỏi mô hình chuẩn (dấu hiệu "không có main fabric").
- Mapping nhà máy giữa HR và WFX cho WS3; đo hiệu suất theo SAM.
- Không xây thêm chatbot riêng cho Finance.
- Costing hiện mất "nhiều giờ đến 1-3 ngày"; KPI thời gian báo giá.
- Smart Factory cần dữ liệu gần thời gian thực.
- Kịch bản trình bày "một người giữ mạch chính".

Cần nghe nốt phần sau 1:14:54 hoặc gửi phần transcript còn lại trước khi đưa các mục này vào registry.

## Việc tiếp theo (đề xuất, chưa thực hiện)

1. Xác nhận tên thật của cụm "smart mining".
2. Chốt: Sourcing chatbot gắn vào **Inventory** hay **MMX**.
3. Chốt: chuyền treo gắn vào **Production** hay **Reporting & Analysis**.
4. Bỏ dòng "GTAS Transportation" khỏi thẻ AWB; cân nhắc ẩn GTAS Compliance trên bản trình BOD.
5. Ghi trên canvas: E-office **bị chặn bởi phí mở lại**.
6. Tính lại số đường "AFFINITY" tới QC / Production Management, vì BOD đọc module có nối là "đã có tự động".
7. Quyết định việc gộp hai dự án expense invoice - transcript nghiêng về **một** ứng dụng mở rộng cho nhiều đơn vị.
8. Cập nhật ghi nhớ dự án Finance AI với các điểm đã xác nhận ở phần trên (ngưỡng chưa chốt, OC đã xuất, lệch kỳ, Division / Sales Group).

## Liên kết

[[PPJ_Digital_Application_AI_Automation_Ecosystem]] · [[PPJ_Operational_Systems_Landscape]] · [[PPJ_PORTFOLIO_CURRENT_SNAPSHOT]] · [[FIN.AI.FINANCE.MANAGEMENT.v1.1]]
