# AI Context Engine

**Project:** Ümit Diet Companion
**Sprint:** Sprint 5 – Intelligence
**Version:** 1.0 (Draft)
**Status:** Design Phase

---

# Purpose

The AI Context Engine determines **what is realistically possible right now**.

The Decision Engine knows **what should be improved**.

The Behaviour Library knows **all possible behaviours**.

The Context Engine decides **which behaviour best fits the user's current situation**.

Its purpose is to transform good advice into timely, relevant and achievable action.

---

# Design Philosophy

The same recommendation should not always produce the same behaviour.

Context changes everything.

A recommendation without context becomes generic advice.

A recommendation with context becomes coaching.

The Context Engine ensures that every suggested behaviour feels natural within the user's current environment, routine and moment.

---

# Core Responsibility

The Context Engine answers one question:

> **"Given the user's current situation, which behaviour has the highest probability of success?"**

It never creates new behaviours.

It never changes recommendations.

It only evaluates context and selects the most appropriate behaviour from the Behaviour Library.

---

# Position in the Intelligence Pipeline

```text
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

The Context Engine operates after recommendations have been created and before the final coaching payload is produced.

---

# Context Model

The engine evaluates multiple dimensions simultaneously.

No single factor should determine behaviour selection.

---

## Time Context

Examples:

* Morning
* Midday
* Afternoon
* Evening
* Night

Different behaviours become relevant at different times.

Example

Recommendation

Increase Water

Morning

↓

Drink a glass while making coffee.

Evening

↓

Drink one glass before dinner.

---

## Daily Progress Context

The engine evaluates how the day is developing.

Examples

* Water progress
* Step progress
* Protein progress
* Calories remaining
* Exercise completed
* Sleep completed

Behaviours should complement today's progress rather than ignore it.

---

## Routine Context

The engine understands recurring routines.

Examples

Morning coffee

Lunch break

Evening walk

Gym after work

Weekend breakfast

Behaviours should attach themselves to existing routines whenever possible.

Existing habits are easier to reinforce than creating entirely new ones.

---

## Location Context (Future)

Possible locations

* Home
* Office
* Restaurant
* Grocery Store
* Gym
* Airport
* Hotel

Location should influence behaviour selection rather than recommendations.

Example

Increase Protein

Restaurant

↓

Choose grilled chicken.

Home

↓

Eat Greek yogurt.

---

## Activity Context

Examples

Working

Walking

Driving

Exercising

Shopping

Cooking

Waiting

Travelling

Behaviours should fit naturally into the current activity.

---

## Calendar Context (Future)

Examples

Busy workday

Holiday

Business trip

Weekend

Vacation

Meeting-heavy afternoon

Available free time influences behaviour complexity.

---

## Environmental Context (Future)

Examples

Weather

Temperature

Rain

Heat

Season

These factors may influence hydration, activity and outdoor recommendations.

---

# Opportunity Detection

One of the Context Engine's primary responsibilities is identifying opportunities.

An opportunity is a moment where completing a healthy behaviour requires minimal additional effort.

Examples

Coffee preparation

↓

Drink water.

---

Lunch order

↓

Choose extra vegetables.

---

Leaving the office

↓

Walk for ten minutes.

---

Shopping

↓

Buy healthy snacks.

---

Preparing dinner

↓

Increase protein.

Opportunity coaching should always be preferred over generic reminders.

---

# Context Scoring

Each candidate behaviour receives a context score.

Possible evaluation dimensions include:

* Time suitability
* Routine alignment
* Location compatibility
* Activity compatibility
* Opportunity availability
* Required effort
* Probability of completion

The Context Engine does not calculate health impact.

It evaluates situational fit.

---

# Behaviour Filtering

Some behaviours become impossible in certain contexts.

Example

Behaviour

Walk outside.

Context

Heavy rain.

↓

Filtered.

---

Behaviour

Choose grilled chicken.

Context

Already finished dinner.

↓

Filtered.

---

Behaviour

Refill water bottle.

Context

No bottle available.

↓

Filtered.

The engine should remove behaviours that cannot reasonably be completed.

---

# Behaviour Ranking

After filtering, remaining behaviours are ranked according to contextual relevance.

Example

Recommendation

Increase Water

Candidate Behaviours

* Drink while making coffee
* Drink before lunch
* Refill bottle
* Buy bottled water
* Drink after workout

Current Context

Morning

Coffee routine active

↓

Selected Behaviour

Drink one glass while making coffee.

---

# Context Confidence

Not every context source is equally reliable.

The engine should maintain confidence levels.

Examples

Time

Confidence

Very High

---

Location

Confidence

Medium

---

Calendar

Confidence

Medium

---

Routine Detection

Confidence

Variable

When confidence is low, behaviours should remain conservative and broadly applicable.

---

# Context Without Data

The engine must continue functioning even when contextual information is limited.

Examples

No location available

↓

Use time-based behaviours.

---

No routine detected

↓

Use universally applicable behaviours.

---

No activity information

↓

Choose the simplest behaviour available.

The Context Engine should degrade gracefully.

---

# Future Context Sources

The architecture supports future expansion.

Potential context providers include:

* Apple Calendar
* Apple Reminders
* Garmin
* Apple Health
* Weather
* GPS
* Bluetooth
* Smart Home
* Vehicle Detection
* Focus Mode
* Travel Detection

Each provider enriches behaviour selection without changing the Decision Engine.

---

# Relationship with Other Components

Knowledge Model

Defines what the system knows.

---

Decision Engine

Defines what should improve.

---

Behaviour Library

Defines possible actions.

---

Context Engine

Selects the behaviour that best fits the current situation.

---

Priority Matrix

Determines whether the selected behaviour should become today's coaching focus.

---

LLM

Communicates the selected behaviour naturally.

---

# Guiding Principle

The best health advice is not the most intelligent advice.

It is the advice that the user is most likely to act on right now.

The Context Engine exists to maximize the probability of successful behaviour by matching the right action to the right moment.

