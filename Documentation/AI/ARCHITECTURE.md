# Ümit Diet Companion AI Architecture

## Philosophy

The AI in Ümit Diet Companion is not a doctor.

It is not a calorie calculator.

It is not a rule engine.

It is a trusted health companion that helps users make one better decision at a time.

The AI should always explain *why* before suggesting *what*.

---

# AI Pipeline

DailyHealthSnapshot
        │
        ▼
AIContext
        │
        ▼
ObservationEngine
        │
        ▼
HealthObservation[]
        │
        ▼
InsightEngine
        │
        ▼
Insight[]
        │
        ▼
RecommendationEngine
        │
        ▼
Recommendation[]
        │
        ▼
ReasoningEngine
        │
        ▼
CoachReasoning
        │
        ▼
CoachContentBuilder
        │
        ▼
CoachMessageFactory
        │
        ▼
PersonalityEngine
        │
        ▼
CoachMessage

---

# AI Responsibilities

## Observation

Observation only describes reality.

It never interprets.

Examples:

- Hydration is low
- Movement is declining
- Sleep quality is poor

Never:

- Drink more water
- Walk now

Those belong to Recommendation.

---

## Insight

Insight explains what observations mean.

Examples:

Observation:
- hydrationLow

Insight:
- User is falling behind today's hydration target.

Insights never tell the user what to do.

---

## Recommendation

Recommendation suggests one action.

Only one primary recommendation should be generated.

Examples:

- Drink a glass of water
- Take a 15 minute walk
- Eat a protein-rich lunch

Recommendations never explain why.

---

## Reasoning

Reasoning explains the recommendation.

Example:

Recommendation:
- Drink water

Reasoning:
- Reaching your hydration goal now will improve today's Health Score.

Reasoning never changes the recommendation.

It only explains it.

---

## Personality

Personality changes tone only.

It never changes meaning.

Balanced:

"Nice time for a glass of water."

Motivational:

"You're only one glass away from getting back on track!"

Scientific:

"Your hydration level has dropped below today's target."

The recommendation stays identical.

---

# Core Health Domains

The AI only understands these domains.

- Hydration
- Nutrition
- Movement
- Sleep
- Heart
- Weight

No other health domains should exist inside the AI.

---

# Golden Rules

1. Observation observes.

2. Insight interprets.

3. Recommendation suggests.

4. Reasoning explains.

5. Personality changes tone.

Responsibilities must never overlap.

---

# Design Principles

- One responsibility per engine.
- One source of truth.
- Prefer composition over conditions.
- Never duplicate business rules.
- Every layer depends only on the previous layer.
- Dashboard and AI always use the same health language.

---

# Future Extensions

Future providers may generate additional observations.

Examples:

- Calendar
- Weather
- Garmin
- Apple Health
- Location
- Travel
- Habit Learning

They plug into ObservationEngine without changing the rest of the pipeline.


