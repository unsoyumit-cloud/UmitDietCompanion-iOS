# AI Intelligence Design Document

**Project:** Ümit Diet Companion
**Sprint:** Sprint 5 – Intelligence
**Version:** 1.0 (Draft)
**Status:** Design Phase

---

# Purpose

This document defines how the intelligence layer of Ümit Diet Companion thinks.

The goal is **not** to design an AI assistant.

The goal is to design a **deterministic decision engine** that converts health data into personalized coaching.

The Large Language Model (LLM) is **not responsible for making decisions**.

Instead, the LLM acts purely as a natural language interface that expresses decisions already produced by the application's intelligence engine.

This separation provides:

* Predictable behaviour
* Explainable decisions
* Testability
* Continuous improvement without prompt engineering
* Consistent coaching across users and devices

---

# Design Philosophy

The intelligence system follows one fundamental principle:

> **Observe first. Understand second. Recommend third. Coach last.**

Every coaching message shown to the user must be traceable back to measurable observations.

The system should never generate advice without being able to explain why that advice was selected.

---

# Core Architecture

```
Health Data
      │
      ▼
Observation Engine
      │
      ▼
Insight Engine
      │
      ▼
Recommendation Engine
      │
      ▼
Behaviour Engine
      │
      ▼
Primary Focus Selection
      │
      ▼
Coach Message Engine
      │
      ▼
LLM Expression Layer
```

Each layer has a single responsibility.

No layer should perform work belonging to another layer.

---

# Intelligence Layers

## 1. Observation Engine

### Responsibility

Collect facts.

Nothing else.

Observations are objective measurements.

No interpretation.

No scoring.

No recommendations.

### Examples

```
Weight = 81.8 kg

Water = 1.2 L

Sleep = 6h 12m

Steps = 5,438

Protein = 82 g

Calories Burned = 2,430

Mood = Happy
```

Observations are the single source of truth for the entire pipeline.

---

## 2. Insight Engine

### Responsibility

Transform raw observations into meaningful health insights.

This is the first layer that performs reasoning.

Examples

```
Hydration Progress = 41%

Recovery Score = Low

Movement Behind Schedule

Protein Intake Below Target

Weight Trend Improving

Sleep Debt Increasing
```

Insights describe **what is happening**.

They do not tell the user what to do.

---

## 3. Recommendation Engine

### Responsibility

Decide the most appropriate action.

Recommendations should always be:

* Short
* Specific
* Actionable
* Independent of wording

Examples

```
Drink 500 ml Water

Walk 20 Minutes

Increase Protein Intake

Go To Bed Earlier

Reduce Alcohol Tonight
```

A recommendation is an internal decision.

It is **not** user-facing text.

---

## 4. Behaviour Engine

### Responsibility

Transform recommendations into realistic behaviours.

This layer answers the question:

> How can this recommendation fit naturally into today's life?

Examples

Recommendation

```
Drink Water
```

↓

Behaviour

```
Drink one glass while making coffee.
```

Recommendation

```
Walk More
```

↓

Behaviour

```
Take your next phone call while walking.
```

Recommendation

```
Increase Protein
```

↓

Behaviour

```
Choose grilled chicken at dinner.
```

This is where **Opportunity Coaching** becomes a core capability.

The system should identify existing routines, locations, and moments where success is easiest instead of asking users to create entirely new habits.

---

## 5. Primary Focus Selection

### Responsibility

Select exactly one coaching objective.

Many problems may exist.

Only one becomes today's primary focus.

This protects users from information overload.

Selection should consider factors such as:

* Time of day
* Expected health impact
* Ease of completion
* Current progress
* Behavioural momentum
* User context

Output example

```
Today's Focus

Hydration
```

---

## 6. Coach Message Engine

### Responsibility

Generate structured coaching content.

At this stage the message is still language-independent.

Example

```
Focus:
Hydration

Behaviour:
Drink one glass while making coffee

Tone:
Friendly

Urgency:
Low

Encouragement:
High
```

---

## 7. LLM Expression Layer

### Responsibility

Convert structured coaching into natural language.

The LLM does **not** decide:

* priorities
* recommendations
* behaviours
* coaching strategy

It only converts structured data into friendly conversation.

Example output

> While you're making your coffee today, add a glass of water first. It's an easy win that helps the rest of your day.

---

# Design Rules

## Rule 1

Every coaching message must originate from measurable observations.

---

## Rule 2

The LLM never invents recommendations.

---

## Rule 3

Recommendations are deterministic.

Given the same input, the same recommendation should always be produced.

---

## Rule 4

Only one primary coaching objective should exist at any moment.

---

## Rule 5

Coaching should feel supportive.

Never judgmental.

Never guilt-driven.

---

## Rule 6

Behaviour change is more important than information delivery.

The application exists to help users build sustainable habits.

Not merely to report health metrics.

---

# Future Extensions

The intelligence pipeline is intentionally modular.

Future engines may include:

* Context Engine
* Routine Engine
* Opportunity Engine
* Motivation Engine
* Prediction Engine
* Learning Engine
* Personalization Engine

These engines can extend the decision-making process without changing the overall architecture.

---

# Guiding Principle

The intelligence engine should think like an experienced health coach.

It should understand the user's situation, identify the most meaningful opportunity for improvement, and encourage one achievable action at the right moment.

The LLM should simply give that decision a warm, human voice.

> **The intelligence decides.
> The coach communicates.**


