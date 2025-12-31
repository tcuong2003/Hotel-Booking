#!/bin/bash

# Script to build and push Docker images for Hotel Booking project

echo "Starting Docker build and push process..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker daemon is not running. Please start Docker Desktop first."
    exit 1
fi

# Check if logged into Docker Hub
echo "Checking Docker Hub login..."
if ! docker info | grep -q "Username"; then
    echo "Warning: May not be logged into Docker Hub. Please ensure you run 'docker login' first."
    echo "Continuing anyway..."
fi

# Build backend image
echo "Building backend image..."
cd backend
docker build -t tcuong2003/hotel_booking:backend-latest .
if [ $? -ne 0 ]; then
    echo "Error: Failed to build backend image"
    exit 1
fi

# Build frontend image
echo "Building frontend image..."
cd ../fontend
docker build -t tcuong2003/hotel_booking:frontend-latest .
if [ $? -ne 0 ]; then
    echo "Error: Failed to build frontend image"
    exit 1
fi

# Push images
echo "Pushing backend image..."
docker push tcuong2003/hotel_booking:backend-latest
if [ $? -ne 0 ]; then
    echo "Error: Failed to push backend image"
    exit 1
fi

echo "Pushing frontend image..."
docker push tcuong2003/hotel_booking:frontend-latest
if [ $? -ne 0 ]; then
    echo "Error: Failed to push frontend image"
    exit 1
fi

echo "Success! Images pushed to Docker Hub:"
echo "- tcuong2003/hotel_booking:backend-latest"
echo "- tcuong2003/hotel_booking:frontend-latest"