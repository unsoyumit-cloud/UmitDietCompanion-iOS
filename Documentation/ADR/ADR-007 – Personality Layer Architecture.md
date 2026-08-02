# ADR-007 – Personality Layer Architecture

## Status

Accepted

---

## Context

Behaviour Rules determine **what** recommendation should be given.

The way the recommendation is communicated should remain independent from the behaviour itself.

Mixing behaviour logic with communication style would increase duplication and reduce maintainability.

---

## Decision

The coaching system is divided into two independent layers.

### Behaviour Layer

Responsible for deciding:

- What behaviour should be recommended.
- Recommendation priority.
- Recommendation reason.

### Personality Layer

Responsible for deciding:

- How the recommendation should be communicated.
- Tone of voice.
- Encouragement level.
- Emoji usage.
- Sentence style.

The Behaviour Layer must never contain personality-specific text.

---

## Architecture

Behaviour Engine

↓

Behaviour Recommendation

↓

Coach Message Factory

↓

Base Coach Message

↓

Personality Engine

↓

Final Coach Message

---

## Rationale

Separating behaviour from personality follows the Single Responsibility Principle.

It allows:

- Multiple coaching personalities.
- Consistent behaviour logic.
- Easier maintenance.
- Cleaner message generation.
- Future expansion without changing Behaviour Rules.

---

## Consequences

### Positive

- Behaviour and communication evolve independently.
- New personalities can be added without modifying existing Behaviour Rules.
- Better scalability.
- Cleaner architecture.

### Negative

- One additional processing layer.
- Slightly more classes.

---

## Future

Planned personalities:

- 🤝 Supportive
- ⚖️ Balanced
- 💪 Challenge Me

Additional personalities may be introduced in future releases without changing Behaviour Rules.
