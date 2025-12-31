# Hướng dẫn chạy Hotel-Web trên Localhost

## Yêu cầu hệ thống

- Java 21
- Node.js 18+ và npm
- MySQL 8.0
- Maven (được bao gồm trong project - mvnw)

## Bước 1: Cài đặt Database

1. Tạo database MySQL:
   ```sql
   CREATE DATABASE hotel_booking;
   ```

2. Cấu hình database trong `backend/src/main/resources/application.properties`:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/hotel_booking
   spring.datasource.username=root
   spring.datasource.password=your_password
   ```
   (Nếu bạn không có password, để trống như hiện tại)

## Bước 2: Chạy Backend

1. Di chuyển vào thư mục backend:
   ```bash
   cd Hotel-Web/backend
   ```

2. Chạy Spring Boot application:
   ```bash
   ./mvnw spring-boot:run
   ```
   Hoặc trên Windows:
   ```bash
   mvnw.cmd spring-boot:run
   ```

3. Backend sẽ tự động:
   - Tạo các bảng trong database (nhờ `spring.jpa.hibernate.ddl-auto=update`)
   - Seed dữ liệu mẫu (19 phòng và 2 roles: ROLE_USER, ROLE_ADMIN)
   - Chạy trên port 9192: http://localhost:9192

4. Kiểm tra backend đang chạy:
   - Mở browser và truy cập: http://localhost:9192/rooms/all-rooms
   - Bạn sẽ thấy danh sách các phòng (JSON format)

## Bước 3: Chạy Frontend

1. Mở terminal mới, di chuyển vào thư mục frontend:
   ```bash
   cd Hotel-Web/fontend
   ```

2. Cài đặt dependencies (nếu chưa có):
   ```bash
   npm install
   ```

3. Chạy development server:
   ```bash
   npm run dev
   ```

4. Frontend sẽ chạy trên port 5173: http://localhost:5173

## Dữ liệu mẫu

Khi backend khởi động lần đầu, hệ thống sẽ tự động tạo:

- **Roles**: ROLE_USER, ROLE_ADMIN
- **19 Rooms mẫu** với các loại:
  - Standard ($50.00)
  - Superior ($75.00)
  - Deluxe ($100.00)
  - Suite ($150.00)
  - Single/Double/Twin/Triple Bedroom
  - Family Room
  - Various View Rooms (City, Ocean, Sea, Garden, Lake, Balcony)
  - Jacuzzi Room
  - Pool Villa
  - Connecting Room
  - Extra Bed

## Lưu ý

- Đảm bảo MySQL đang chạy trước khi khởi động backend
- Backend cần chạy trước frontend
- Nếu gặp lỗi CORS, kiểm tra file `CorsConfig.java` đã được cấu hình đúng
- Dữ liệu mẫu chỉ được tạo khi database trống (lần đầu chạy)
- Nếu muốn reset database, xóa database và tạo lại

## Troubleshooting

### Lỗi "Error fetching rooms"
- Kiểm tra backend có đang chạy trên port 9192 không
- Kiểm tra database connection trong application.properties
- Kiểm tra console của backend xem có lỗi gì không

### Lỗi kết nối database
- Đảm bảo MySQL đang chạy
- Kiểm tra username/password trong application.properties
- Kiểm tra database `hotel_booking` đã được tạo chưa

### Frontend không kết nối được backend
- Kiểm tra CORS configuration trong `CorsConfig.java`
- Đảm bảo backend đang chạy trên http://localhost:9192
- Kiểm tra console của browser (F12) để xem lỗi cụ thể

