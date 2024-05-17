package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.model.enumerate.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByLogin(String login);
    List<User> findByGroupId(Integer groupId);
    List<User> findByRole(Role role);
    long countByGroupId(Integer groupId);

}
