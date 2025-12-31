// Utility function để map roomType với image path từ assets
// Import images
import standardImg from "../assets/room_images/standard.jpg";
import superiorImg from "../assets/room_images/superior.jpg";
import deluxeImg from "../assets/room_images/deluxe.jpg";
import suiteImg from "../assets/room_images/suite.jpg";
import singleBedroomImg from "../assets/room_images/single_bedroom.jpg";
import doubleBedroomImg from "../assets/room_images/double_bedroom.jpg";
import twinBedroomImg from "../assets/room_images/twin_bedroom.jpg";
import tripleBedroomImg from "../assets/room_images/triple_bedroom.jpg";
import familyRoomImg from "../assets/room_images/family_room.jpg";
import cityViewImg from "../assets/room_images/city_view.jpg";
import oceanViewImg from "../assets/room_images/ocean_view.jpg";
import seaViewImg from "../assets/room_images/sea_view.jpg";
import gardenViewImg from "../assets/room_images/garden_view.jpg";
import lakeViewImg from "../assets/room_images/lake_view.jpg";
import balconyRoomImg from "../assets/room_images/balcony_room.jpg";
import jacuzziRoomImg from "../assets/room_images/jacuzzi_room.jpg";
import poolVillaImg from "../assets/room_images/pool_villa.jpg";
import connectingRoomImg from "../assets/room_images/connecting_room.jpg";
import extraBedImg from "../assets/room_images/extra_bed.jpg";

const roomImageMapImports = {
  "Standard": standardImg,
  "Superior": superiorImg,
  "Deluxe": deluxeImg,
  "Suite": suiteImg,
  "Single Bedroom": singleBedroomImg,
  "Double Bedroom": doubleBedroomImg,
  "Twin Bedroom": twinBedroomImg,
  "Triple Bedroom": tripleBedroomImg,
  "Family Room": familyRoomImg,
  "City View": cityViewImg,
  "Ocean View": oceanViewImg,
  "Sea View": seaViewImg,
  "Garden View": gardenViewImg,
  "Lake View": lakeViewImg,
  "Balcony Room": balconyRoomImg,
  "Jacuzzi Room": jacuzziRoomImg,
  "Pool Villa": poolVillaImg,
  "Connecting Room": connectingRoomImg,
  "Extra Bed": extraBedImg,
};

/**
 * Lấy đường dẫn ảnh cho room type
 * @param {string} roomType - Loại phòng
 * @returns {string} - Đường dẫn ảnh
 */
export const getRoomImage = (roomType) => {
  return roomImageMapImports[roomType] || standardImg; // Default to standard nếu không tìm thấy
};

/**
 * Lấy src ảnh cho room (ưu tiên photo từ backend, nếu không có thì dùng ảnh mặc định)
 * @param {object} room - Room object
 * @returns {string} - URL của ảnh
 */
export const getRoomImageSrc = (room) => {
  if (room && room.photo && room.photo.trim() !== "" && room.photo !== null && room.photo !== "null") {
    return `data:image/png;base64, ${room.photo}`;
  }
  if (room && room.roomType) {
    return getRoomImage(room.roomType);
  }
  return getRoomImage("Standard"); // Fallback
};

