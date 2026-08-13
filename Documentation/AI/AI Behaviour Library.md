# AI Behaviour Library

**Project:** Ümit Diet Companion
**Sprint:** Sprint 5 – Intelligence
**Version:** 1.0 (Draft)
**Status:** Design Phase

---

# Purpose

This document defines **how the AI transforms recommendations into real-life actions**.

The Decision Engine decides **what** should be improved.

The Behaviour Library defines **how that improvement can realistically happen**.

This library is the bridge between health science and everyday life.

Its purpose is not to educate.

Its purpose is to help users succeed.

---

# Design Philosophy

Health advice is easy.

Behaviour change is difficult.

People rarely fail because they do not know what is healthy.

They fail because healthy actions do not naturally fit into their daily lives.

The Behaviour Library exists to solve this problem.

Every behaviour should feel:

* Easy
* Natural
* Specific
* Contextual
* Achievable

The best behaviour is not the perfect behaviour.

It is the behaviour most likely to happen.

---

# Behaviour Architecture

```text
Recommendation
        │
        ▼
Behaviour Candidates
        │
        ▼
Context Filtering
        │
        ▼
Opportunity Selection
        │
        ▼
Final Behaviour
```

The library stores possible behaviours.

The Decision Engine selects one.

---

# Behaviour Object

Each behaviour is a structured object rather than a sentence.

Every behaviour should contain:

* Behaviour ID
* Target Metric
* Recommendation
* Action
* Context
* Time Relevance
* Difficulty
* Estimated Duration
* Required Resources
* Opportunity Trigger
* Expected Impact
* Repeatability

---

# Behaviour Categories

The library organizes behaviours by intention rather than by metric.

---

## Add

Introduce something beneficial.

Examples

* Drink a glass of water.
* Add vegetables to lunch.
* Eat Greek yogurt.
* Walk for ten minutes.

---

## Replace

Swap one behaviour for a better alternative.

Examples

* Replace fries with salad.
* Choose grilled chicken instead of fried food.
* Replace soda with sparkling water.

---

## Remove

Reduce unnecessary behaviour.

Examples

* Skip the second dessert.
* Avoid late-night snacks.
* Reduce alcohol tonight.

---

## Delay

Create a pause before acting.

Examples

* Wait ten minutes before snacking.
* Drink water before ordering food.
* Walk first, then decide if you still want a snack.

---

## Prepare

Make future success easier.

Examples

* Refill your water bottle.
* Pack healthy snacks.
* Prepare tomorrow's breakfast.
* Charge your Garmin watch.

---

## Maintain

Protect an already positive habit.

Examples

* Keep your sleep routine.
* Continue today's hydration.
* Maintain your walking streak.

---

# Behaviour Context

The same recommendation may require different behaviours depending on context.

Possible contexts include:

* Home
* Office
* Restaurant
* Grocery Store
* Coffee Shop
* Gym
* Walking Outside
* Travelling
* Weekend
* Weekday

The engine should always prefer behaviours that match the user's current situation.

---

# Time Awareness

Behaviours have preferred execution windows.

## Morning

Best suited for:

* Hydration
* Breakfast
* Planning
* Motivation
* Habit preparation

---

## Midday

Best suited for:

* Lunch choices
* Walking
* Water
* Protein
* Energy management

---

## Evening

Best suited for:

* Dinner quality
* Recovery
* Reflection
* Alcohol moderation

---

## Night

Best suited for:

* Sleep preparation
* Screen reduction
* Relaxation
* Tomorrow's preparation

A behaviour should never be selected outside its meaningful time window unless no suitable alternative exists.

---

# Opportunity Coaching

The Behaviour Library supports opportunity-based coaching.

The goal is not to interrupt the user.

The goal is to recognize moments where success is naturally easier.

Examples:

* While preparing coffee → drink a glass of water.
* Before lunch → eat vegetables first.
* After finishing a meeting → take a short walk.
* While shopping → buy high-protein options.
* Waiting for the elevator → use the stairs instead.

These moments are called **Opportunity Triggers**.

---

# Behaviour Selection Criteria

When multiple behaviours are available, the Decision Engine should prefer behaviours that score highly across the following dimensions:

* High probability of completion
* Low effort
* Immediate availability
* Positive health impact
* Alignment with current context
* Alignment with time of day
* Reinforcement of existing habits

---

# Behaviour Examples

## Hydration

Recommendation

Increase Water Intake

Possible Behaviours

* Drink one glass before coffee.
* Drink water before lunch.
* Refill your bottle after every meeting.
* Keep a bottle on your desk.
* Finish one bottle before leaving work.

---

## Protein

Recommendation

Increase Protein

Possible Behaviours

* Add Greek yogurt to breakfast.
* Choose grilled chicken for lunch.
* Add cottage cheese as a snack.
* Include eggs in breakfast.
* Prepare a protein-rich dinner.

---

## Activity

Recommendation

Increase Movement

Possible Behaviours

* Walk during your next phone call.
* Park farther away.
* Use the stairs.
* Take a ten-minute walk after lunch.
* Stand up every hour.

---

## Sleep

Recommendation

Improve Sleep

Possible Behaviours

* Put your phone away 30 minutes before bed.
* Dim the lights after dinner.
* Prepare tomorrow's clothes early.
* Avoid caffeine late in the day.
* Go to bed 20 minutes earlier.

---

## Alcohol

Recommendation

Reduce Alcohol

Possible Behaviours

* Alternate alcoholic drinks with water.
* Choose one fewer drink tonight.
* Eat before drinking.
* Select a lower-alcohol option.
* Skip the final drink.

---

# Behaviour Difficulty

Every behaviour includes a difficulty level.

Levels:

* Very Easy
* Easy
* Moderate
* Difficult

The engine should generally favour easier behaviours unless a stronger intervention is justified.

---

# Behaviour Duration

Each behaviour includes an estimated completion time.

Examples

* Less than 1 minute
* 5 minutes
* 10 minutes
* 30 minutes
* Ongoing throughout the day

Short actions are often better candidates for coaching because they reduce friction.

---

# Behaviour Dependencies

Some behaviours require conditions to be true.

Examples:

"Walk after lunch"

Requires:

* Lunch completed

---

"Choose grilled chicken"

Requires:

* Eating at a restaurant

---

"Prepare breakfast"

Requires:

* Evening context

Behaviours whose prerequisites are not satisfied should not be considered.

---

# Behaviour Rotation

The engine should avoid repeating the same behaviour unnecessarily.

If multiple behaviours have similar value, preference should be given to one that has not been suggested recently.

Rotation keeps coaching fresh while preserving consistency.

---

# Behaviour Success

The library should support future learning.

Each behaviour may eventually store:

* Selection count
* Completion rate
* User acceptance
* Long-term effectiveness
* Preferred contexts

This allows future personalization without changing the Behaviour Library itself.

---

# Relationship with Other Components

The Behaviour Library does not decide priorities.

It does not generate recommendations.

It does not create coaching messages.

Its only responsibility is to provide a rich catalogue of realistic actions that the Decision Engine can choose from.

---

# Guiding Principle

A recommendation changes nothing.

A completed behaviour changes everything.

The Behaviour Library exists to ensure that every coaching message leads to an action that feels achievable in the user's real life.

