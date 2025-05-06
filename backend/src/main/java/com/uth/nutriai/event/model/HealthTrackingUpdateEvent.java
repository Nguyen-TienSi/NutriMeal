package com.uth.nutriai.event.model;

import com.uth.nutriai.dto.internal.MealLogUpdateDto;
import lombok.Getter;
import lombok.Setter;
import org.springframework.context.ApplicationEvent;

@Getter
@Setter
public class HealthTrackingUpdateEvent extends ApplicationEvent {

    private MealLogUpdateDto mealLogUpdateDto;

    public HealthTrackingUpdateEvent(Object source, MealLogUpdateDto mealLogUpdateDto) {
        super(source);
        this.mealLogUpdateDto = mealLogUpdateDto;
    }
}
