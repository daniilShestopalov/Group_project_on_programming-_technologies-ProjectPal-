package cs.vsu.projectpalback.repository;

import cs.vsu.projectpalback.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
    //TODO: поиск по логину
    //TODO: поиск по группе
    //TODO: поиск по роли
    //TODO: CRUD

}
