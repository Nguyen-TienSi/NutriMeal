enum Gender {
  male,
  female,
  other;

  @override
  String toString() {
    return switch (this) {
      Gender.male => 'male',
      Gender.female => 'female',
      Gender.other => 'other',
    };
  }
}

enum ActivityLevel {
  inActive,
  normal,
  active;

  @override
  String toString() {
    return switch (this) {
      ActivityLevel.inActive => 'inactive',
      ActivityLevel.normal => 'normal',
      ActivityLevel.active => 'active',
    };
  }
}

enum MealPlanStatus { pending, active, completed, canceled }

enum HealthGoal {
  weightLoss,
  weightGain,
  maintain;

  @override
  String toString() {
    return switch (this) {
      HealthGoal.weightLoss => 'weight_loss',
      HealthGoal.weightGain => 'weight_gain',
      HealthGoal.maintain => 'maintain',
    };
  }
}

enum TimeOfDay {
  morning,
  noon,
  afternoon,
  evening,
  night;

  @override
  String toString() {
    return switch (this) {
      TimeOfDay.morning => 'morning',
      TimeOfDay.noon => 'noon',
      TimeOfDay.afternoon => 'afternoon',
      TimeOfDay.evening => 'evening',
      TimeOfDay.night => 'night',
    };
  }
}
