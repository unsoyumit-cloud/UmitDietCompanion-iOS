# Ümit Diet Companion
# Coach Architecture

## Vision

The AI Coach does not try to increase the Health Score directly.

Its primary goal is to recommend the single most valuable next healthy behaviour.

This principle is called:

**One Next Action**

---

# Decision Flow

DailyHealthSnapshot
        ↓
HealthCalculator
        ↓
HealthStatus
        ↓
BehaviourEngine
        ↓
BehaviourRecommendation
        ↓
CoachMessage
        ↓
User

---

# Responsibilities

## DailyHealthSnapshot

Contains raw health data and user profile.

## HealthCalculator

Calculates progress values.

Examples:

- waterProgress
- sleepProgress
- calorieProgress
- weightProgress

## HealthStatus

Contains interpreted health progress.

No business logic.

## BehaviourRule

Evaluates one specific situation.

Returns either:

- BehaviourRecommendation

or

- nil

Each rule should focus on one behaviour only.

## BehaviourEngine

Runs all rules.

Selects the most relevant recommendation.

Returns only one BehaviourRecommendation.

## CoachMessage

Transforms BehaviourRecommendation into a human-readable coaching message.

---

# Design Principles

- One Next Action
- Small habits over large goals
- Context before recommendation
- Behaviour before motivation
- One recommendation at a time
- Open for new rules
- Closed for modification

---

# Future Context Sources

- Garmin
- Apple Health
- Calendar
- Weather
- Travel
- Work schedule
- User habits

# Rule Guidelines

Every rule should:

- Solve only one problem.
- Be independently testable.
- Never modify other rules.
- Return nil when not applicable.
- Never generate UI text.
