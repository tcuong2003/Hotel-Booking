#!/bin/bash

# Script kiểm tra và khởi động backend

echo "=========================================="
echo "  Kiểm tra và Khởi động Backend"
echo "=========================================="
echo ""

# Kiểm tra MySQL
if ! lsof -ti:3306 > /dev/null 2>&1; then
    echo "❌ MySQL chưa chạy trên port 3306"
    echo "   Vui lòng khởi động MySQL trước"
    exit 1
fi
echo "✓ MySQL đang chạy"
echo ""

# Kiểm tra Backend
if lsof -ti:9192 > /dev/null 2>&1; then
    echo "✓ Backend đang chạy trên port 9192"
    echo ""
    echo "Kiểm tra kết nối..."
    if curl -s http://localhost:9192/rooms/all-rooms > /dev/null 2>&1; then
        echo "✓ Backend hoạt động bình thường"
        echo ""
        echo "Bạn có thể truy cập:"
        echo "  - Backend API: http://localhost:9192/rooms/all-rooms"
        echo "  - Frontend: http://localhost:5173"
        exit 0
    else
        echo "⚠️  Backend đang chạy nhưng không phản hồi"
        echo "   Có thể backend đang khởi động hoặc gặp lỗi"
        echo "   Vui lòng kiểm tra logs của backend"
        exit 1
    fi
else
    echo "⚠️  Backend chưa chạy"
    echo ""
    echo "Đang khởi động backend..."
    echo ""
    
    # Chạy script setup database
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    if [ -f "$SCRIPT_DIR/SETUP_DATABASE.sh" ]; then
        bash "$SCRIPT_DIR/SETUP_DATABASE.sh"
        echo ""
    fi
    
    # Khởi động backend
    cd "$SCRIPT_DIR/backend" || exit 1
    
    # Kiểm tra Java
    if ! command -v java &> /dev/null; then
        echo "❌ Java chưa được cài đặt"
        exit 1
    fi
    
    echo "▶️  Đang khởi động Spring Boot..."
    echo "   Backend sẽ chạy trên: http://localhost:9192"
    echo "   Nhấn Ctrl+C để dừng"
    echo ""
    echo "⚠️  Lưu ý: Backend cần thời gian để khởi động (30-60 giây)"
    echo "   Sau khi thấy 'Started BackendApplication', backend đã sẵn sàng"
    echo ""
    
    ./mvnw spring-boot:run
fi

