package com.tc.backend.config;

import com.tc.backend.model.Role;
import com.tc.backend.model.Room;
import com.tc.backend.model.User;
import com.tc.backend.repository.IRoleRepository;
import com.tc.backend.repository.IRoomRepository;
import com.tc.backend.repository.IUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

@Component
@RequiredArgsConstructor
public class DataSeeder implements CommandLineRunner {
    private final IRoleRepository roleRepository;
    private final IRoomRepository roomRepository;
    private final IUserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        seedRoles();
        seedRooms();
        seedTestUser();
    }

    private void seedRoles() {
        if (!roleRepository.existsByName("ROLE_USER")) {
            Role userRole = new Role("ROLE_USER");
            roleRepository.save(userRole);
        }
        if (!roleRepository.existsByName("ROLE_ADMIN")) {
            Role adminRole = new Role("ROLE_ADMIN");
            roleRepository.save(adminRole);
        }
        System.out.println("✓ Roles seeded successfully");
    }

    private void seedRooms() {
        // Danh sách các phòng cần có
        List<String> requiredRoomTypes = Arrays.asList(
            "Standard", "Superior", "Deluxe", "Suite",
            "Single Bedroom", "Double Bedroom", "Twin Bedroom", "Triple Bedroom",
            "Family Room", "City View", "Ocean View", "Sea View",
            "Garden View", "Lake View", "Balcony Room", "Jacuzzi Room",
            "Pool Villa", "Connecting Room", "Extra Bed"
        );
        
        // Kiểm tra và tạo các phòng còn thiếu
        int createdCount = 0;
        for (String roomType : requiredRoomTypes) {
            boolean exists = roomRepository.findAll().stream()
                .anyMatch(room -> room.getRoomType().equals(roomType));
            
            if (!exists) {
                BigDecimal price = getPriceForRoomType(roomType);
                Room room = createRoom(roomType, price);
                roomRepository.save(room);
                createdCount++;
            }
        }
        
        if (createdCount > 0) {
            System.out.println("✓ Created " + createdCount + " missing rooms");
        }
        
        long totalRooms = roomRepository.count();
        if (totalRooms >= requiredRoomTypes.size()) {
            System.out.println("✓ Total " + totalRooms + " rooms available");
        } else {
            System.out.println("⚠️  Warning: Only " + totalRooms + " rooms found, expected " + requiredRoomTypes.size());
        }
    }
    
    private BigDecimal getPriceForRoomType(String roomType) {
        return switch (roomType) {
            case "Standard" -> new BigDecimal("50.00");
            case "Superior" -> new BigDecimal("75.00");
            case "Deluxe" -> new BigDecimal("100.00");
            case "Suite" -> new BigDecimal("150.00");
            case "Single Bedroom" -> new BigDecimal("45.00");
            case "Double Bedroom" -> new BigDecimal("65.00");
            case "Twin Bedroom" -> new BigDecimal("65.00");
            case "Triple Bedroom" -> new BigDecimal("85.00");
            case "Family Room" -> new BigDecimal("120.00");
            case "City View" -> new BigDecimal("80.00");
            case "Ocean View" -> new BigDecimal("110.00");
            case "Sea View" -> new BigDecimal("105.00");
            case "Garden View" -> new BigDecimal("70.00");
            case "Lake View" -> new BigDecimal("90.00");
            case "Balcony Room" -> new BigDecimal("95.00");
            case "Jacuzzi Room" -> new BigDecimal("130.00");
            case "Pool Villa" -> new BigDecimal("200.00");
            case "Connecting Room" -> new BigDecimal("140.00");
            case "Extra Bed" -> new BigDecimal("60.00");
            default -> new BigDecimal("50.00");
        };
    }

    private Room createRoom(String roomType, BigDecimal price) {
        Room room = new Room();
        room.setRoomType(roomType);
        room.setRoomPrice(price);
        room.setBooked(false);
        return room;
    }

    private void seedTestUser() {
        // Tạo/Update test user
        User testUser = userRepository.findByEmail("test@hotel.com").orElse(null);
        if (testUser == null) {
            testUser = new User();
            testUser.setEmail("test@hotel.com");
            testUser.setFirstName("Test");
            testUser.setLastName("User");
        }
        testUser.setPassword(passwordEncoder.encode("123456"));
        
        // Lấy role và chỉ set reference, không persist
        Role userRole = roleRepository.findByName("ROLE_USER").orElse(null);
        if (userRole != null) {
            // Clear existing roles và set role mới
            if (testUser.getRoles() == null) {
                testUser.setRoles(new HashSet<>());
            }
            testUser.getRoles().clear();
            testUser.getRoles().add(userRole);
        }
        userRepository.save(testUser);
        System.out.println("✓ Test user ready: test@hotel.com / 123456");
        
        // Tạo/Update admin user
        User adminUser = userRepository.findByEmail("admin@hotel.com").orElse(null);
        if (adminUser == null) {
            adminUser = new User();
            adminUser.setEmail("admin@hotel.com");
            adminUser.setFirstName("Admin");
            adminUser.setLastName("User");
        }
        adminUser.setPassword(passwordEncoder.encode("admin123"));
        
        Role adminRole = roleRepository.findByName("ROLE_ADMIN").orElse(null);
        if (adminRole != null) {
            if (adminUser.getRoles() == null) {
                adminUser.setRoles(new HashSet<>());
            }
            // Kiểm tra xem đã có admin role chưa
            boolean hasAdminRole = adminUser.getRoles().stream()
                .anyMatch(r -> r.getName().equals("ROLE_ADMIN"));
            if (!hasAdminRole) {
                adminUser.getRoles().clear();
                adminUser.getRoles().add(adminRole);
            }
        }
        userRepository.save(adminUser);
        System.out.println("✓ Admin user ready: admin@hotel.com / admin123");
    }
}

