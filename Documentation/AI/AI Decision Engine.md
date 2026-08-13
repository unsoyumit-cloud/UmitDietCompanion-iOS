# AI Decision Engine

**Project:** Ümit Diet Companion
**Sprint:** Sprint 5 – Intelligence
**Version:** 1.0 (Draft)
**Status:** Design Phase

---

# Purpose

This document defines **how the intelligence engine makes decisions**.

It does **not** describe user interface behaviour.

It does **not** describe LLM prompts.

It defines the deterministic logic that transforms health data into a single coaching decision.

Every decision produced by this engine should be:

* Predictable
* Explainable
* Testable
* Repeatable

Given identical input data, the engine must always produce the same output.

---

# Design Principles

The decision engine follows five fundamental principles.

## 1. Deterministic

The same inputs always produce the same result.

No randomness.

No creativity.

No hallucination.

---

## 2. Explainable

Every decision must answer:

> Why was this recommendation selected?

The application should always be able to reconstruct the complete reasoning process.

---

## 3. User-Centric

The goal is not to optimize numbers.

The goal is to help people build healthier habits.

Behaviour change always has priority over metric perfection.

---

## 4. Context-Aware

The best recommendation depends on context.

Time.

Routine.

Progress.

Environment.

Current situation.

---

## 5. One Decision

The engine always produces **one primary coaching objective**.

Not five.

Not ten.

One.

---

# Decision Pipeline

```text
Health Data
      │
      ▼
Observation Generation
      │
      ▼
Insight Detection
      │
      ▼
Recommendation Generation
      │
      ▼
Behaviour Selection
      │
      ▼
Priority Evaluation
      │
      ▼
Primary Focus
      │
      ▼
Coach Payload
      │
      ▼
LLM
```

Each stage receives structured data from the previous stage.

No stage may skip another.

---

# Decision Inputs

The engine can receive data from multiple sources.

## User Profile

* Age
* Height
* Weight
* Goal Weight
* Gender
* Activity Level

---

## Daily Metrics

* Calories
* Protein
* Carbohydrates
* Fat
* Water
* Sleep
* Steps
* Active Calories
* Exercise
* Mood
* Alcohol

---

## Historical Data

* Weight Trend
* Seven-Day Average
* Sleep Trend
* Water Trend
* Activity Trend
* Nutrition Trend

---

## Context

* Time of Day
* Day of Week
* Meal Timing
* Workout Status
* Current Streaks

---

## Future Extensions

* Location
* Weather
* Calendar
* Shopping Activity
* Restaurant Detection
* Travel Status
* Stress Signals

---

# Observation Rules

Observations are objective.

They contain no interpretation.

Example

```text
Water = 1.3 L

Steps = 5,210

Sleep = 6h 18m

Protein = 84 g
```

Rules

* Never compare.
* Never evaluate.
* Never score.
* Never recommend.

Only describe reality.

---

# Insight Rules

Insights interpret observations.

Examples

```text
Hydration Progress = 42%

Movement Behind Schedule

Protein Intake Below Target

Recovery Risk

Sleep Debt Increasing
```

Insights answer

> What is happening?

Not

> What should we do?

Multiple insights may exist simultaneously.

---

# Recommendation Rules

Each insight can generate one or more recommendations.

Example

```text
Insight

Low Hydration
```

↓

```text
Recommendation

Drink 500 ml Water
```

Another

```text
Low Movement
```

↓

```text
Walk 20 Minutes
```

Recommendations are reusable building blocks.

They are not written for users.

---

# Behaviour Rules

Recommendations become behaviours.

The question is

> How can this action fit naturally into today's life?

Example

Recommendation

```text
Drink Water
```

↓

Behaviour

```text
Drink one glass before your next coffee.
```

Another

Recommendation

```text
Walk More
```

↓

Behaviour

```text
Walk during your next phone call.
```

Behaviours should be:

* Easy
* Specific
* Realistic
* Contextual
* Achievable

---

# Priority Evaluation

Many recommendations may exist simultaneously.

Only one becomes today's focus.

Each recommendation receives a priority score.

The score should consider multiple dimensions.

## Impact

How much health benefit can this action provide?

---

## Urgency

Does delaying this action reduce its value?

---

## Opportunity

How easy is it to complete right now?

---

## Time Relevance

Is this recommendation appropriate for the current phase of the day?

---

## Behaviour Cost

How much effort does the user need?

Lower effort generally increases priority.

---

## Momentum

Can completing this action create positive momentum for the rest of the day?

---

## User Progress

Has this area already been addressed today?

If yes,

priority decreases.

---

# Primary Focus Selection

After evaluation, the engine selects exactly one coaching objective.

Example

```text
Candidate A

Hydration

Priority = 87
```

```text
Candidate B

Movement

Priority = 74
```

```text
Candidate C

Protein

Priority = 69
```

↓

Output

```text
Primary Focus

Hydration
```

Every coaching message must originate from this selection.

---

# Coach Payload

The LLM receives structured information.

Example

```text
Focus

Hydration

Behaviour

Drink one glass while preparing coffee

Reason

Hydration Behind Schedule

Tone

Friendly

Energy

Positive

Urgency

Low

Humour

Allowed
```

The LLM should not receive unnecessary raw health data.

It should receive only the information required to communicate effectively.

---

# Decision Explainability

Every decision should be traceable.

Example

```text
Observation

Water = 1.3 L
```

↓

```text
Insight

Hydration Behind Schedule
```

↓

```text
Recommendation

Drink 500 ml Water
```

↓

```text
Behaviour

Drink one glass while making coffee.
```

↓

```text
Primary Focus

Hydration
```

↓

```text
Coach Message

While your coffee is brewing, enjoy a glass of water first. It's an easy step that will help you stay ahead for the rest of the day.
```

This chain should be visible in internal debugging tools.

---

# Failure Handling

The engine must continue operating even when information is missing.

Examples

Missing sleep data

↓

Ignore sleep-related insights.

---

Missing nutrition data

↓

Do not generate nutrition recommendations.

---

Missing Garmin synchronization

↓

Continue using manual inputs.

---

Missing historical data

↓

Generate only observation-based insights.

The engine should degrade gracefully rather than fail.

---

# Future Intelligence Modules

The decision engine is designed for expansion.

Future modules may include:

* Opportunity Engine
* Routine Engine
* Prediction Engine
* Habit Learning Engine
* Motivation Engine
* Context Engine
* Seasonal Engine
* Travel Engine
* Recovery Engine
* Personalization Engine

Each module should enrich the decision process without breaking deterministic behaviour.

---

# Guiding Principle

The AI should never try to solve every health problem at once.

It should identify the **single most valuable opportunity** to help the user make one successful decision today.

Small actions repeated consistently create lasting behaviour change.

That is the purpose of the Decision Engine.

