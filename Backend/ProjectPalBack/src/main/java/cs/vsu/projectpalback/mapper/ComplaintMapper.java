package cs.vsu.projectpalback.mapper;

import cs.vsu.projectpalback.dto.ComplaintDTO;
import cs.vsu.projectpalback.model.Complaint;
import cs.vsu.projectpalback.repository.UserRepository;
import org.mapstruct.*;
import cs.vsu.projectpalback.model.User;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", uses = UserRepository.class)
public abstract class ComplaintMapper {

    @Autowired
    private UserRepository userRepository;

    @Mappings({
            @Mapping(source = "complaintSender.id", target = "complaintSenderUserId"),
            @Mapping(source = "complainedAbout.id", target = "complainedAboutUserId")
    })
    public abstract ComplaintDTO toDto(Complaint complaint);

    @Mappings({
            @Mapping(source = "complaintSenderUserId", target = "complaintSender", qualifiedByName = "userFromId"),
            @Mapping(source = "complainedAboutUserId", target = "complainedAbout", qualifiedByName = "userFromId")
    })
    public abstract Complaint toEntity(ComplaintDTO complaintDTO);

    public abstract List<ComplaintDTO> toDtoList(List<Complaint> complaints);

    public abstract List<Complaint> toEntityList(List<ComplaintDTO> complaintDTOs);

    @Named("userFromId")
    protected User userFromId(int id) {
        return userRepository.findById(id).orElse(null);
    }
}
