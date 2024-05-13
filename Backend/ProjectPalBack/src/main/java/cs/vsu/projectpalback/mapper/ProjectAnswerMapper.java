package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.ProjectAnswerDTO;
import cs.vsu.projectpalback.model.ProjectAnswer;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ProjectAnswerMapper {

    ProjectAnswerDTO toDto(ProjectAnswer projectAnswer);

    ProjectAnswer toEntity(ProjectAnswerDTO projectAnswerDTO);

    List<ProjectAnswerDTO> toDtoList(List<ProjectAnswer> projectAnswerList);

    List<ProjectAnswer> toEntityList(List<ProjectAnswerDTO> projectAnswerDTOList);

}
