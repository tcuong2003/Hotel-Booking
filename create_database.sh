#!/bin/bash

# Script để tạo database hotel_booking

echo "=== Tạo Database hotel_booking ==="
echo ""

# Tìm MySQL client
MYSQL_CLIENT=""
if [ -f "/usr/local/mysql/bin/mysql" ]; then
    MYSQL_CLIENT="/usr/local/mysql/bin/mysql"
elif [ -f "/usr/local/mysql-9.5.0-macos15-x86_64/bin/mysql" ]; then
    MYSQL_CLIENT="/usr/local/mysql-9.5.0-macos15-x86_64/bin/mysql"
elif [ -f "/opt/homebrew/bin/mysql" ]; then
    MYSQL_CLIENT="/opt/homebrew/bin/mysql"
elif [ -f "/usr/local/bin/mysql" ]; then
    MYSQL_CLIENT="/usr/local/bin/mysql"
else
    echo "❌ Không tìm thấy MySQL client!"
    echo "Vui lòng chạy MySQL client thủ công và tạo database:"
    echo "  CREATE DATABASE hotel_booking;"
    exit 1
fi

echo "✓ Tìm thấy MySQL tại: $MYSQL_CLIENT"
echo ""

# Thử kết nối không password trước
echo "Thử kết nối MySQL (không password)..."
if $MYSQL_CLIENT -u root -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✓ Kết nối thành công (không cần password)"
    $MYSQL_CLIENT -u root -e "CREATE DATABASE IF NOT EXISTS hotel_booking; SHOW DATABASES LIKE 'hotel_booking';"
    echo ""
    echo "✓ Database hotel_booking đã được tạo!"
elif $MYSQL_CLIENT -u root -p -e "SELECT 1;" >/dev/null 2>&1; then
    echo "⚠️  MySQL yêu cầu password"
    echo ""
    echo "Vui lòng chạy lệnh sau và nhập password:"
    echo "  $MYSQL_CLIENT -u root -p"
    echo ""
    echo "Sau đó chạy SQL:"
    echo "  CREATE DATABASE IF NOT EXISTS hotel_booking;"
    echo "  SHOW DATABASES LIKE 'hotel_booking';"
    echo "  exit;"
    echo ""
    echo "Hoặc chạy trực tiếp:"
    echo "  $MYSQL_CLIENT -u root -p -e \"CREATE DATABASE IF NOT EXISTS hotel_booking;\""
else
    echo "❌ Không thể kết nối MySQL"
    echo ""
    echo "Vui lòng:"
    echo "1. Đảm bảo MySQL đang chạy"
    echo "2. Kiểm tra username/password"
    echo "3. Chạy MySQL client thủ công:"
    echo "   $MYSQL_CLIENT -u root -p"
    exit 1
fi

