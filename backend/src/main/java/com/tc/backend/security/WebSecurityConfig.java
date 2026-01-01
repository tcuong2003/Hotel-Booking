package com.tc.backend.security;

import com.tc.backend.security.jwt.AuthTokenFilter;
import com.tc.backend.security.jwt.JwtAuthEntryPoint;
import com.tc.backend.security.user.HotelUserDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;
import java.util.List;

@Configuration
@RequiredArgsConstructor
@EnableMethodSecurity(securedEnabled = true, jsr250Enabled = true, prePostEnabled = true)
public class WebSecurityConfig {

    private final HotelUserDetailsService userDetailsService;
    private final JwtAuthEntryPoint jwtAuthEntryPoint;

    @Bean
    public AuthTokenFilter authenticationTokenFilter() {
        return new AuthTokenFilter();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        var authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService);
        authProvider.setPasswordEncoder(passwordEncoder());
        return authProvider;
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();

        configuration.setAllowedOriginPatterns(Arrays.asList(
                "http://localhost:*",
                "https://*.vercel.app",
                "https://hotel-booking-chi-six.vercel.app" // domain thật của bạn (nếu muốn cố định)
        ));

        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setExposedHeaders(Arrays.asList("Authorization"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .exceptionHandling(exception -> exception.authenticationEntryPoint(jwtAuthEntryPoint))
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                    // ✅ cho OPTIONS preflight đi qua luôn (cực quan trọng để hết CORS/403)
                    .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

                    // public endpoints
                    .requestMatchers("/auth/**", "/rooms/**", "/bookings/**").permitAll()

                    // admin only
                    .requestMatchers("/roles/**").hasRole("ADMIN")

                    // còn lại phải login
                    .anyRequest().authenticated()
            );

        http.authenticationProvider(authenticationProvider());
        http.addFilterBefore(authenticationTokenFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
// package com.tc.backend.security;

// import com.tc.backend.security.jwt.AuthTokenFilter;
// import com.tc.backend.security.jwt.JwtAuthEntryPoint;
// import com.tc.backend.security.user.HotelUserDetailsService;
// import lombok.RequiredArgsConstructor;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;

// import org.springframework.security.authentication.AuthenticationManager;
// import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
// import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
// import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
// import org.springframework.security.config.http.SessionCreationPolicy;
// import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
// import org.springframework.security.crypto.password.PasswordEncoder;
// import org.springframework.security.web.SecurityFilterChain;
// import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
// import org.springframework.web.cors.CorsConfiguration;
// import org.springframework.web.cors.CorsConfigurationSource;
// import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
// import java.util.Arrays;


// @Configuration
// @RequiredArgsConstructor
// @EnableMethodSecurity(securedEnabled = true, jsr250Enabled = true, prePostEnabled = true)
// public class WebSecurityConfig {
//     private final HotelUserDetailsService userDetailsService;
//     private final JwtAuthEntryPoint jwtAuthEntryPoint;

//     @Bean
//     public AuthTokenFilter authenticationTokenFilter(){
//         return new AuthTokenFilter();
//     }
//     @Bean
//     public PasswordEncoder passwordEncoder() {
//         return new BCryptPasswordEncoder();
//     }

//     @Bean
//     public DaoAuthenticationProvider authenticationProvider() {
//         var authProvider = new DaoAuthenticationProvider();
//         authProvider.setUserDetailsService(userDetailsService);
//         authProvider.setPasswordEncoder(passwordEncoder());
//         return authProvider;
//     }

//     @Bean
//     public AuthenticationManager authenticationManager(AuthenticationConfiguration authConfig) throws Exception {
//         return authConfig.getAuthenticationManager();
//     }

//     @Bean
//     public CorsConfigurationSource corsConfigurationSource() {
//         CorsConfiguration configuration = new CorsConfiguration();
//         configuration.setAllowedOrigins(Arrays.asList(
//                 "http://localhost:5173",
//                 "http://localhost:3000",
//                 "http://localhost:5174",
//                 "http://localhost:5175"
//         ));
//         configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
//         configuration.setAllowedHeaders(Arrays.asList("*"));
//         configuration.setAllowCredentials(true);
//         configuration.setMaxAge(3600L);
//         UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
//         source.registerCorsConfiguration("/**", configuration);
//         return source;
//     }

//     @Bean
//     public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
//         http.csrf(AbstractHttpConfigurer :: disable)
//                 .cors(cors -> cors.configurationSource(corsConfigurationSource()))
//                 .exceptionHandling(
//                         exception -> exception.authenticationEntryPoint(jwtAuthEntryPoint))
//                 .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
//                 .authorizeHttpRequests(auth -> auth
//                         .requestMatchers("/auth/**", "/rooms/**","/bookings/**")
//                         .permitAll().requestMatchers("/roles/**").hasRole("ADMIN")
//                         .anyRequest().authenticated());
//         http.authenticationProvider(authenticationProvider());
//         http.addFilterBefore(authenticationTokenFilter(), UsernamePasswordAuthenticationFilter.class);
//         return http.build();
//     }







// }