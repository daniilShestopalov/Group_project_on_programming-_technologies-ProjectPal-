package cs.vsu.projectpalback.security;

import cs.vsu.projectpalback.dto.UserWithoutPasswordDTO;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.validation.constraints.NotNull;
import lombok.NonNull;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

@Component
public class JwtProvider {

    private static final Logger LOGGER = LoggerFactory.getLogger(JwtProvider.class);

    private final SecretKey jwtAccessSecret;

    public JwtProvider(@Value("${jwt.secret}") String jwtAccessSecret) {
        this.jwtAccessSecret = Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtAccessSecret));
    }

    public String generateToken(@NotNull UserWithoutPasswordDTO user) {
        return Jwts.builder()
                .subject(String.valueOf(user.getId()))
                .signWith(jwtAccessSecret)
                .claim("role", user.getRole().name())
                .compact();
    }

    public String generatePasswordResetToken(@NotNull Integer userId) {
        Instant now = Instant.now();
        Instant expiryDate = now.plus(1, ChronoUnit.HOURS); // 1 hour

        return Jwts.builder()
                .subject(String.valueOf(userId))
                .issuedAt(Date.from(now))
                .expiration(Date.from(expiryDate))
                .signWith(jwtAccessSecret)
                .compact();
    }

    public boolean validateAccessToken(@NonNull String accessToken) {
        return validateToken(accessToken, jwtAccessSecret);
    }

    private boolean validateToken(@NonNull String token, @NonNull SecretKey secret) {
        try {
            Jwts.parser()
                    .verifyWith(secret)
                    .build()
                    .parseSignedClaims(token);
            return true;
        } catch (UnsupportedJwtException unsEx) {
            LOGGER.error("Unsupported JWT token: {}", unsEx.getMessage());
        } catch (MalformedJwtException mjEx) {
            LOGGER.error("Malformed JWT token: {}", mjEx.getMessage());
        } catch (Exception e) {
            LOGGER.error("Invalid token: {}", e.getMessage());
        }
        return false;
    }

    public Claims getAccessClaims(@NonNull String token) {
        return getClaims(token);
    }

    private Claims getClaims(@NonNull String token) {
        return Jwts.parser()
                .verifyWith(jwtAccessSecret)
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public Integer getUserIdFromToken(@NonNull String token) {
        Claims claims = getClaims(token);
        return Integer.parseInt(claims.getSubject());
    }
}
