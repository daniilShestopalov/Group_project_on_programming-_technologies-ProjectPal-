package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.GroupDTO;
import cs.vsu.projectpalback.model.Group;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;

import java.util.List;

@Mapper(componentModel = "spring")
public interface GroupMapper {

    @Mapping(target = "id", source = "id")
    GroupDTO toDto(Group group);

    @Mapping(target = "id", source = "id")
    Group toEntity(GroupDTO groupDTO);

    List<GroupDTO> toDtoList(List<Group> groups);

    List<Group> toEntityList(List<GroupDTO> groupDTOs);

    @Mapping(target = "id", source = "id")
    void updateEntityFromDto(GroupDTO groupDTO, @MappingTarget Group group);
}
