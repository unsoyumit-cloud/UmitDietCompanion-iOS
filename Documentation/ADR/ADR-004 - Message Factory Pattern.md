# ADR-004 - Message Factory Pattern

**Status:** Accepted

**Date:** 2026-08-02

---

# Context

As coaching domains increase, one message factory becomes difficult to maintain.

---

# Decision

Each coaching domain owns its own Message Factory.

Examples

- SleepMessageFactory
- WaterMessageFactory
- MovementMessageFactory
- NutritionMessageFactory
- RecoveryMessageFactory

CoachMessageFactory only dispatches requests.

---

# Consequences

Benefits

- Small factories.
- Clear ownership.
- Independent development.
- Easy localisation.

Trade-offs

- More files.
- Better maintainability.

