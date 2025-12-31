# Hướng dẫn cài đặt Java 21 trên macOS

## Phương pháp 1: Sử dụng Homebrew (Khuyến nghị)

1. **Cài đặt Homebrew** (nếu chưa có):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Cài đặt Java 21**:
   ```bash
   brew install openjdk@21
   ```

3. **Tạo symlink và cấu hình JAVA_HOME**:
   ```bash
   sudo ln -sfn /opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-21.jdk
   ```

4. **Thêm vào ~/.zshrc**:
   ```bash
   echo 'export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"' >> ~/.zshrc
   echo 'export JAVA_HOME="/opt/homebrew/opt/openjdk@21"' >> ~/.zshrc
   source ~/.zshrc
   ```

## Phương pháp 2: Sử dụng Oracle JDK hoặc Temurin (Eclipse Adoptium)

1. **Tải Java 21 từ Eclipse Temurin** (miễn phí):
   - Truy cập: https://adoptium.net/temurin/releases/?version=21
   - Chọn macOS, x64 architecture, JDK
   - Tải file .pkg và cài đặt

2. **Sau khi cài đặt, tìm Java Home**:
   ```bash
   /usr/libexec/java_home -V
   ```

3. **Thêm vào ~/.zshrc** (thay `/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home` bằng đường dẫn thực tế):
   ```bash
   export JAVA_HOME=$(/usr/libexec/java_home -v 21)
   export PATH=$JAVA_HOME/bin:$PATH
   ```

4. **Áp dụng thay đổi**:
   ```bash
   source ~/.zshrc
   ```

## Kiểm tra cài đặt

Sau khi cài đặt, kiểm tra:
```bash
java -version
javac -version
echo $JAVA_HOME
```

Kết quả mong đợi:
```
openjdk version "21.x.x" ...
```

## Nếu vẫn gặp lỗi

1. **Kiểm tra Java đã được cài đặt**:
   ```bash
   /usr/libexec/java_home -V
   ```

2. **Nếu thấy Java nhưng không có Java 21**, hãy cài đặt Java 21 theo một trong các phương pháp trên

3. **Đảm bảo JAVA_HOME được set đúng**:
   ```bash
   export JAVA_HOME=$(/usr/libexec/java_home -v 21)
   ```

4. **Thử chạy lại backend**:
   ```bash
   cd Hotel-Web/backend
   ./mvnw spring-boot:run
   ```

## Lưu ý

- Nếu bạn đang sử dụng Apple Silicon (M1/M2/M3), sử dụng `/opt/homebrew` thay vì `/usr/local`
- Nếu bạn đang sử dụng Intel Mac, sử dụng `/usr/local`
- Đảm bảo đã reload terminal hoặc chạy `source ~/.zshrc` sau khi thêm biến môi trường

