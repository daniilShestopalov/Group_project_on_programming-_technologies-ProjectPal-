package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.TaskAnswerDTO;
import cs.vsu.projectpalback.model.Task;
import cs.vsu.projectpalback.model.TaskAnswer;
import cs.vsu.projectpalback.model.User;
import cs.vsu.projectpalback.repository.TaskRepository;
import cs.vsu.projectpalback.repository.UserRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", uses = {TaskRepository.class, UserRepository.class})
public abstract class TaskAnswerMapper {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private UserRepository userRepository;

    @Mapping(source = "task.id", target = "taskId")
    @Mapping(source = "student.id", target = "studentUserId")
    public abstract TaskAnswerDTO toDto(TaskAnswer taskAnswer);

    @Mapping(source = "taskId", target = "task", qualifiedByName = "taskFromId")
    @Mapping(source = "studentUserId", target = "student", qualifiedByName = "userFromId")
    public abstract TaskAnswer toEntity(TaskAnswerDTO taskAnswerDTO);

    public abstract List<TaskAnswerDTO> toDtoList(List<TaskAnswer> taskAnswerList);

    public abstract List<TaskAnswer> toEntityList(List<TaskAnswerDTO> taskAnswerDTOList);

    @Mapping(source = "taskId", target = "task", qualifiedByName = "taskFromId")
    @Mapping(source = "studentUserId", target = "student", qualifiedByName = "userFromId")
    public abstract void updateEntityFromDto(TaskAnswerDTO dto, @MappingTarget TaskAnswer entity);

    @Named("taskFromId")
    protected Task taskFromId(int id) {
        return taskRepository.findById(id).orElse(null);
    }

    @Named("userFromId")
    protected User userFromId(int id) {
        return userRepository.findById(id).orElse(null);
    }
}
