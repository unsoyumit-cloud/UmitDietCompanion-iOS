# Architecture Decisions

This document records important architectural decisions made during development.

---

## 2026-07-24

### AI Coach Architecture

Decision:

Use a Rule Engine instead of large conditional statements.

Reason:

- Easy to extend
- Easy to test
- Follows Open/Closed Principle

---

## 2026-07-24

### One Next Action

Decision:

The coach recommends only one action at a time.

Reason:

Users are more likely to complete one simple behaviour than several recommendations simultaneously.

---

## 2026-07-24

### Behaviour Rules

Decision:

Each BehaviourRule evaluates only one situation.

Reason:

Small independent rules are easier to maintain and improve.

---

## 2026-07-24

### Behaviour Engine Responsibility

Decision:

The BehaviourEngine selects the best recommendation.

It never generates user-facing text.

Reason:

Decision logic and presentation should remain separate.

# Product Decisions

## PD-001 - Action First Coaching

The coach must never simply report metrics.

Every recommendation must answer:

1. What is the current problem?
2. What is the best action the user can take right now?
3. Why is that action important now?

Only one primary action should be shown at a time.
Recommendations must change depending on the current phase of the day.
