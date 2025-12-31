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
import java.util.Collections;
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
        if (roleRepository.count() == 0) {
            Role userRole = new Role("ROLE_USER");
            Role adminRole = new Role("ROLE_ADMIN");
            roleRepository.saveAll(Arrays.asList(userRole, adminRole));
            System.out.println("✓ Roles seeded successfully");
        }
    }

    private void seedRooms() {
        if (roomRepository.count() == 0) {
            List<Room> sampleRooms = Arrays.asList(
                createRoom("Standard", new BigDecimal("50.00")),
                createRoom("Superior", new BigDecimal("75.00")),
                createRoom("Deluxe", new BigDecimal("100.00")),
                createRoom("Suite", new BigDecimal("150.00")),
                createRoom("Single Bedroom", new BigDecimal("45.00")),
                createRoom("Double Bedroom", new BigDecimal("65.00")),
                createRoom("Twin Bedroom", new BigDecimal("65.00")),
                createRoom("Triple Bedroom", new BigDecimal("85.00")),
                createRoom("Family Room", new BigDecimal("120.00")),
                createRoom("City View", new BigDecimal("80.00")),
                createRoom("Ocean View", new BigDecimal("110.00")),
                createRoom("Sea View", new BigDecimal("105.00")),
                createRoom("Garden View", new BigDecimal("70.00")),
                createRoom("Lake View", new BigDecimal("90.00")),
                createRoom("Balcony Room", new BigDecimal("95.00")),
                createRoom("Jacuzzi Room", new BigDecimal("130.00")),
                createRoom("Pool Villa", new BigDecimal("200.00")),
                createRoom("Connecting Room", new BigDecimal("140.00")),
                createRoom("Extra Bed", new BigDecimal("60.00"))
            );
            roomRepository.saveAll(sampleRooms);
            System.out.println("✓ " + sampleRooms.size() + " rooms seeded successfully");
        }
    }

    private Room createRoom(String roomType, BigDecimal price) {
        Room room = new Room();
        room.setRoomType(roomType);
        room.setRoomPrice(price);
        room.setBooked(false);
        return room;
    }

    private void seedTestUser() {
        if (!userRepository.existsByEmail("test@hotel.com")) {
            User testUser = new User();
            testUser.setEmail("test@hotel.com");
            testUser.setPassword(passwordEncoder.encode("123456"));
            testUser.setFirstName("Test");
            testUser.setLastName("User");
            Role userRole = roleRepository.findByName("ROLE_USER").orElse(null);
            if (userRole != null) {
                testUser.setRoles(Collections.singletonList(userRole));
            }
            userRepository.save(testUser);
            System.out.println("✓ Test user created: test@hotel.com / 123456");
        }
    }
}

