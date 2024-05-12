package cs.vsu.projectpalback.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ComplaintDTO {

    private int id;

    @NotNull(message = "Sender user id cannot be null")
    private int complaintSenderUserId;

    @NotNull(message = "Complained about user id cannot be null")
    private int complainedAboutUserId;

}
