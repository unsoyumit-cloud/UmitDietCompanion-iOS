# ADR-002 - One Rule One Behaviour

**Status:** Accepted

**Date:** 2026-08-02

---

# Context

Behaviour rules can easily become large and difficult to maintain.

---

# Decision

Every BehaviourRule should solve exactly one behaviour problem.

Each rule should:

- Detect one situation.
- Recommend one action.
- Return one BehaviourRecommendation.

Rules should remain small (approximately 20–40 lines).

---

# Consequences

Benefits

- Easy to understand.
- Easy to test.
- Easy to replace.
- Easy to extend.

Trade-offs

- Higher number of files.
- Lower complexity per file.

---

# Examples

Good

- SleepMorningRule
- WaterEveningRule

Avoid

- DailyHealthRule
- CoachDecisionRule
