package com.uth.nutriai.seeding;

import com.uth.nutriai.model.entity.DietPreference;
import com.uth.nutriai.model.entity.User;
import com.uth.nutriai.model.enumuration.ActivityLevel;
import com.uth.nutriai.model.enumuration.Goal;
import com.uth.nutriai.repository.IUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class UserSeeder implements CommandLineRunner {

    private final IUserRepository userRepository;

    @Override
    public void run(String... args) {
        if (userRepository.count() == 0) { // Kiểm tra nếu collection rỗng
            seedUsers();
        }
    }

    private void seedUsers() {
        // Tạo danh sách DietPreferences nếu chưa có
        List<DietPreference> dietPreferences = createDietPreferences();

        // Tạo một user mẫu
        User user = new User();
        user.setAge(25);
        user.setWeight(70.5f);
        user.setHeight(175.0f);
        user.setActivityLevel(ActivityLevel.NORMAL);
        user.setGoal(Goal.MAINTAIN);
        user.setDietPreferences(dietPreferences);

        userRepository.save(user);
        System.out.println("✅ User seeding completed!");
    }

    private List<DietPreference> createDietPreferences() {
        return null;
    }
}
