# Hotel-Web Docker Setup

Dự án Hotel-Web được container hóa với Docker để dễ dàng phát triển và triển khai.

## Cấu trúc

- **backend/**: Spring Boot API (Java 21)
- **fontend/**: React frontend (Vite)
- **docker-compose.yml**: Orchestration cho toàn bộ hệ thống

## Cách chạy

1. **Cài đặt Docker và Docker Compose**

2. **Chạy toàn bộ hệ thống:**

   ```bash
   docker-compose up --build
   ```

3. **Truy cập:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:9192
   - MySQL: localhost:3306 (user: hoteluser, pass: hotelpass)

## Lệnh hữu ích

- **Chạy background:** `docker-compose up -d`
- **Dừng:** `docker-compose down`
- **Xem logs:** `docker-compose logs -f [service_name]`
- **Rebuild:** `docker-compose up --build --force-recreate`

## Services

- **mysql**: Database MySQL 8.0
- **backend**: Spring Boot application
- **frontend**: React application served by Nginx

## Lưu ý

- Database data được persist trong volume `mysql_data`
- Backend sẽ chờ MySQL sẵn sàng trước khi khởi động
- Frontend được build production và serve qua Nginx
