package cs.vsu.projectpalback.security;

import cs.vsu.projectpalback.model.User;
import io.jsonwebtoken.*;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.validation.constraints.NotNull;
import lombok.NonNull;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;

@Component
public class JwtProvider {
    private final SecretKey jwtAccessSecret;

    public JwtProvider(@Value("${jwt.secret}") String jwtAccessSecret) {
        this.jwtAccessSecret = Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtAccessSecret));
    }

    public String generateToken(@NotNull User user) {
        return Jwts.builder()
                .subject(user.getLogin())
                .signWith(jwtAccessSecret)
                .claim("role", user.getRole())
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
            //TODO: логироание Unsupported jwt
        } catch (MalformedJwtException mjEx) {
            //TODO: логироание Malformed jwt
        } catch (Exception e) {
            //TODO: логироание invalid token
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
}
