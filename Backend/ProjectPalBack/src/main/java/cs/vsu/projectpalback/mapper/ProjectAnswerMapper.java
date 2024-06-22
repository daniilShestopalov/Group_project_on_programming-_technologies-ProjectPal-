package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.ProjectAnswerDTO;
import cs.vsu.projectpalback.model.Project;
import cs.vsu.projectpalback.model.ProjectAnswer;
import cs.vsu.projectpalback.repository.ProjectRepository;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", uses = ProjectRepository.class)
public abstract class ProjectAnswerMapper {

    @Autowired
    protected ProjectRepository projectRepository;

    @Mapping(source = "project.id", target = "projectId")
    public abstract ProjectAnswerDTO toDto(ProjectAnswer projectAnswer);

    @Mapping(source = "projectId", target = "project", qualifiedByName = "projectFromId")
    public abstract ProjectAnswer toEntity(ProjectAnswerDTO projectAnswerDTO);

    public abstract List<ProjectAnswerDTO> toDtoList(List<ProjectAnswer> projectAnswerList);

    public abstract List<ProjectAnswer> toEntityList(List<ProjectAnswerDTO> projectAnswerDTOList);

    @Mapping(target = "project", source = "projectId", qualifiedByName = "projectFromId")
    public abstract void updateEntityFromDto(ProjectAnswerDTO dto, @MappingTarget ProjectAnswer entity);

    @Named("projectFromId")
    protected Project projectFromId(int id) {
        return projectRepository.findById(id).orElse(null);
    }
}
