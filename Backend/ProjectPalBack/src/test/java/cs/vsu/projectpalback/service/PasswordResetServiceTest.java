package cs.vsu.projectpalback.service;

import org.junit.jupiter.api.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;

import static org.junit.jupiter.api.Assertions.assertThrows;

@RunWith(SpringRunner.class)
@SpringBootTest
@ActiveProfiles("test")
@Rollback(true)
public class PasswordResetServiceTest {

    @Autowired
    private PasswordResetService passwordResetService;

    @Test
    public void sendPasswordReset_InvalidEmail() {
        String invalidEmail = "invalid@example.com";
        assertThrows(RuntimeException.class, () -> passwordResetService.sendPasswordReset(invalidEmail));
    }
}
