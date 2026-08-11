struct LearnedProfile {

    // MARK: - Daily Patterns

    var preferredWalkHour: Int?

    var preferredWorkoutHour: Int?

    var preferredSleepHour: Int?

    var preferredWakeHour: Int?

    // MARK: - Nutrition

    var hydrationPattern: HydrationPattern?

    var mealPattern: MealPattern?

    // MARK: - Lifestyle

    var officeDays: Set<Weekday> = []

    var travelFrequency: TravelFrequency = .unknown

    // MARK: - Coaching

    var respondsBetterToCelebration = false

    var respondsBetterToChallenges = false

    var needsFrequentReminders = false

}
