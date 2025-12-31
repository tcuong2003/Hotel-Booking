#!/bin/bash
# Script quản lý Backend

case "$1" in
    start)
        if [ -f backend.pid ] && kill -0 $(cat backend.pid) 2>/dev/null; then
            echo "Backend đã đang chạy (PID: $(cat backend.pid))"
        else
            cd backend
            nohup ./mvnw spring-boot:run > ../backend.log 2>&1 &
            echo $! > ../backend.pid
            echo "Backend đang khởi động (PID: $(cat ../backend.pid))"
            echo "Đợi 30 giây để backend khởi động..."
        fi
        ;;
    stop)
        if [ -f backend.pid ]; then
            PID=$(cat backend.pid)
            if kill -0 $PID 2>/dev/null; then
                kill $PID
                rm backend.pid
                echo "Backend đã dừng"
            else
                echo "Backend không chạy"
                rm backend.pid
            fi
        else
            echo "Backend không chạy"
        fi
        ;;
    status)
        if [ -f backend.pid ] && kill -0 $(cat backend.pid) 2>/dev/null; then
            echo "✓ Backend đang chạy (PID: $(cat backend.pid))"
            if curl -s http://localhost:9192/rooms/all-rooms > /dev/null 2>&1; then
                echo "✓ API hoạt động: http://localhost:9192/rooms/all-rooms"
            else
                echo "⚠️  Backend chạy nhưng API chưa sẵn sàng"
            fi
        else
            echo "❌ Backend chưa chạy"
        fi
        ;;
    logs)
        if [ -f backend.log ]; then
            tail -f backend.log
        else
            echo "Không tìm thấy log file"
        fi
        ;;
    *)
        echo "Usage: $0 {start|stop|status|logs}"
        exit 1
        ;;
esac
