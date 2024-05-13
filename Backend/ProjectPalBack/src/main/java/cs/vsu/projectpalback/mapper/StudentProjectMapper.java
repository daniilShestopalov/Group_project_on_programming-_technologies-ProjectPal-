package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.StudentProjectDTO;
import cs.vsu.projectpalback.model.StudentProject;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface StudentProjectMapper {

    StudentProjectDTO toDto(StudentProject studentProject);

    StudentProject toEntity(StudentProjectDTO studentProjectDTO);

    List<StudentProjectDTO> toDtoList(List<StudentProject> studentProjectList);

    List<StudentProject> toEntityList(List<StudentProjectDTO> studentProjectDTOList);

}
