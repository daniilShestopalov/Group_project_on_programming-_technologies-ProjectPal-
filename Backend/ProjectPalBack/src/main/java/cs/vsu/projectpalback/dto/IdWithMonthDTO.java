package cs.vsu.projectpalback.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.YearMonth;

@Data
@NoArgsConstructor
public class IdWithMonthDTO {

    private int id;

    @NotNull
    private YearMonth yearMonth;

}
