#!/bin/bash

# Script tự động setup database và kiểm tra kết nối

echo "=========================================="
echo "  Setup Database Hotel Booking"
echo "=========================================="
echo ""

# Tìm MySQL client
MYSQL_CLIENT=""
if [ -f "/usr/local/mysql/bin/mysql" ]; then
    MYSQL_CLIENT="/usr/local/mysql/bin/mysql"
elif [ -f "/opt/homebrew/bin/mysql" ]; then
    MYSQL_CLIENT="/opt/homebrew/bin/mysql"
elif [ -f "/usr/local/bin/mysql" ]; then
    MYSQL_CLIENT="/usr/local/bin/mysql"
elif command -v mysql &> /dev/null; then
    MYSQL_CLIENT="mysql"
else
    echo "❌ Không tìm thấy MySQL client!"
    exit 1
fi

echo "✓ Tìm thấy MySQL tại: $MYSQL_CLIENT"
echo ""

# Kiểm tra MySQL đang chạy
if ! lsof -ti:3306 > /dev/null 2>&1; then
    echo "❌ MySQL không đang chạy trên port 3306"
    echo "   Vui lòng khởi động MySQL trước"
    exit 1
fi

echo "✓ MySQL đang chạy trên port 3306"
echo ""

# Thông tin kết nối
DB_USER="root"
DB_PASSWORD="01112003"
DB_NAME="hotel_booking"

echo "📋 Thông tin kết nối:"
echo "   Host: 127.0.0.1:3306"
echo "   User: $DB_USER"
echo "   Database: $DB_NAME"
echo ""

# Thử kết nối và tạo database
echo "🔍 Đang kiểm tra và tạo database..."

if $MYSQL_CLIENT -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✓ Kết nối MySQL thành công"
    
    # Tạo database nếu chưa có
    $MYSQL_CLIENT -u "$DB_USER" -p"$DB_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
    
    # Kiểm tra database đã tồn tại
    if $MYSQL_CLIENT -u "$DB_USER" -p"$DB_PASSWORD" -e "USE $DB_NAME;" >/dev/null 2>&1; then
        echo "✓ Database '$DB_NAME' đã sẵn sàng"
        
        # Kiểm tra các bảng
        TABLE_COUNT=$($MYSQL_CLIENT -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "SHOW TABLES;" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$TABLE_COUNT" -gt 1 ]; then
            echo "✓ Đã có $((TABLE_COUNT - 1)) bảng trong database"
        else
            echo "ℹ️  Database trống, các bảng sẽ được tạo tự động khi backend khởi động"
        fi
    else
        echo "❌ Không thể tạo hoặc truy cập database"
        exit 1
    fi
elif $MYSQL_CLIENT -u "$DB_USER" -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✓ Kết nối MySQL thành công (không cần password)"
    
    # Tạo database nếu chưa có
    $MYSQL_CLIENT -u "$DB_USER" -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
    
    # Kiểm tra database đã tồn tại
    if $MYSQL_CLIENT -u "$DB_USER" -e "USE $DB_NAME;" >/dev/null 2>&1; then
        echo "✓ Database '$DB_NAME' đã sẵn sàng"
        
        # Kiểm tra các bảng
        TABLE_COUNT=$($MYSQL_CLIENT -u "$DB_USER" -D "$DB_NAME" -e "SHOW TABLES;" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$TABLE_COUNT" -gt 1 ]; then
            echo "✓ Đã có $((TABLE_COUNT - 1)) bảng trong database"
        else
            echo "ℹ️  Database trống, các bảng sẽ được tạo tự động khi backend khởi động"
        fi
    else
        echo "❌ Không thể tạo hoặc truy cập database"
        exit 1
    fi
else
    echo "❌ Không thể kết nối MySQL"
    echo ""
    echo "Vui lòng kiểm tra:"
    echo "1. MySQL đang chạy"
    echo "2. Username/password đúng"
    echo "3. Chạy thủ công: $MYSQL_CLIENT -u root -p"
    exit 1
fi

echo ""
echo "=========================================="
echo "✓ Setup database hoàn tất!"
echo "=========================================="
echo ""
echo "Bước tiếp theo:"
echo "1. Khởi động backend: cd Hotel-Web/backend && ./mvnw spring-boot:run"
echo "2. Backend sẽ tự động:"
echo "   - Tạo các bảng nếu chưa có"
echo "   - Seed dữ liệu mẫu (19 phòng, 2 roles, 2 users)"
echo ""

