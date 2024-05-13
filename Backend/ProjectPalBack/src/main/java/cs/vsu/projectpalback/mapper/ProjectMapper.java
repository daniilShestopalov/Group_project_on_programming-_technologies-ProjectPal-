package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.ProjectDTO;
import cs.vsu.projectpalback.model.Project;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ProjectMapper {

    ProjectDTO toDto(Project project);

    Project toEntity(ProjectDTO projectDTO);

    List<ProjectDTO> toDtoList(List<Project> projects);

    List<Project> toEntityList(List<ProjectDTO> projectDTOs);

}
