# ADR-006 – Delayed Personality Selection

## Status

Accepted

---

## Context

The application offers multiple coaching personalities:

- 🤝 Supportive
- ⚖️ Balanced
- 💪 Challenge Me

During onboarding, the user has not yet experienced the coach.

Asking them to choose a coaching style before interacting with the companion would result in an uninformed decision.

---

## Decision

The coach personality will **not** be selected during onboarding.

All users will start with the **Balanced** personality.

After approximately one week of use, the companion will invite the user to choose their preferred coaching style.

The personality can also be changed later from the application settings.

---

## Rationale

This approach allows users to first experience the companion before making a preference decision.

It also creates a more natural relationship between the user and the coach.

Rather than configuring a setting, the user is personalising an already familiar companion.

---

## Consequences

### Positive

- Simpler onboarding.
- Faster first-time experience.
- More informed personality selection.
- Better user engagement.

### Negative

- Users cannot immediately choose a coaching style.
- Personality selection requires an additional interaction later.

---

## Future

The companion may eventually recommend a personality based on observed user behaviour.

Example:

> "I've noticed you respond well to encouraging messages. Would you like me to stay in Supportive mode?"
