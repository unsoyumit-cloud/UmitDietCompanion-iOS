# AI Recommendation Library

**Project:** Ümit Diet Companion
**Sprint:** Sprint 5 – Intelligence
**Version:** 1.0 (Draft)
**Status:** Design Phase

---

# Purpose

The AI Recommendation Library defines **what the intelligence engine wants the user to improve**.

Observations describe facts.

Insights explain facts.

Recommendations define intentions.

A recommendation is **not** a behaviour.

It is **not** a coaching message.

It is **not** a user interface element.

It is a reusable health objective that connects insights to behaviours.

---

# Design Philosophy

The Recommendation Library should remain intentionally small.

Many different insights can point to the same recommendation.

Likewise, one recommendation can produce many different behaviours depending on context.

This keeps the intelligence engine simple, reusable and scalable.

---

# Position in the Intelligence Pipeline

```text
Observation
      │
      ▼
Insight Library
      │
      ▼
Recommendation Library
      │
      ▼
Behaviour Library
      │
      ▼
Context Engine
      │
      ▼
Priority Matrix
      │
      ▼
Coach Payload
      │
      ▼
LLM
```

Recommendations act as the bridge between understanding and action.

---

# Recommendation Object

Every recommendation follows the same structure.

## Required Properties

* Recommendation ID
* Name
* Category
* Goal
* Description
* Applicable Insights
* Behaviour Categories
* Coach Themes
* Base Priority
* Success Criteria

---

# Recommendation Categories

Recommendations are organised by user intention.

* Hydration
* Nutrition
* Activity
* Recovery
* Weight
* Lifestyle
* Planning
* Maintenance

---

# Recommendation Lifecycle

Every recommendation follows a consistent lifecycle.

```text
Insight Detected
        │
        ▼
Recommendation Created
        │
        ▼
Behaviour Selected
        │
        ▼
Behaviour Completed
        │
        ▼
Recommendation Resolved
```

---

# Hydration Recommendations

---

## REC-HYD-001

### Increase Water Intake

Goal

Improve hydration progress.

Typical Behaviours

* Drink one glass of water.
* Refill your bottle.
* Drink before lunch.
* Drink while making coffee.

Applicable Insights

* Hydration Behind Schedule
* Critical Hydration
* Alcohol Recovery Needed
* Exercise Completed

Coach Themes

* Energy
* Fresh Start
* Small Wins

Base Priority

High

---

## REC-HYD-002

### Maintain Hydration

Goal

Protect good hydration habits.

Applicable Insights

* Hydration Complete
* Excellent Hydration

Coach Themes

* Celebrate Progress
* Consistency

Base Priority

Medium

---

# Nutrition Recommendations

---

## REC-NUT-001

### Increase Protein Intake

Goal

Support recovery and muscle maintenance.

Applicable Insights

* Protein Deficit
* Muscle Recovery Risk
* Strength Training Completed

Typical Behaviours

* Add Greek yogurt.
* Choose grilled chicken.
* Eat eggs.
* Add cottage cheese.

---

## REC-NUT-002

### Improve Meal Quality

Goal

Improve overall nutritional balance.

Applicable Insights

* Balanced Nutrition Needed
* High Processed Food Intake
* Low Vegetable Intake

---

## REC-NUT-003

### Reduce Calorie Intake

Goal

Return daily calorie intake toward target.

Applicable Insights

* Calorie Surplus
* Weekend Drift

---

# Activity Recommendations

---

## REC-ACT-001

### Increase Daily Movement

Goal

Increase daily activity.

Applicable Insights

* Movement Behind Schedule
* Sedentary Morning
* Low Activity Day

Typical Behaviours

* Walk after lunch.
* Use the stairs.
* Walk during a phone call.

---

## REC-ACT-002

### Maintain Activity

Goal

Protect an already active day.

Applicable Insights

* Activity Goal Achieved
* Activity Momentum

---

# Recovery Recommendations

---

## REC-REC-001

### Improve Sleep

Goal

Increase sleep quality.

Applicable Insights

* Sleep Debt
* Poor Recovery
* High Fatigue

Typical Behaviours

* Sleep earlier.
* Reduce screen time.
* Prepare for bed.

---

## REC-REC-002

### Prioritise Recovery

Goal

Support physical recovery.

Applicable Insights

* Excellent Workout
* Recovery Risk
* High Fatigue

---

# Weight Recommendations

---

## REC-WGT-001

### Maintain Weight Trend

Goal

Support long-term weight consistency.

Applicable Insights

* Positive Weight Trend
* Goal Approaching

---

## REC-WGT-002

### Review Weight Strategy

Goal

Break prolonged plateaus.

Applicable Insights

* Weight Plateau

---

# Lifestyle Recommendations

---

## REC-LIF-001

### Reduce Alcohol

Goal

Reduce alcohol-related health impact.

Applicable Insights

* Alcohol Recovery Needed
* Frequent Alcohol Pattern

---

## REC-LIF-002

### Prepare Tomorrow

Goal

Increase tomorrow's chance of success.

Applicable Insights

* Evening Planning Opportunity
* Healthy Routine

Typical Behaviours

* Prepare breakfast.
* Refill bottle.
* Plan tomorrow's walk.

---

# Maintenance Recommendations

Not every recommendation should solve a problem.

Some recommendations exist only to reinforce positive behaviour.

Examples

* Maintain Hydration
* Maintain Activity
* Maintain Sleep Routine
* Continue Healthy Streak

The intelligence engine should reward consistency, not only correct deficiencies.

---

# Recommendation Relationships

Multiple insights may map to one recommendation.

Example

```text
Hydration Behind Schedule
Alcohol Recovery Needed
Workout Completed
High Temperature
        │
        ▼
Increase Water Intake
```

One recommendation may also produce many behaviours.

```text
Increase Water Intake
        │
        ├── Drink before coffee
        ├── Refill bottle
        ├── Drink before lunch
        ├── Carry a bottle
        └── Drink after workout
```

This many-to-many relationship keeps the system modular and reusable.

---

# Recommendation Success

Every recommendation defines success criteria.

Examples

Increase Water Intake

Success

Water progress reaches target.

---

Increase Daily Movement

Success

Daily movement reaches expected progress.

---

Improve Sleep

Success

Sleep routine completed.

The Decision Engine uses these outcomes to determine when a recommendation is resolved.

---

# Recommendation Priority

Each recommendation contains a base priority.

The final priority is determined later by the Priority Matrix.

Examples

Critical Recovery

High

---

Improve Protein

Medium

---

Maintain Activity

Low

The Recommendation Library never makes the final decision.

---

# Explainability

Every recommendation should answer:

* Which insight created me?
* Which behaviours can fulfil me?
* When am I considered complete?

This information should always be available to developers and debugging tools.

---

# Future Expansion

Future recommendation categories may include:

* Mental Wellbeing
* Stress Management
* Heart Health
* Travel Recovery
* Weather Adaptation
* Injury Prevention
* Immune Support
* Social Health

The Recommendation Library should grow without requiring changes to the overall intelligence architecture.

---

# Relationship with Other Components

Observation Engine

Provides facts.

---

Insight Library

Explains facts.

---

Recommendation Library

Defines the health objective.

---

Behaviour Library

Provides practical actions.

---

Context Engine

Selects the best behaviour for the current situation.

---

Priority Matrix

Chooses the single coaching focus.

---

LLM

Expresses the selected behaviour in natural language.

---

# Guiding Principle

Recommendations define **intent**, not **implementation**.

They describe **what should improve**, while leaving **how it improves** to the Behaviour Library and **when it happens** to the Context Engine.

This separation keeps the intelligence engine deterministic, reusable and easy to extend.

