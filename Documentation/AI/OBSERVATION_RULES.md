# Observation Rules

## Purpose

Observation is the first decision layer of the AI.

Its only responsibility is to observe the current health state.

Observation never interprets.

Observation never recommends.

Observation never changes personality.

It simply answers one question:

> "What is happening right now?"

---

# Input

ObservationEngine receives a single object.

```
AIContext
```

The engine only reads data.

It never modifies it.

---

# Output

ObservationEngine produces one or more HealthObservations.

```
AIContext
        │
        ▼
ObservationEngine
        │
        ▼
[HealthObservation]
```

Observations are facts.

Not opinions.

---

# Core Health Domains

Observation only evaluates these health domains.

- Hydration
- Nutrition
- Movement
- Sleep
- Heart
- Weight

No other health domains should exist inside ObservationEngine.

---

# Observation States

Every health domain can generate one observation.

## Hydration

| Progress | Observation |
|----------|-------------|
| < 60% | hydrationLow |
| 60–79% | hydrationDeclining |
| ≥ 80% | hydrationGood |

---

## Nutrition

| Progress | Observation |
|----------|-------------|
| < 60% | nutritionLow |
| 60–79% | nutritionDeclining |
| ≥ 80% | nutritionGood |

---

## Movement

| Progress | Observation |
|----------|-------------|
| < 60% | movementLow |
| 60–79% | movementDeclining |
| ≥ 80% | movementGoalReached |

---

## Sleep

| Progress | Observation |
|----------|-------------|
| < 60% | sleepPoor |
| 60–79% | sleepDeclining |
| ≥ 80% | sleepGood |

---

## Heart

| Progress | Observation |
|----------|-------------|
| < 60% | heartElevated |
| 60–79% | heartDeclining |
| ≥ 80% | heartNormal |

---

## Weight

| Progress | Observation |
|----------|-------------|
| < 60% | weightIncreasing |
| ≥ 60% | weightStable |

---

# Severity

Each observation has a severity level.

| Progress | Severity |
|----------|----------|
| < 40% | Critical |
| 40–59% | High |
| 60–79% | Medium |
| ≥ 80% | Low |

Severity describes urgency.

It does not change the observation.

---

# Confidence

Observation confidence describes how certain the system is.

Confidence depends on:

- Available data
- Data freshness
- Data consistency
- Data source reliability

Observation confidence never represents medical certainty.

---

# Observation Sources

Observations may originate from multiple providers.

Examples:

- HealthKit
- Manual Input
- Garmin
- Calendar
- Weather
- Location
- AI

All observations share the same format regardless of their source.

---

# Future Providers

ObservationEngine is provider-based.

New providers can be added without changing existing providers.

Examples:

- CalendarObservationProvider
- WeatherObservationProvider
- GarminObservationProvider
- HabitObservationProvider

ObservationEngine aggregates observations from all registered providers.

---

# Design Principles

Observation describes.

It never explains.

It never predicts.

It never recommends.

It never judges.

---

# Examples

Example 1

Input:

- Hydration: 35%

Output:

```
hydrationLow
severity: high
confidence: 0.95
```

---

Example 2

Input:

- Sleep: 91%

Output:

```
sleepGood
severity: low
confidence: 0.98
```

---

Example 3

Input:

- Movement: 67%

Output:

```
movementDeclining
severity: medium
confidence: 0.90
```

---

# Golden Rule

ObservationEngine should always answer:

> "What is happening?"

It should never answer:

> "Why?"

That is the responsibility of InsightEngine.

