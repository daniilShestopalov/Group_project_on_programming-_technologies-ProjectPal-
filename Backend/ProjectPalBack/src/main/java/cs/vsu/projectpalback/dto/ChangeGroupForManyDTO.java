package cs.vsu.projectpalback.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class ChangeGroupForManyDTO {

    private List<Integer> userIds;

    private Integer groupId;

}
