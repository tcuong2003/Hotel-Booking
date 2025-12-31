# Hướng dẫn Setup Database và Khởi động

## 🚀 Khởi động nhanh

### Bước 1: Setup Database (Tự động)

```bash
cd /Users/mac/Desktop/hotelbooking/Hotel-Web
./SETUP_DATABASE.sh
```

Script này sẽ:
- ✅ Kiểm tra MySQL đang chạy
- ✅ Tạo database `hotel_booking` nếu chưa có
- ✅ Kiểm tra kết nối với thông tin:
  - Host: 127.0.0.1:3306
  - User: root
  - Password: 01112003

### Bước 2: Khởi động Backend

```bash
./START_BACKEND.sh
```

Hoặc thủ công:
```bash
cd Hotel-Web/backend
./mvnw spring-boot:run
```

Backend sẽ tự động:
- ✅ Tạo các bảng trong database (nếu chưa có)
- ✅ Seed dữ liệu mẫu:
  - **2 Roles**: ROLE_USER, ROLE_ADMIN
  - **19 Rooms** với đầy đủ loại phòng
  - **2 Users**:
    - `test@hotel.com` / `123456` (ROLE_USER)
    - `admin@hotel.com` / `admin123` (ROLE_ADMIN)

### Bước 3: Khởi động Frontend

```bash
cd Hotel-Web/fontend
npm install  # Nếu chưa chạy
npm run dev
```

## 📊 Dữ liệu mẫu

### Rooms (19 phòng)
- Standard ($50.00)
- Superior ($75.00)
- Deluxe ($100.00)
- Suite ($150.00)
- Single Bedroom ($45.00)
- Double Bedroom ($65.00)
- Twin Bedroom ($65.00)
- Triple Bedroom ($85.00)
- Family Room ($120.00)
- City View ($80.00)
- Ocean View ($110.00)
- Sea View ($105.00)
- Garden View ($70.00)
- Lake View ($90.00)
- Balcony Room ($95.00)
- Jacuzzi Room ($130.00)
- Pool Villa ($200.00)
- Connecting Room ($140.00)
- Extra Bed ($60.00)

### Users
- **Test User**: `test@hotel.com` / `123456`
- **Admin User**: `admin@hotel.com` / `admin123`

## 🔍 Kiểm tra

### Kiểm tra Backend
```bash
curl http://localhost:9192/rooms/all-rooms
```

Hoặc mở browser: http://localhost:9192/rooms/all-rooms

### Kiểm tra Frontend
Mở browser: http://localhost:5173

## ⚙️ Cấu hình Database

File: `backend/src/main/resources/application.properties`

```properties
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/hotel_booking?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=01112003
```

## 🔧 Troubleshooting

### Lỗi "MySQL không chạy"
```bash
# Kiểm tra MySQL
lsof -ti:3306

# Khởi động MySQL (tùy vào cách cài đặt)
# Homebrew:
brew services start mysql
# Hoặc:
mysql.server start
```

### Lỗi "Database không tồn tại"
```bash
# Chạy script setup
./SETUP_DATABASE.sh

# Hoặc thủ công:
mysql -u root -p01112003 -e "CREATE DATABASE IF NOT EXISTS hotel_booking;"
```

### Lỗi "Backend không kết nối được database"
1. Kiểm tra MySQL đang chạy: `lsof -ti:3306`
2. Kiểm tra password trong `application.properties`
3. Kiểm tra database đã được tạo: `mysql -u root -p01112003 -e "SHOW DATABASES;"`

### Reset Database (Xóa và tạo lại)
```bash
mysql -u root -p01112003 -e "DROP DATABASE IF EXISTS hotel_booking; CREATE DATABASE hotel_booking;"
# Sau đó khởi động lại backend
```

## 📝 Lưu ý

- DataSeeder sẽ tự động kiểm tra và tạo dữ liệu thiếu mỗi lần backend khởi động
- Nếu database trống, tất cả dữ liệu sẽ được tạo tự động
- Nếu đã có dữ liệu, chỉ các dữ liệu thiếu sẽ được thêm vào
- Users sẽ được cập nhật password mỗi lần backend khởi động để đảm bảo đúng

