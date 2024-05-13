package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.model.Group;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface GroupMapper {

    GroupDTO toDto(Group group);

    Group toEntity(GroupDTO groupDTO);

    List<GroupDTO> toDtoList(List<Group> groups);

    List<Group> toEntityList(List<GroupDTO> groupDTOs);

}
