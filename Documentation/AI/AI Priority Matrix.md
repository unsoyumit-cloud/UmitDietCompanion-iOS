# AI Priority Matrix

**Project:** Ümit Diet Companion
**Sprint:** Sprint 5 – Intelligence
**Version:** 1.0 (Draft)
**Status:** Design Phase

---

# Purpose

The Priority Matrix is responsible for selecting **one coaching action** from all available candidates.

It does not generate insights.

It does not generate recommendations.

It does not create behaviours.

Its only responsibility is to answer one question:

> **"Which behaviour should become today's coaching message?"**

---

# Design Philosophy

Every day contains many opportunities for improvement.

Users should never receive all of them.

The Priority Matrix intentionally reduces complexity.

The objective is not to solve every health problem.

The objective is to maximize the probability of one successful behaviour today.

One completed action is more valuable than five ignored suggestions.

---

# Position in the Intelligence Pipeline

```text
Knowledge Model
        │
Observation Engine
        │
Insight Engine
        │
Recommendation Engine
        │
Behaviour Library
        │
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

Everything before the Priority Matrix generates possibilities.

The Priority Matrix chooses one.

---

# Inputs

The Priority Matrix receives a list of candidate behaviours.

Each candidate already contains:

* Recommendation
* Behaviour
* Context Score
* Insight Source
* Related Metric
* Estimated Impact
* Behaviour Difficulty
* Time Relevance

Example

```text
Candidate A

Drink one glass of water.

Context Score = 82
```

```text
Candidate B

Walk for 10 minutes.

Context Score = 77
```

```text
Candidate C

Choose grilled chicken.

Context Score = 68
```

---

# Scoring Philosophy

The Priority Matrix should not reward urgency alone.

It balances multiple dimensions to identify the action most likely to create meaningful progress.

Every candidate receives a **Priority Score**.

The candidate with the highest score becomes the coaching focus.

---

# Scoring Factors

## 1. Health Impact

Question:

> If completed, how much does this behaviour improve the user's health?

Examples

High

* Sleep
* Recovery
* Severe dehydration

Medium

* Daily movement
* Protein

Lower

* Minor optimisation

Suggested Weight

35%

---

## 2. Context Fit

Question:

> Does this behaviour match the user's current situation?

Examples

Morning

↓

Drink water

High

---

Night

↓

Go for a walk

Low

Suggested Weight

20%

---

## 3. Time Relevance

Question

> Is this the right moment?

Examples

Morning

↓

Plan the day

High

---

23:30

↓

Improve breakfast

Very Low

Suggested Weight

15%

---

## 4. Behaviour Cost

Question

> How difficult is this action?

Examples

Drink water

Very Low

---

Cook a new meal

Medium

---

Visit a gym

High

Lower effort generally receives a higher score because it is more likely to happen.

Suggested Weight

10%

---

## 5. Momentum

Question

> Can this action create positive momentum for the rest of the day?

Examples

Morning hydration

High

---

Preparing tomorrow's breakfast

High

---

Small optimisation after dinner

Lower

Suggested Weight

10%

---

## 6. Progress Balance

Question

> Has this area already been addressed today?

If yes,

reduce priority.

The system should avoid repeatedly coaching the same topic.

Suggested Weight

10%

---

# Priority Formula

The exact implementation is intentionally separated from this document.

Conceptually, the Priority Score is calculated using weighted contributions from:

* Health Impact
* Context Fit
* Time Relevance
* Behaviour Cost
* Momentum
* Progress Balance

Weights may evolve as the product matures, but the evaluation dimensions should remain stable.

---

# Candidate Elimination

Before scoring, behaviours may be removed.

Examples

Impossible in current context

↓

Discard.

---

Already completed

↓

Discard.

---

No supporting data

↓

Discard.

---

Duplicate recommendation

↓

Discard.

The Priority Matrix only evaluates valid candidates.

---

# Tie Resolution

If two behaviours receive similar scores, preference should be given in the following order:

1. Higher probability of completion
2. Lower effort
3. Higher health impact
4. Greater behavioural variety
5. Earlier opportunity window

This ensures stable and predictable behaviour.

---

# Diversity Rules

The engine should avoid repetitive coaching.

Examples

If hydration was selected yesterday and movement has a similar score today,

prefer movement.

Behavioural diversity helps maintain user engagement while supporting balanced health improvement.

---

# Fatigue Prevention

The engine should avoid repeatedly selecting behaviours that require high effort.

Instead,

alternate between:

* Easy wins
* Moderate improvements
* Recovery actions
* Planning behaviours

Consistency is more valuable than intensity.

---

# Emergency Override

Some situations should bypass normal scoring.

Examples

* Extremely low sleep
* Severe dehydration
* Dangerous alcohol intake
* Missing meals after intense exercise

Critical health situations may receive automatic priority regardless of other factors.

Emergency rules should remain limited and clearly defined.

---

# Example Evaluation

Current Situation

* Morning
* Water behind target
* Protein behind target
* Low step count
* Coffee routine detected

Candidates

| Behaviour               | Impact |   Context | Priority |
| ----------------------- | -----: | --------: | -------: |
| Drink water with coffee |   High | Excellent |       92 |
| Walk for 10 minutes     | Medium |      Good |       76 |
| Add protein to lunch    | Medium |      Fair |       68 |

Selected Behaviour

```text
Drink one glass of water while preparing coffee.
```

---

# Explainability

Every selected behaviour should include an explanation.

Example

```text
Selected

Drink water with coffee.
```

Reason

```text
Highest health impact.

Excellent context fit.

Low effort.

Immediate opportunity.

High probability of completion.
```

This information should be available in developer debugging tools.

---

# Future Learning

The Priority Matrix should eventually learn from user behaviour.

Future signals may include:

* Acceptance rate
* Completion history
* Ignored recommendations
* Favourite behaviour types
* Long-term effectiveness

Learning should adjust scores without changing the overall evaluation framework.

---

# Relationship with Other Components

Knowledge Model

Provides health knowledge.

---

Decision Engine

Determines what should improve.

---

Behaviour Library

Provides possible actions.

---

Context Engine

Evaluates situational suitability.

---

Priority Matrix

Chooses the single best behaviour.

---

LLM

Communicates the chosen behaviour naturally.

---

# Guiding Principle

The Priority Matrix should not ask:

> "Which behaviour is theoretically best?"

It should ask:

> **"Which behaviour gives this user the greatest chance of taking one meaningful step toward better health right now?"**

That single decision defines today's coaching experience.

