#!/bin/bash

# Script để khởi động Backend
echo "🚀 Đang khởi động Backend..."
echo ""

# Kiểm tra MySQL đang chạy
if ! lsof -ti:3306 > /dev/null 2>&1; then
    echo "❌ MySQL chưa chạy trên port 3306"
    echo "   Vui lòng khởi động MySQL trước"
    exit 1
fi

echo "✓ MySQL đang chạy"
echo ""

# Kiểm tra và setup database
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
if [ -f "$SCRIPT_DIR/SETUP_DATABASE.sh" ]; then
    echo "🔍 Đang kiểm tra database..."
    bash "$SCRIPT_DIR/SETUP_DATABASE.sh"
    echo ""
fi

# Di chuyển vào thư mục backend
cd "$SCRIPT_DIR/backend" || exit 1

# Kiểm tra Java
if ! command -v java &> /dev/null; then
    echo "❌ Java chưa được cài đặt hoặc chưa có trong PATH"
    echo "   Vui lòng cài đặt Java 21 và thêm vào PATH"
    exit 1
fi

# Hiển thị thông tin Java
echo "📋 Thông tin Java:"
java -version
echo ""

# Kiểm tra database
echo "🔍 Thông tin kết nối database:"
echo "   URL: jdbc:mysql://127.0.0.1:3306/hotel_booking"
echo "   Username: root"
echo "   Password: 01112003"
echo ""

# Khởi động backend
echo "▶️  Đang khởi động Spring Boot..."
echo "   Backend sẽ chạy trên: http://localhost:9192"
echo "   Backend sẽ tự động:"
echo "   - Tạo các bảng nếu chưa có"
echo "   - Seed dữ liệu mẫu (19 phòng, 2 roles, 2 users)"
echo "   Nhấn Ctrl+C để dừng"
echo ""

./mvnw spring-boot:run

