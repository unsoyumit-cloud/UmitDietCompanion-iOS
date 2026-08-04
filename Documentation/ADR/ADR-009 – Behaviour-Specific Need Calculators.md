# ADR-009 – Behaviour-Specific Need Calculators

## Status

Accepted

---

## Context

The Recommendation Score Engine determines which health behaviour should be prioritised at any given moment.

An early design considered calculating a single generic Need Score for every behaviour using the same mathematical model.

However, different health behaviours represent fundamentally different physiological processes.

Hydration, nutrition, movement, sleep and recovery cannot be evaluated using the same urgency model.

---

## Decision

Each health behaviour owns its own Need Calculator.

Every Need Calculator is responsible for converting health data into a behaviour-specific Need Score.

The Recommendation Score Engine combines these scores using a common decision framework, but never calculates Need itself.

---

## Behaviour Ownership

### Water

Measures hydration deficit.

Factors may include:

- Daily water intake
- Progress toward hydration goal
- Environmental conditions (future)
- Activity level (future)

---

### Nutrition

Measures nutritional need.

Factors may include:

- Meal completion
- Meal timing
- Protein intake
- Fibre intake
- Calorie balance

---

### Movement

Measures movement need.

Factors may include:

- Daily steps
- Active calories
- Sedentary duration
- Exercise completion

---

### Sleep

Measures sleep need.

Factors may include:

- Sleep duration
- Sleep quality
- Sleep consistency
- Sleep debt

---

### Recovery

Measures physiological recovery.

Factors may include:

- HRV
- Resting Heart Rate
- Body Battery
- Recovery trend
- Previous sleep quality

---

## Recommendation Score Architecture

Each behaviour independently calculates its own Need Score.

The Recommendation Score Engine then applies shared modifiers.

```
Need Score
      ×
Time Modifier
      +
Context Modifier
      +
Memory Modifier
      +
Personality Modifier
      =
Final Recommendation Score
```

---

## Rationale

Human physiology is not linear.

Different health behaviours have different urgency curves, different recovery dynamics and different coaching implications.

Using one generic formula would oversimplify these differences and reduce recommendation quality.

Behaviour-specific calculators produce more realistic coaching decisions while keeping the Recommendation Score Engine simple and extensible.

---

## Consequences

### Positive

- Scientifically sound architecture.
- Independent evolution of each behaviour.
- Easier tuning and experimentation.
- Highly extensible.
- Cleaner separation of responsibilities.

### Negative

- More individual calculators to maintain.
- Requires calibration for each behaviour.

---

## Future

Future behaviours can be added without changing the Recommendation Score Engine.

Examples include:

- Mental wellbeing
- Stress
- Heart health
- Mobility
- Mindfulness
- Medication adherence

Only a new Need Calculator is required.

