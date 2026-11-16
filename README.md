# Farm Equipment Sharing DApp

Đề 25 môn Blockchain Technology. Ứng dụng giúp hợp tác xã quản lý sáu máy cày và cho nông hộ thuê theo ngày. Giao diện hiển thị trạng thái từng máy, số máy còn rảnh và phí thuê. Người dùng kết nối MetaMask để ký giao dịch trên mạng thử nghiệm Ethereum Sepolia.

## Mã nguồn

| Tệp | Vai trò |
| --- | --- |
| `FarmEquipmentSharing.sol` | Hợp đồng Solidity xử lý quyền đăng ký máy, thanh toán tiền thuê và quyền trả máy. |
| `index.html` | Giao diện HTML, CSS và JavaScript. Giao diện đọc trạng thái và gửi yêu cầu giao dịch qua MetaMask. |
| `README.md` | Hướng dẫn chạy, thử chức năng và đối chiếu giao dịch. |

## Hợp đồng triển khai

- Mạng thử nghiệm **Ethereum Sepolia**, chain ID `11155111`.
- Địa chỉ hợp đồng `0x309b2c1EA5ab45788E1ADa43C2e57998AD645D78`.
- Đơn giá thuê **0,07 SepoliaETH mỗi ngày**. Phí gas được tính riêng.

[Xem hợp đồng và danh sách giao dịch trên Sepolia Etherscan](https://sepolia.etherscan.io/address/0x309b2c1EA5ab45788E1ADa43C2e57998AD645D78#transactions)

## Chạy giao diện

Cần Python 3 và một trình duyệt đã cài MetaMask. Ví thực hiện giao dịch cần SepoliaETH để trả gas và, khi thuê, trả tiền thuê.

1. Tải repository về máy. Mở Terminal tại thư mục chứa `index.html` và chạy:

   ```bash
   python3 -m http.server 8000 --bind 127.0.0.1
   ```

2. Giữ Terminal mở và truy cập [http://localhost:8000/index.html](http://localhost:8000/index.html).
3. Chọn **Kết nối MetaMask** và xác nhận mạng **Sepolia**. Trang sẽ đọc dữ liệu từ hợp đồng đã triển khai sẵn.

## Luồng sử dụng

| Thao tác | Ai thực hiện | Kết quả |
| --- | --- | --- |
| Đăng ký máy | Ví quản lý | Chọn mã máy chưa đăng ký. Sau khi xác nhận, máy sẵn sàng cho thuê. |
| Thuê máy | Ví nông hộ | Chọn máy đang rảnh, nhập số ngày nguyên dương và thanh toán đúng tổng phí trong MetaMask. |
| Trả máy | Chính ví đã thuê | Xác nhận giao dịch trả. Máy trở lại trạng thái đang rảnh. |
| Xem trạng thái | Ví đã kết nối | Xem số máy rảnh, trạng thái từng máy và, nếu máy đang thuê, địa chỉ ví thuê cùng hạn trả. |

### Demo thuê và trả máy 01

1. Kết nối ví nông hộ và kiểm tra máy 01 đang rảnh.
2. Nhập **1** vào ô **Số ngày thuê**, kiểm tra tổng phí **0,07 SepoliaETH**, rồi bấm **Thuê máy** và xác nhận trong MetaMask.
3. Chờ giao dịch được xác nhận. Thẻ máy 01 sẽ hiện **Đang thuê**, kèm ví thuê và hạn trả.
4. Với cùng ví, bấm **Trả máy** và xác nhận. Khi giao dịch thành công, máy 01 sẽ hiện **Đang rảnh**. Nếu cả sáu máy đều rảnh trước lần thuê, bộ đếm sẽ thay đổi từ **6/6** xuống **5/6** rồi trở lại **6/6**.

## Đối chiếu giao dịch demo

Mở trang hợp đồng trên Sepolia Etherscan. Chọn liên kết thời gian bên cạnh **Contract Creator** để mở giao dịch triển khai. Hai giao dịch demo còn lại nằm trong tab **Transactions**.

| Giao dịch | Block | Số ETH gửi kèm |
| --- | ---: | ---: |
| Thuê máy 01 trong một ngày | `12148822` | 0,07 SepoliaETH |
| Trả máy 01 | `12148826` | 0 SepoliaETH |

Bấm mã ở cột **Transaction Hash** để kiểm tra trạng thái và thông tin của từng giao dịch.
