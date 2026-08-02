# ADR-001 - Behaviour-First Architecture

**Status:** Accepted

**Date:** 2026-08-02

---

# Context

Traditional health applications mainly present health data such as steps, calories, water intake or sleep.

The goal of Ümit Diet Companion is different.

Instead of displaying data, the application should help users make one better decision at the right moment.

---

# Decision

The application will use a Behaviour-First Architecture.

Health metrics are only inputs.

Behaviour recommendations are the primary output.

Architecture flow:

Dashboard
→ AICoachService
→ BehaviourEngine
→ BehaviourRule
→ BehaviourRecommendation
→ CoachMessageFactory
→ CoachMessage

---

# Consequences

Benefits

- Clear separation of responsibilities.
- Behaviour logic is independent from UI.
- Easy to add new coaching domains.
- Easy to test.
- Scalable architecture.

Trade-offs

- More files.
- Slightly more initial complexity.
- Better long-term maintainability.

---

# Alternatives Considered

- Large AICoachService containing all logic.
- Direct rule-to-message mapping.
- View-driven coaching logic.

These alternatives were rejected because they reduce scalability and increase coupling.
