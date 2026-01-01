import axios from "axios"; //thư viện js gọi các API của backend kết hợp với giao diện
//dữ liệu được gửi đi hay lấy ra thường là kiểu JSON (tự động chuyển đổi dữ liệu)
//axios tạo url mặc định của bankend
// export const api = axios.create({
//     baseURL: 'http://localhost:9192'
// })
const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
});
console.log("API Base URL:", import.meta.env.VITE_API_BASE_URL);

export default api;

export const getHeader = () => {
  const token = localStorage.getItem("token");
  return {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  };
};

export async function addRoom(photo, roomType, roomPrice) {
  const formData = new FormData(); //FormData là tạo và xử lý dữ liệu, được gửi qua HTTP, quản lí dưới dạng key-value, thường sử dụng có các dữ liệu đa phương tiện (hình ảnh, âm thanh)
  formData.append("photo", photo); //thêm dữ liệu vào dưới dạng key, value
  formData.append("roomType", roomType);
  formData.append("roomPrice", roomPrice);

  const response = await api.post("/rooms/add/new-room", formData);
  if (response.status >= 200 && response.status < 300) {
    //mã trạng thái 200-299 là thành công
    return true;
  } else {
    return false;
  }
}

export async function getRoomTypes() {
  try {
    const response = await api.get("/rooms/room/types"); //lấy dữ liệu
    return response.data; //trả về data
  } catch (error) {
    throw new Error("Error fetching room types");
  }
}

export async function getAllRooms() {
  try {
    const result = await api.get("/rooms/all-rooms");
    return result.data;
  } catch (error) {
    console.error("Error fetching rooms:", error);
    if (error.response) {
      // Server responded with error status
      throw new Error(
        `Error fetching rooms: ${error.response.status} - ${
          error.response.data?.message || error.response.statusText
        }`
      );
    } else if (error.request) {
      // Request made but no response received
      throw new Error(
        "Backend chưa chạy! Vui lòng khởi động backend trước:\n\n1. Mở terminal và chạy:\n   cd Hotel-Web\n   ./START_BACKEND.sh\n\n2. Hoặc:\n   cd Hotel-Web/backend\n   ./mvnw spring-boot:run\n\n3. Đợi backend khởi động xong (thấy 'Started BackendApplication')\n4. Refresh trang này"
      );
    } else {
      // Error setting up request
      throw new Error(`Error fetching rooms: ${error.message}`);
    }
  }
}

export async function deleteRoom(roomId) {
  try {
    const result = await api.delete(`/rooms/delete/room/${roomId}`);
    return result.data;
  } catch (error) {
    throw new Error(`Error deleting room ${error.message}`);
  }
}

export async function updateRoom(roomId, roomData) {
  const formData = new FormData();
  formData.append("roomType", roomData.roomType);
  formData.append("roomPrice", roomData.roomPrice);
  formData.append("photo", roomData.photo);
  const response = await api.put(`/rooms/update/${roomId}`, formData);
  // const response = await api.put(`/update/${roomId}`, formData, {
  // 	headers: getHeader()
  // })
  return response;
}

export async function getRoomById(roomId) {
  try {
    const result = await api.get(`/rooms/room/${roomId}`);
    return result.data;
  } catch (error) {
    throw new Error(`Error fetching room ${error.message}`);
  }
}

export async function bookRoom(roomId, booking) {
  try {
    const response = await api.post(
      `/bookings/room/${roomId}/booking`,
      booking
    );
    return response.data;
  } catch (error) {
    if (error.response && error.response.data) {
      throw new Error(error.response.data);
    } else {
      throw new Error(`Error booking room : ${error.message}`);
    }
  }
}

export async function getAllBookings() {
  try {
    const result = await api.get("/bookings/all-bookings", {
      // headers: getHeader()
    });
    return result.data;
  } catch (error) {
    throw new Error(`Error fetching bookings : ${error.message}`);
  }
}

export async function getBookingByConfirmationCode(confirmationCode) {
  try {
    const result = await api.get(`/bookings/confirmation/${confirmationCode}`);
    return result.data;
  } catch (error) {
    if (error.response && error.response.data) {
      throw new Error(error.response.data);
    } else {
      throw new Error(`Error find booking : ${error.message}`);
    }
  }
}

export async function cancelBooking(bookingId) {
  try {
    const result = await api.delete(`/bookings/booking/${bookingId}/delete`);
    return result.data;
  } catch (error) {
    throw new Error(`Error cancelling booking :${error.message}`);
  }
}

/* This function gets all availavle rooms from the database with a given date and a room type */
export async function getAvailableRooms(checkInDate, checkOutDate, roomType) {
  try {
    const result = await api.get(
      `/rooms/available-rooms?checkInDate=${checkInDate}&checkOutDate=${checkOutDate}&roomType=${roomType}`
    );
    return result;
  } catch (error) {
    if (error.response && error.response.data) {
      throw new Error(error.response.data);
    } else {
      throw new Error(`Error fetching available rooms: ${error.message}`);
    }
  }
}

/* This function register a new user */
export async function registerUser(registration) {
  try {
    const response = await api.post("/auth/register-user", registration);
    return response.data;
  } catch (error) {
    if (error.response && error.response.data) {
      throw new Error(error.response.data);
    } else {
      throw new Error(`User registration error : ${error.message}`);
    }
  }
}

/* This function login a registered user */
export async function loginUser(login) {
  try {
    const response = await api.post("/auth/login", login);
    if (response.status >= 200 && response.status < 300) {
      return response.data;
    } else {
      return null;
    }
  } catch (error) {
    console.error("Login error:", error);
    if (error.response) {
      // Server responded with error status
      const errorMessage =
        error.response.data?.message ||
        error.response.data ||
        `Login failed: ${error.response.status}`;
      throw new Error(errorMessage);
    } else if (error.request) {
      // Request made but no response received
      throw new Error(
        "No response from server. Please check if the backend is running."
      );
    } else {
      // Error setting up request
      throw new Error(`Login error: ${error.message}`);
    }
  }
}

/*  This is function to get the user profile */
export async function getUserProfile(userId, token) {
  try {
    const response = await api.get(`/users/profile/${userId}`, {
      headers: getHeader(),
    });
    return response.data;
  } catch (error) {
    throw error;
  }
}

/* This isthe function to delete a user */
export async function deleteUser(userId) {
  try {
    const response = await api.delete(`/users/delete/${userId}`, {
      headers: getHeader(),
    });
    return response.data;
  } catch (error) {
    return error.message;
  }
}

/* This is the function to get a single user */
export async function getUser(userId, token) {
  try {
    const response = await api.get(`/users/${userId}`, {
      headers: getHeader(),
    });
    return response.data;
  } catch (error) {
    throw error;
  }
}

/* This is the function to get user bookings by the user id */
export async function getBookingsByUserId(userId, token) {
  try {
    const response = await api.get(`/bookings/user/${userId}/bookings`, {
      headers: getHeader(),
    });
    return response.data;
  } catch (error) {
    console.error("Error fetching bookings:", error.message);
    throw new Error("Failed to fetch bookings");
  }
}
