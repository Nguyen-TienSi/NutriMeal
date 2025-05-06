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
  unActive,
  normal,
  active;

  @override
  String toString() {
    return switch (this) {
      ActivityLevel.unActive => 'inactive',
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
