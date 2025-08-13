package com.genie.quiz;

// ADDED: Necessary imports for the new functionality
import com.genie.quiz.entity.User;
import com.genie.quiz.repo.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class QuizApplication {

	public static void main(String[] args) {
		SpringApplication.run(QuizApplication.class, args);
	}

	// ADDED: This entire @Bean method
	/**
	 * This CommandLineRunner bean will run once when the application starts.
	 * It checks if an "admin" user exists. If not, it creates one with a
	 * default password and the "ADMIN" role.
	 */
	@Bean
	public CommandLineRunner  createAdminUser(UserRepository userRepository, PasswordEncoder passwordEncoder) {
		return args -> {
			// Check if an admin user already exists
			if (userRepository.findByUsername("admin").isEmpty()) {
				User admin = new User();
				admin.setUsername("admin");
				admin.setEmail("admin@quizapp.com");
				// IMPORTANT: Use a strong, secure password in a real application!
				admin.setPassword(passwordEncoder.encode("adminpass"));
				admin.setRole("ADMIN");
				admin.setProfileImageUrl("https://res.cloudinary.com/dmzlgshmw/image/upload/v1754414878/7e30aa62-6740-4b3f-b27b-0ba94544c14f.jpg"); // No default image for the admin

				userRepository.save(admin);
				System.out.println(">>> Default ADMIN user created. Username: 'admin', Password: 'adminpass' <<<");
			}
		};
	}
}