

Gửi yêu cầu này cho ChatGPT kèm nội dung nguồn và các mẫu bên dưới.

```text
Trả toàn bộ nội dung dưới dạng Obsidian Markdown trong một khối code.
Dùng heading, danh sách và bảng Markdown. Dùng ppj-metrics cho KPI,
ppj-columns cho các luồng so sánh, ppj-roadmap cho mốc theo tuần và
ppj-priorities cho các đầu ra ưu tiên. Giữ nguyên số liệu, phạm vi,
mức độ xác nhận và câu chữ thể hiện đề xuất. Chỉ đánh dấu tuần có
bằng chứng từ nguồn. Viết phần trăm thanh KPI bằng số 0–100 sau dấu |.
```

Bấm nút **Copy** của khối code trong ChatGPT rồi dán vào trình sửa Markdown hoặc vào thẻ sau khi bấm đúp để sửa. Dán phần nội dung bên trong khối code. Dùng Reading View hoặc thoát chế độ sửa thẻ để xem bố cục.

## KPI và thanh tỷ lệ

```md
> [!ppj-metrics] Chất lượng dữ liệu
>
>> [!ppj-stat] Tổng hồ sơ
>> **20**
>
>> [!ppj-stat] Đã đối chiếu
>> **15**
>
>> [!ppj-meter|75] Tỷ lệ đã đối chiếu
>> 15/20
```

## So sánh hai quy trình

```md
> [!ppj-columns] So sánh quy trình
>
>> [!ppj-flow] Hiện tại
>> 1. Nhận dữ liệu
>> 2. Đối chiếu thủ công
>
>> [!ppj-flow] Đề xuất
>> 1. Nhận dữ liệu
>> 2. *Kiểm tra điều kiện*
>> 3. Đối chiếu
```

## Roadmap

Đặt `**●**` ở tuần có công việc. Tên hạng mục in nghiêng hiển thị màu cam, tên in đậm hiển thị màu xanh lam, các hàng còn lại dùng xanh ngọc.

```md
> [!ppj-roadmap] Lịch đề xuất
> | Hạng mục | W1 | W2 | W3 |
> | --- | :-: | :-: | :-: |
> | *Khảo sát* | **●** | | |
> | Mapping | | **●** | **●** |
> | **Kiểm chứng** | | | **●** |
```

## Ưu tiên

```md
> [!ppj-priorities] Đầu ra cần chốt
> 1. **Mẫu chuẩn** — Chọn một bộ hồ sơ để đối chiếu.
> 2. **Bảng mapping** — Ghi rõ nguồn và điều kiện áp dụng.
```


