# Kiểm tra kết nối Database

## Cách kiểm tra MySQL và tạo database

### 1. Kiểm tra MySQL có đang chạy

```bash
lsof -ti:3306
```

Nếu có output (một số process ID), MySQL đang chạy.

### 2. Tìm MySQL client

Nếu bạn đã cài MySQL qua Homebrew:

```bash
# MySQL
/usr/local/bin/mysql
# hoặc
/opt/homebrew/bin/mysql  # nếu là Apple Silicon

# MariaDB (nếu dùng MariaDB thay vì MySQL)
/usr/local/bin/mariadb
/opt/homebrew/bin/mariadb
```

Nếu bạn cài MySQL từ website chính thức:

```bash
/usr/local/mysql/bin/mysql
```

### 3. Tạo database

Sau khi tìm thấy MySQL client, chạy:

```bash
/usr/local/bin/mysql -u root -p
```

Hoặc nếu không có password:

```bash
/usr/local/bin/mysql -u root
```

Trong MySQL prompt:

```sql
CREATE DATABASE IF NOT EXISTS hotel_booking;
SHOW DATABASES;
exit;
```

### 4. Kiểm tra cấu hình trong application.properties

File: `backend/src/main/resources/application.properties`

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/hotel_booking
spring.datasource.username=root
spring.datasource.password=  # Để trống nếu không có password
```

Nếu bạn có password, cập nhật:

```properties
spring.datasource.password=your_password
```

### 5. Chạy backend và kiểm tra logs

```bash
cd Hotel-Web/backend
export PATH="/usr/local/opt/openjdk@21/bin:$PATH"
export JAVA_HOME="/usr/local/opt/openjdk@21"
./mvnw spring-boot:run
```

Tìm các dòng log sau để xác nhận kết nối thành công:

- `HikariPool-1 - Starting...`
- `HikariPool-1 - Start completed.`
- `✓ Roles seeded successfully`
- `✓ 19 rooms seeded successfully`

Nếu có lỗi kết nối, bạn sẽ thấy:

- `Communications link failure`
- `Access denied for user`
- `Unknown database 'hotel_booking'`

### 6. Test kết nối từ backend

Sau khi backend khởi động xong (thấy "Started BackendApplication"), mở browser:

- http://localhost:9192/rooms/all-rooms

Nếu thấy JSON data, database đã kết nối thành công!

## Troubleshooting

### MySQL không chạy

Nếu bạn cài MySQL qua Homebrew:

```bash
brew services start mysql
```

Hoặc nếu cài từ website:

```bash
sudo /usr/local/mysql/support-files/mysql.server start
```

### Không tìm thấy MySQL client

Cài MySQL client qua Homebrew:

```bash
brew install mysql-client
```

Sau đó thêm vào PATH trong ~/.zshrc:

```bash
echo 'export PATH="/usr/local/opt/mysql-client/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Lỗi "Access denied"

Kiểm tra username/password trong application.properties có đúng không.

### Lỗi "Unknown database"

Đảm bảo đã tạo database `hotel_booking` như bước 3 ở trên.
