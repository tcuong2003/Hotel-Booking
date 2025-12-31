# Hotel Booking System

A full-stack hotel booking application built with Spring Boot (backend) and React/Vite (frontend), using MySQL as the database.

## Features

- User registration and authentication
- Room search and booking
- Admin panel for room management
- Responsive UI with modern design
- Docker containerization for easy deployment

## Tech Stack

- **Backend**: Spring Boot, Spring Data JPA, MySQL, Lombok
- **Frontend**: React, Vite, JavaScript
- **Database**: MySQL 8.0
- **Containerization**: Docker, Docker Compose

## Prerequisites

- Docker and Docker Compose
- Node.js (for local frontend development)
- Java 21 (for local backend development)

## Quick Start with Docker

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd Hotel-Web
   ```

2. Start the application using Docker Compose:

   ```bash
   docker-compose up --build
   ```

3. Access the application:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:9192
   - Database: localhost:3306

## Local Development Setup

### Backend Setup

1. Navigate to backend directory:

   ```bash
   cd backend
   ```

2. Ensure Java 21 is installed.

3. Run the application:
   ```bash
   ./mvnw spring-boot:run
   ```

### Frontend Setup

1. Navigate to frontend directory:

   ```bash
   cd fontend
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

### Database Setup

Use the provided `docker-compose.yml` to run MySQL, or set up locally.

## Docker Images

The project includes Dockerfiles for containerization:

- **Backend**: `tcuong2003/hotel_booking:backend-latest`
- **Frontend**: `tcuong2003/hotel_booking:frontend-latest`
- **Database**: MySQL 8.0 (from Docker Hub)

To build and push images:

```bash
# Build backend
cd backend
docker build -t tcuong2003/hotel_booking:backend-latest .

# Build frontend
cd ../fontend
docker build -t tcuong2003/hotel_booking:frontend-latest .

# Push to Docker Hub
docker push tcuong2003/hotel_booking:backend-latest
docker push tcuong2003/hotel_booking:frontend-latest
```

## Deployment

### Vercel (Frontend)

1. Push the frontend code to a Git repository.
2. Connect the repository to Vercel.
3. Set build settings:
   - Build Command: `npm run build`
   - Output Directory: `dist`
   - Install Command: `npm install`

### Backend Deployment

Deploy the backend to a cloud platform like Heroku, Azure, or AWS.

## API Documentation

The backend provides RESTful APIs for:

- User management
- Room operations
- Booking management

Base URL: `http://localhost:9192/api`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.
