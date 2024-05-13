package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.ComplaintDTO;
import cs.vsu.projectpalback.model.Complaint;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ComplaintMapper {

    ComplaintDTO toDto(Complaint complaint);

    Complaint toEntity(ComplaintDTO complaintDTO);

    List<ComplaintDTO> toDtoList(List<Complaint> complaints);

    List<Complaint> toEntityList(List<ComplaintDTO> complaintDTOs);

}
