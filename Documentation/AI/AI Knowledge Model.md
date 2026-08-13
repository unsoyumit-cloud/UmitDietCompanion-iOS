# AI Knowledge Model

**Project:** Ümit Diet Companion
**Sprint:** Sprint 5 – Intelligence
**Version:** 1.0 (Draft)
**Status:** Design Phase

---

# Purpose

This document defines **what the AI knows**.

The Decision Engine defines **how decisions are made**.

The Knowledge Model defines **the knowledge used to make those decisions**.

Think of it as the intelligence engine's internal understanding of health.

The goal is to separate **knowledge** from **logic**.

This allows the application to expand its health intelligence without changing the decision engine itself.

---

# Design Philosophy

The AI should never think of health metrics as isolated numbers.

Every metric exists inside a network of relationships.

The intelligence engine should understand:

* What a metric represents
* Why it matters
* When it matters
* What influences it
* What it influences
* Which behaviours improve it
* Which behaviours harm it

The system should reason using connected knowledge rather than independent rules.

---

# Knowledge Architecture

```text
Health Domain
        │
        ▼
Health Metric
        │
        ▼
Knowledge Object
        │
        ▼
Relationships
        │
        ▼
Decision Engine
```

Every health metric is represented by a structured **Knowledge Object**.

---

# Knowledge Object

Each metric contains far more than a value.

A complete knowledge object should include:

* Identity
* Description
* Goal
* Importance
* Health Impact
* Time Relevance
* Dependencies
* Related Metrics
* Observation Rules
* Insight Rules
* Recommendation Rules
* Behaviour Library
* Coach Message Themes

---

# Example

## Water

### Identity

Metric

Water Intake

Category

Hydration

---

### Purpose

Maintain hydration throughout the day.

Support recovery, cognition and energy.

---

### Goal

Daily personalized water target.

---

### Health Impact

Supports

* Recovery
* Energy
* Digestion
* Mental performance
* Exercise performance

---

### Time Relevance

Highest

* Morning
* Afternoon

Lower

* Late Evening

---

### Related Metrics

* Exercise
* Sleep
* Alcohol
* Temperature
* Calories

---

### Positive Behaviours

* Drink water with coffee
* Drink before meals
* Carry a bottle
* Refill bottle after lunch

---

### Negative Behaviours

* Drinking only when thirsty
* Long meetings without water
* Excessive alcohol
* Excessive caffeine without water

---

### Typical Recommendations

* Drink 500 ml
* Refill bottle
* Drink before lunch

---

### Typical Coach Themes

* Fresh start
* Small wins
* Energy
* Feeling better

---

# Knowledge Categories

The intelligence engine organizes knowledge into domains.

---

## Body Composition

Includes

* Weight
* Body Fat
* Muscle Mass
* BMI

---

## Nutrition

Includes

* Calories
* Protein
* Carbohydrates
* Fat
* Fiber
* Sugar

---

## Hydration

Includes

* Water
* Electrolytes (future)

---

## Activity

Includes

* Steps
* Distance
* Active Calories
* Exercise
* Zone Minutes

---

## Recovery

Includes

* Sleep
* Resting Heart Rate
* HRV
* Stress

---

## Lifestyle

Includes

* Alcohol
* Mood
* Smoking
* Routine

---

# Relationships

Knowledge objects are connected.

Example

```text
Sleep
      │
      ├────────► Recovery
      │
      ├────────► Energy
      │
      ├────────► Mood
      │
      ├────────► Exercise Readiness
      │
      ▼
Weight Control
```

Knowledge should never exist in isolation.

---

# Dependencies

Every metric may depend on other metrics.

Example

Protein

Depends On

* Exercise
* Body Weight
* Goal

---

Water

Depends On

* Temperature
* Exercise
* Alcohol
* Body Weight

---

Sleep

Depends On

* Alcohol
* Exercise Timing
* Stress
* Routine

---

These relationships help the engine understand context.

---

# Time Awareness

Knowledge changes throughout the day.

Example

Morning

Water

High Priority

---

Evening

Water

Medium Priority

---

Morning

Steps

Low Priority

---

Afternoon

Steps

High Priority

---

Night

Sleep Preparation

Very High Priority

The same metric may produce different coaching depending on the current phase of the day.

---

# Behaviour Mapping

Knowledge should include behaviours.

Example

Protein

Possible Behaviours

* Add Greek yogurt
* Choose grilled chicken
* Add cottage cheese
* Eat eggs
* Drink protein shake

The Decision Engine selects one behaviour.

The Knowledge Model stores available behaviours.

---

# Recommendation Mapping

Each metric maintains its own recommendation library.

Example

Hydration

Recommendations

* Drink 300 ml
* Drink 500 ml
* Refill bottle
* Drink before lunch

---

Sleep

Recommendations

* Reduce screen time
* Sleep earlier
* Avoid caffeine
* Prepare bedroom

Recommendations are reusable assets.

---

# Coach Themes

The Knowledge Model does not store messages.

It stores communication intent.

Example

Hydration

Themes

* Energy
* Refreshment
* Easy wins
* Momentum

---

Sleep

Themes

* Recovery
* Tomorrow starts tonight
* Rest
* Recharge

The LLM uses these themes to express the final message naturally.

---

# Confidence

Each knowledge object includes a confidence level.

Example

Water

Observation Confidence

High

Garmin + Manual Input

---

Sleep

Observation Confidence

Medium

Garmin only

---

Nutrition

Observation Confidence

Variable

Depends on meal logging quality.

The Decision Engine should avoid strong recommendations when confidence is low.

---

# Knowledge Expansion

The model is designed to grow.

Future knowledge objects may include:

* Weather
* Travel
* Workload
* Social Events
* Restaurant Visits
* Grocery Shopping
* Menstrual Cycle
* Medication
* Illness
* Injury
* Seasonal Effects

No change to the Decision Engine should be required.

Only new knowledge should be added.

---

# Knowledge vs Decision

The Knowledge Model never makes decisions.

It answers questions such as:

* What is protein?
* Why is hydration important?
* Which behaviours improve sleep?
* Which metrics affect recovery?
* Which recommendations belong to hydration?
* When is movement most relevant?

The Decision Engine uses this knowledge to make decisions.

---

# Guiding Principle

The intelligence engine should not memorize rules.

It should understand relationships.

Knowledge provides understanding.

The Decision Engine provides reasoning.

Together they create consistent, explainable and scalable health intelligence.


