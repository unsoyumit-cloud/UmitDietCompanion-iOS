# ADR-012 — Personalized Nutrition Scoring & Energy Balance

## Status

Accepted

## Date

2026-08-28

## Context

Ümit Diet Companion currently collects nutrition data from logged meals and health/activity data from Apple Health.

Meal analysis provides:

- Calories
- Protein
- Carbohydrates
- Fat
- Fiber

Health data provides:

- Active Calories
- Resting Calories
- Weight
- Activity data
- Other daily health metrics

The current Nutrition ring and Daily Health Score do not yet consume the user's actual daily nutrition intake. The `DailyHealthMetrics.calorieIntake` field currently exists but is not populated from the Nutrition data source.

Nutrition must therefore become a first-class component of the health model rather than remaining an isolated meal-tracking feature.

The system should also distinguish between:

1. What the user consumes
2. What the user expends
3. The resulting energy balance
4. Whether the resulting balance is appropriate in the context of the user's goal
5. Why the balance occurred
6. What action the user could reasonably take next

The system must avoid unnecessary AI calls. Deterministic calculations should be performed locally, while AI should primarily be used for interpretation, explanation and contextual coaching.

---

## Decision

### 1. Personalized Nutrition Targets

Nutrition targets will be personalized using the user's profile and goals.

Relevant profile inputs include:

- Sex
- Age
- Height
- Current weight
- Activity level
- Weight goal
- Relevant lifestyle/activity context

The system will generate a daily nutrition profile containing at least:

- Calorie target
- Protein target
- Carbohydrate target
- Fat target
- Fiber target

Targets are not hard-coded as identical values for every user.

---

## 2. Protein Target

Protein will primarily be calculated

