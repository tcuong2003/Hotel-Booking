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

# Thử kết nối với password từ application.properties (01112003)
PASSWORD="01112003"

echo "Thử kết nối MySQL với password..."
if $MYSQL_CLIENT -u root -p"$PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✓ Kết nối thành công với password"
    $MYSQL_CLIENT -u root -p"$PASSWORD" -e "CREATE DATABASE IF NOT EXISTS hotel_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    $MYSQL_CLIENT -u root -p"$PASSWORD" -e "SHOW DATABASES LIKE 'hotel_booking';"
    echo ""
    echo "✓ Database hotel_booking đã được tạo!"
elif $MYSQL_CLIENT -u root -e "SELECT 1;" >/dev/null 2>&1; then
    echo "✓ Kết nối thành công (không cần password)"
    $MYSQL_CLIENT -u root -e "CREATE DATABASE IF NOT EXISTS hotel_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    $MYSQL_CLIENT -u root -e "SHOW DATABASES LIKE 'hotel_booking';"
    echo ""
    echo "✓ Database hotel_booking đã được tạo!"
else
    echo "⚠️  Không thể kết nối với password mặc định"
    echo ""
    echo "Vui lòng chạy lệnh sau và nhập password:"
    echo "  $MYSQL_CLIENT -u root -p"
    echo ""
    echo "Sau đó chạy SQL:"
    echo "  CREATE DATABASE IF NOT EXISTS hotel_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    echo "  SHOW DATABASES LIKE 'hotel_booking';"
    echo "  exit;"
    echo ""
    echo "Hoặc chạy trực tiếp với password của bạn:"
    echo "  $MYSQL_CLIENT -u root -p -e \"CREATE DATABASE IF NOT EXISTS hotel_booking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;\""
    exit 1
fi

