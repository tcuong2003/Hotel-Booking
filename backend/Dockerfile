FROM eclipse-temurin:21-jdk
WORKDIR /app

# Copy Maven wrapper + pom từ backend/
COPY backend/mvnw ./mvnw
COPY backend/.mvn ./.mvn
COPY backend/pom.xml ./pom.xml

RUN chmod +x ./mvnw
RUN ./mvnw dependency:go-offline -B

# Copy source code từ backend/src
COPY backend/src ./src

RUN ./mvnw clean package -DskipTests

EXPOSE 8080
CMD ["sh","-c","java -Dserver.port=$PORT -jar target/*.jar"]


# # Dockerfile for Backend (Spring Boot)
# FROM eclipse-temurin:21-jdk

# # Set working directory
# WORKDIR /app

# # Copy Maven wrapper and pom.xml
# COPY mvnw .
# COPY .mvn .mvn
# COPY pom.xml .

# # Download dependencies (this layer will be cached if pom.xml doesn't change)
# RUN ./mvnw dependency:go-offline -B

# # Copy source code
# COPY src ./src

# # Build the application
# RUN ./mvnw clean package -DskipTests

# # Expose port
# EXPOSE 9192

# # Run the application
# CMD ["java", "-jar", "target/backend-0.0.1-SNAPSHOT.jar"]