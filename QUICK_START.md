# Quick Start Guide - Chạy Project trên Localhost

## Đã hoàn thành cài đặt

✅ Java 21 đã được cài đặt và cấu hình  
✅ JAVA_HOME và PATH đã được thêm vào ~/.zshrc

## Các bước tiếp theo

### 1. Mở terminal MỚI (để load cấu hình từ ~/.zshrc)

Hoặc chạy lệnh này trong terminal hiện tại:
```bash
source ~/.zshrc
```

### 2. Kiểm tra Java hoạt động

```bash
java -version
echo $JAVA_HOME
```

Kết quả mong đợi:
```
openjdk version "21.0.9"
JAVA_HOME=/usr/local/opt/openjdk@21
```

### 3. Đảm bảo MySQL đang chạy và tạo database

```bash
mysql -u root -p
```

Trong MySQL:
```sql
CREATE DATABASE IF NOT EXISTS hotel_booking;
exit;
```

### 4. Chạy Backend

```bash
cd Hotel-Web/backend
./mvnw spring-boot:run
```

Backend sẽ:
- Tự động tạo các bảng trong database
- Seed 19 phòng mẫu và 2 roles (ROLE_USER, ROLE_ADMIN)
- Chạy trên http://localhost:9192

### 5. Chạy Frontend (terminal mới)

```bash
cd Hotel-Web/fontend
npm install  # Nếu chưa chạy
npm run dev
```

Frontend sẽ chạy trên http://localhost:5173

## Kiểm tra

1. **Backend API**: Mở browser và truy cập:
   - http://localhost:9192/rooms/all-rooms
   - Bạn sẽ thấy danh sách 19 phòng (JSON format)

2. **Frontend**: Mở browser và truy cập:
   - http://localhost:5173
   - Giao diện sẽ hiển thị các phòng

## Lưu ý quan trọng

- **Symlink Java**: Nếu bạn muốn system Java wrappers tìm thấy Java, chạy:
  ```bash
  sudo ln -sfn /usr/local/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
  ```
  (Cần nhập password của bạn)

- **Mỗi lần mở terminal mới**, Java sẽ tự động được cấu hình nhờ ~/.zshrc

- Nếu gặp lỗi, kiểm tra:
  - MySQL đang chạy chưa?
  - Database `hotel_booking` đã được tạo chưa?
  - Backend đã chạy trên port 9192 chưa?

## Troubleshooting

### Lỗi "JAVA_HOME not set"
```bash
export JAVA_HOME="/usr/local/opt/openjdk@21"
export PATH="/usr/local/opt/openjdk@21/bin:$PATH"
```

### Lỗi kết nối database
Kiểm tra file `backend/src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/hotel_booking
spring.datasource.username=root
spring.datasource.password=your_password
```

### Backend không khởi động
- Kiểm tra port 9192 có đang được sử dụng không
- Kiểm tra MySQL có đang chạy không
- Xem logs trong console để biết lỗi cụ thể

