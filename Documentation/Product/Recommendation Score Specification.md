# Recommendation Score Specification

## Purpose

The Recommendation Score Engine determines which health behaviour should be prioritised at any given moment.

Its purpose is not to evaluate health directly.

Health evaluation is performed by individual Need Calculators.

The Recommendation Score Engine combines multiple decision factors to determine the most valuable coaching recommendation.

---

# Design Principles

## Separate evaluation from prioritisation.

Need Calculators estimate physiological or behavioural need.

The Recommendation Score Engine determines coaching priority.

These responsibilities must remain independent.

---

## Recommendation Score Formula

```
Recommendation Score

=

(Need × Time Multiplier)

+

Context Modifier

+

Memory Modifier

+

Personality Modifier
```

Each modifier influences recommendation priority without changing the underlying Need.

---

# Recommendation Score Components

## 1. Need

### Responsibility

Estimate how much attention a behaviour currently requires.

Need is calculated independently for every behaviour.

Each Need Calculator owns its own mathematical model.

### Range

0 – 100

### Examples

Water Need

Movement Need

Nutrition Need

Sleep Need

Recovery Need

---

## 2. Time Multiplier

### Responsibility

Adjust recommendation priority according to the current phase of the day.

Time does not change Need.

Time only changes coaching priority.

### Default Range

0.8 – 1.2

---

### Morning

| Behaviour | Multiplier |
|-----------|-----------:|
| Water | 1.20 |
| Nutrition | 1.10 |
| Movement | 0.80 |
| Sleep | 0.90 |
| Recovery | 0.90 |

---

### Afternoon

| Behaviour | Multiplier |
|-----------|-----------:|
| Water | 1.10 |
| Nutrition | 1.20 |
| Movement | 1.00 |
| Sleep | 0.90 |
| Recovery | 1.00 |

---

### Evening

| Behaviour | Multiplier |
|-----------|-----------:|
| Water | 1.00 |
| Nutrition | 1.10 |
| Movement | 1.20 |
| Sleep | 1.20 |
| Recovery | 1.20 |

---

### Night

Recommendation Score is no longer responsible for behaviour prioritisation.

Night coaching is controlled by the Decision Gate.

---

## 3. Context Modifier

### Responsibility

Adjust recommendation priority using environmental context.

Examples

- Weekend
- Weather
- Travel
- Calendar
- Stress
- High temperature

Typical Range

-10 ... +10

---

## 4. Memory Modifier

### Responsibility

Reduce repetitive coaching.

Repeated recommendations become less likely unless Need is critically high.

Example

| Previous Recommendations | Modifier |
|--------------------------|---------:|
| 0 | 0 |
| 1 | -10 |
| 2 | -25 |
| 3 | -40 |
| 4+ | -60 |

Memory must never completely suppress a critical recommendation.

---

## 5. Personality Modifier

### Responsibility

Slightly adjust recommendation priority according to coaching personality.

Personality never changes physiological Need.

Typical Range

-5 ... +5

Examples

Supportive

- slightly favours recovery
- slightly favours hydration

Challenge

- slightly favours movement
- encourages action

Balanced

- neutral

---

# Decision Gate

The Decision Gate executes after Recommendation Score calculation.

Its responsibility is determining whether the recommendation should actually be delivered.

Examples

- Night Coach
- Missing Health Data
- Missing Meal Information
- Missing Garmin Synchronisation
- Notification Suppression

Decision Gate may replace or suppress recommendations.

---

# Night Coach Policy

After approximately 22:00, normal coaching behaviour changes.

The Companion should no longer encourage high-effort behaviours.

Typical recommendations become

- Drink one final glass of water.
- Prepare for sleep.
- Reflect on today's progress.

The goal shifts from improvement to recovery.

---

# Recoverability

Not every behaviour can be corrected equally.

Examples

| Behaviour | Recoverability |
|-----------|----------------|
| Water | High |
| Protein Intake | High |
| Fibre Intake | High |
| Meal Completion | Medium |
| Daily Steps | Medium |
| Sleep | Very Low |
| Recovery | Low |

Recoverability is not currently part of the Recommendation Score.

It is reserved for future versions of the decision engine.

---

# Explainability

Every selected recommendation must be explainable.

The Recommendation Score Engine provides the recommendation.

The Reasoning Engine explains why.

The Personality Engine determines how the explanation is communicated.

---

# Design Goals

The Recommendation Score Engine should:

- prioritise the highest-value behaviour
- adapt throughout the day
- avoid repetitive coaching
- remain transparent
- remain explainable
- remain behaviour-independent
- remain easily extensible

---

# Future Extensions

Possible future modifiers include

- Confidence Score
- User State
- Chronotype
- Seasonal Behaviour
- Habit Strength
- Weather Adaptation
- Calendar Awareness
- Medication Schedule

The Recommendation Score Engine should support these additions without architectural changes.
