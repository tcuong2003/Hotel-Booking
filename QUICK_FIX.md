# 🔧 Sửa lỗi "No response from server"

## ❌ Lỗi hiện tại
```
Error: Backend chưa chạy! No response from server
```

## ✅ Giải pháp

### Bước 1: Kiểm tra Backend có đang chạy không

```bash
lsof -ti:9192
```

Nếu không có output → Backend chưa chạy

### Bước 2: Khởi động Backend

**Cách 1: Sử dụng script tự động (Khuyến nghị)**
```bash
cd /Users/mac/Desktop/hotelbooking/Hotel-Web
./START_BACKEND.sh
```

**Cách 2: Khởi động thủ công**
```bash
cd /Users/mac/Desktop/hotelbooking/Hotel-Web/backend
./mvnw spring-boot:run
```

### Bước 3: Đợi Backend khởi động

Backend cần 30-60 giây để khởi động. Bạn sẽ thấy:
```
✓ Roles seeded successfully
✓ Total 19 rooms available
✓ Test user ready: test@hotel.com / 123456
✓ Admin user ready: admin@hotel.com / admin123
Started BackendApplication in X.XXX seconds
```

### Bước 4: Kiểm tra Backend đã chạy

Mở browser và truy cập:
```
http://localhost:9192/rooms/all-rooms
```

Nếu thấy JSON data → Backend đã chạy thành công!

### Bước 5: Refresh Frontend

Quay lại frontend và refresh trang (F5 hoặc Cmd+R)

## 🔍 Kiểm tra nhanh

Chạy script kiểm tra:
```bash
cd /Users/mac/Desktop/hotelbooking/Hotel-Web
./CHECK_AND_START.sh
```

Script này sẽ:
- ✅ Kiểm tra MySQL đang chạy
- ✅ Kiểm tra Backend đang chạy
- ✅ Tự động khởi động Backend nếu chưa chạy

## ⚠️ Lưu ý quan trọng

1. **Backend phải chạy TRƯỚC frontend**
2. **MySQL phải chạy TRƯỚC backend**
3. **Backend cần 30-60 giây để khởi động hoàn toàn**
4. **Giữ terminal backend mở** - đừng đóng terminal khi backend đang chạy

## 🐛 Troubleshooting

### Lỗi: "MySQL không chạy"
```bash
# Kiểm tra MySQL
lsof -ti:3306

# Khởi động MySQL (tùy vào cách cài đặt)
brew services start mysql
# hoặc
mysql.server start
```

### Lỗi: "Port 9192 đã được sử dụng"
```bash
# Tìm process đang dùng port 9192
lsof -ti:9192

# Kill process (thay PID bằng số thực tế)
kill -9 PID
```

### Lỗi: "Java not found"
```bash
# Kiểm tra Java
java -version

# Nếu chưa có, cài đặt Java 21
brew install openjdk@21
```

## 📞 Kiểm tra nhanh tất cả

```bash
# Kiểm tra MySQL
lsof -ti:3306 && echo "✓ MySQL OK" || echo "❌ MySQL chưa chạy"

# Kiểm tra Backend
lsof -ti:9192 && echo "✓ Backend OK" || echo "❌ Backend chưa chạy"

# Test Backend API
curl -s http://localhost:9192/rooms/all-rooms | head -5 && echo "✓ Backend hoạt động" || echo "❌ Backend không phản hồi"
```

