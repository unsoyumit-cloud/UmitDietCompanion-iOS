# ADR-010 — Dashboard Represents Health Domains, Not Raw Metrics

**Status:** Accepted

**Date:** 08.08.2026

---

# Context

Many health applications display raw metrics directly on the dashboard (steps, heart rate, calories, HRV, etc.).

The goal of Ümit Diet Companion is different.

The dashboard should answer one question:

> **"How am I doing today?"**

instead of

> **"What are my sensor values?"**

Ümit Diet Companion is not a health data viewer.

It is a **Health Decision Companion**.

Users should first understand the current state of each health domain.

Raw metrics and detailed analysis belong to the detail screens.

---

# Decision

Dashboard rings represent **health domains**, not individual sensor values.

Each ring summarizes one area of daily health using multiple underlying metrics where appropriate.

Selecting a ring opens a detailed screen explaining the contributing metrics, trends and AI insights.

---

# Dashboard Health Domains

## 💧 Hydration

Represents daily hydration progress.

### Primary Inputs

- Water Intake
- Water Goal

### Future Inputs

- Weather
- Activity Level
- Sweat Estimate

---

## 🚶 Movement

Represents daily movement.

### Primary Inputs

- Steps
- Step Goal

### Future Inputs

- Active Minutes
- Exercise Sessions
- Floors Climbed

---

## 🥗 Nutrition

Represents overall nutrition quality.

### Primary Inputs

- Meal Completion
- Meal Quality
- Calorie Progress

### Future Inputs

- Protein
- Fiber
- Healthy Fat
- Vegetables
- Meal Timing
- Micronutrients

---

## 😴 Sleep

Represents overnight sleep.

### Primary Inputs

- Sleep Duration
- Sleep Goal

### Future Inputs

- Sleep Consistency
- Sleep Schedule

Sleep evaluates only overnight sleep.

Recovery is intentionally handled separately.

---

## ❤️ Recovery

Represents physiological recovery.

### Primary Inputs

- HRV
- Body Battery
- Resting Heart Rate

### Future Inputs

- Nap Duration
- Stress
- Illness Context
- Recovery Trend

Recovery is independent from Sleep.

---

## ⚖️ Weight

Represents energy balance and weight trend.

### Primary Inputs

- Current Weight
- Calorie Intake
- Basal Calories Burned
- Active Calories Burned

### Future Inputs

- Weekly Energy Balance
- Weight Trend
- Estimated Fat Loss
- Estimated Muscle Gain

The Weight domain represents **energy balance**, not simply body weight.

---

# Dashboard Philosophy

Dashboard rings intentionally hide complexity.

The user should see:

Nutrition

82%

instead of

- Protein: 72 g
- Fiber: 18 g
- Carbohydrates: 185 g
- Fat: 64 g
- Calories: 2,040 kcal

The detailed screen is responsible for explaining the underlying metrics.

---

# Detail Screen Philosophy

Every health domain has its own detailed page.

Example:

Nutrition

↓

Meal Completion

↓

Meal Quality

↓

Macro Distribution

↓

Daily Summary

↓

AI Companion Insight

↓

History & Trends

The dashboard answers:

> "How am I doing today?"

The detail page answers:

> "Why?"

---

# Design Principles

- Dashboard prioritizes understanding over precision.
- Raw data belongs to detail screens.
- AI recommendations are generated from health domains rather than isolated sensor values.
- Users should never need to interpret HRV, calories or macros directly to understand their day.
- Complexity should increase only after user interaction.

---

# Consequences

## Advantages

- Clean dashboard
- Easy to understand
- Scalable architecture
- Additional health metrics can be added without redesigning the dashboard
- Recommendation Engine works with health domains instead of isolated metrics

## Trade-offs

- Users interested in raw metrics need one additional tap.
- Detail screens become more information-dense.

These trade-offs are intentional.

---

# Related ADRs

- ADR-06 — Companion Principles
- ADR-07 — Need Curves Specification
- ADR-08 — Recommendation Score Formula
- ADR-09 — Personalized Need Calculation

## Vision

The dashboard is designed to answer **"How healthy is my day?"**, not **"How much data do I have?"**

Every detail screen exists to explain **why** the dashboard score looks the way it does.
