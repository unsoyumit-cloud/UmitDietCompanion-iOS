
# ADR-005 — Behaviour Priority Engine

## Status

Accepted

---

# Context

Users often have multiple health opportunities at the same time.

For example:

- Low hydration
- Poor sleep
- Low movement
- High calorie intake

Showing every possible recommendation at once creates noise,
reduces engagement and leads to decision fatigue.

The AI Coach should always focus on **one primary coaching opportunity**.

This ADR defines how the AI determines that priority.

---

# Decision

The AI Coach will never generate multiple competing primary recommendations.

Instead, the system will evaluate every observation, insight and recommendation,
then select a single primary behaviour with the highest coaching value.

The remaining opportunities may be used as supporting context but will not replace
the primary recommendation.

---

# Behaviour Priority Pipeline

```
Health Data
      │
      ▼
Observations
      │
      ▼
Insights
      │
      ▼
Recommendations
      │
      ▼
Behaviour Priority Engine
      │
      ▼
Reasoning
      │
      ▼
Coach Message
```

---

# Evaluation Factors

Every recommendation is evaluated using multiple dimensions.

## Health Impact

How much benefit can the user gain?

Examples

- Severe dehydration
- Very poor sleep
- Extremely low movement

Higher impact increases priority.

---

## Opportunity

Can the recommendation realistically be completed today?

Examples

Drink water ✔

Walk after lunch ✔

Sleep 8 hours at 16:00 ✘

Higher opportunity increases priority.

---

## Timing

Recommendations must respect the current phase of the day.

Morning

Planning

Afternoon

Execution

Evening

Reflection

Night

Recovery

A recommendation that no longer makes sense for the current time loses priority.

---

## Confidence

The AI should prioritize recommendations supported by stronger evidence.

Low confidence recommendations should not override high confidence ones.

---

## Coaching Value

The AI should maximize positive behavioural change.

Small achievable actions are preferred over unrealistic goals.

Examples

Drink 500 ml water ✔

Run 10 km ✘

---

# Conflict Resolution

Multiple recommendations are common.

The Behaviour Priority Engine resolves conflicts by selecting
the recommendation with the highest overall coaching value.

Example

Hydration Low

Movement Low

Sleep Poor

↓

Sleep receives highest priority because recovery affects multiple
health dimensions.

---

# Priority Principles

The AI should

- reduce cognitive load
- encourage one clear action
- avoid overwhelming the user
- maximize long-term adherence

---

# Output

The Behaviour Priority Engine produces exactly one primary recommendation.

It also provides reasoning explaining why that recommendation won.

Example

Primary Recommendation

Drink Water

Reason

Hydration is currently the lowest health metric and can be improved immediately.

---

# Future Extensions

Future versions may also consider

- Weather
- Calendar
- User habits
- Garmin readiness
- Recovery score
- Previous coaching history
- Success probability
- Behaviour learning

---

# Design Philosophy

The AI Coach should not behave like a checklist.

It should behave like an experienced human coach.

A good coach rarely gives five instructions at once.

Instead, the coach identifies the single action that will create
the greatest positive impact at that moment.

The Behaviour Priority Engine exists to make that decision consistently.
