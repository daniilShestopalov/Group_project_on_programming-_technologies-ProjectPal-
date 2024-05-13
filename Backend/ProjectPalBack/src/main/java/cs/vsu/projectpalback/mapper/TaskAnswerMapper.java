package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.TaskAnswerDTO;
import cs.vsu.projectpalback.model.TaskAnswer;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TaskAnswerMapper {

    TaskAnswerDTO toDto(TaskAnswer taskAnswer);

    TaskAnswer toEntity(TaskAnswerDTO taskAnswerDTO);

    List<TaskAnswerDTO> toDtoList(List<TaskAnswer> taskAnswerList);

    List<TaskAnswer> toEntityList(List<TaskAnswerDTO> taskAnswerDTOList);

}
