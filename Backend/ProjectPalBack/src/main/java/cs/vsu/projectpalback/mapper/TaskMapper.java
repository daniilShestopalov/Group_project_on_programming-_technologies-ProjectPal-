package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.TaskDTO;
import cs.vsu.projectpalback.model.Task;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TaskMapper {

    TaskDTO toDto(Task task);

    Task toEntity(TaskDTO taskDTO);

    List<TaskDTO> toDtoList(List<Task> tasks);

    List<Task> toEntityList(List<TaskDTO> taskDTOs);

}
