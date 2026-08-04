# Need Curves Specification

## Purpose

Each health behaviour represents a different physiological process.

Therefore, every behaviour requires its own mathematical model to estimate urgency.

The goal of a Need Calculator is **not** to produce a recommendation.

Its responsibility is only to answer one question:

> **"How much does this behaviour currently need attention?"**

The output is always a Need Score between **0 and 100**.

---

# General Principles

## Need is behaviour-specific.

Every health behaviour owns its own Need Calculator.

No generic formula is shared between behaviours.

---

## Need is independent from time.

Need describes the health deficit itself.

Time-dependent coaching decisions are handled later by the Recommendation Score Engine.

Example:

Movement Need depends on step completion.

It does NOT depend on whether it is morning or evening.

---

## Need is independent from personality.

Need represents physiology.

Personality only changes communication.

---

## Need is independent from coaching history.

Previous recommendations never change physiological need.

Memory influences recommendation priority later.

---

# Water Need

## Goal

Estimate hydration deficit.

### Inputs

- Water intake
- Hydration goal

### Characteristics

- Cumulative
- High urgency
- Non-linear curve

The first missing litre is significantly more important than the last few hundred millilitres.

Need should decrease rapidly as hydration approaches the daily target.

---

# Movement Need

## Goal

Estimate movement deficit.

### Inputs

- Daily steps
- Daily movement goal

### Characteristics

- Based only on completion percentage.
- Independent from current time.
- Time sensitivity is applied later by the Recommendation Score Engine.

---

# Nutrition Need

## Goal

Estimate nutritional need.

### Inputs

- Meal completion
- Meal timing
- Protein intake
- Fibre intake
- Calorie balance

### Characteristics

Meal completion has higher importance than nutrient optimisation.

Missing an entire meal is considered more urgent than consuming insufficient protein.

Protein, fibre and calorie quality can often be compensated during later meals.

---

# Sleep Need

## Goal

Estimate sleep quality deficit.

### Inputs

- Sleep duration
- Sleep quality
- Sleep consistency

### Characteristics

Sleep cannot be corrected during the current day.

Need reflects the previous night's sleep.

---

# Recovery Need

## Goal

Estimate physiological recovery.

### Inputs

- Sleep Need
- HRV
- Body Battery
- Resting Heart Rate

### Characteristics

Recovery is a composite behaviour.

No single metric determines Recovery Need.

Instead, multiple physiological indicators are combined into a single estimate.

Recovery represents overall readiness rather than sleep quality alone.

---

# Need Score Scale

| Score | Interpretation |
|--------|----------------|
| 0–20 | Very Low Need |
| 21–40 | Low Need |
| 41–60 | Moderate Need |
| 61–80 | High Need |
| 81–100 | Critical Need |

---

# Relationship with Recommendation Score

Need is only one component of the final coaching decision.

The Recommendation Score Engine applies additional modifiers.

```
Need
      ×
Time Multiplier
      +
Context Modifier
      +
Memory Modifier
      +
Personality Modifier
      =
Recommendation Score
```

---

# Decision Boundary

Need Calculators never:

- generate coaching messages
- apply personality
- consider coaching history
- evaluate time of day
- compare behaviours

They only estimate physiological urgency.

---

# Design Philosophy

The Recommendation Score Engine decides **what should be prioritised**.

Need Calculators decide **how important each behaviour currently is**.

This separation keeps physiological evaluation independent from coaching strategy and allows each behaviour to evolve using its own scientific model without affecting the overall recommendation architecture.


The Need Calculator should be grounded in evidence-based health and wellness principles, while the Recommendation Score Engine should focus on behaviour prioritisation and coaching strategy.

All progress-based behaviours must calculate Need relative to the user's personalised goal rather than fixed absolute values.

## Progress is personalised.

Every progress-based behaviour calculates progress relative to the user's own goal.

The Recommendation Engine must never assume fixed goals.

Examples:

- Water Progress = Current Water / User Water Goal
- Movement Progress = Current Steps / User Step Goal
- Calorie Progress = Current Calories / User Calorie Goal

This ensures recommendations remain consistent regardless of individual goals.
