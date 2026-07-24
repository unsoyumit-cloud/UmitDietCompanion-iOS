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
