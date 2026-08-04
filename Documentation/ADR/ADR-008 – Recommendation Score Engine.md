# ADR-008 – Recommendation Score Engine

## Status

Accepted

---

## Context

The companion may generate multiple valid coaching recommendations at any given moment.

Selecting the first matching recommendation based on rule order can produce repetitive or suboptimal coaching.

The companion should instead evaluate all possible recommendations and select the most appropriate one for the current context.

---

## Decision

Each Behaviour Rule will produce a Recommendation Score instead of acting as a simple pass/fail filter.

The final recommendation score is calculated as:

Recommendation Score

=

Need Score

+

Time Modifier

+

Context Modifier

+

Memory Modifier

+

Personality Modifier

The recommendation with the highest score will be presented to the user.

---

## Score Components

### Need Score

Represents how important the recommendation is based on the user's current health metrics.

Examples:

- Very low water intake
- Poor sleep
- Low movement
- Poor nutrition
- Low recovery

---

### Time Modifier

Adjusts importance according to the current phase of the day.

Example:

- Morning increases the importance of hydration.
- Evening increases the importance of recovery and sleep.

---

### Context Modifier

Adjusts the score using contextual information.

Examples:

- Weekend
- Current activity
- Future calendar events
- Weather (future)
- Stress level (future)

---

### Memory Modifier

Reduces repetitive coaching.

Examples:

- The same recommendation was already shown today.
- The same behaviour has been repeated several times.
- Another behaviour should now be prioritised.

---

### Personality Modifier

Adjusts recommendation selection according to the user's preferred coaching personality.

Examples:

- Challenger may slightly favour action-oriented behaviours.
- Supportive may slightly favour recovery and encouragement.
- Balanced applies minimal adjustment.

---

## Rationale

This scoring model allows the companion to:

- Prioritise the most valuable recommendation.
- Avoid repetitive coaching.
- Adapt naturally throughout the day.
- Scale without increasing rule complexity.
- Introduce new modifiers without changing existing Behaviour Rules.

---

## Consequences

### Positive

- More intelligent recommendation selection.
- Flexible architecture.
- Easily extensible.
- Better long-term user engagement.
- Behaviour Rules remain simple and independent.

### Negative

- Slightly more computation.
- Requires score calibration and tuning.

---

## Future

Possible future modifiers include:

- Weather
- HRV
- Resting Heart Rate
- Body Battery
- Stress
- Calendar
- Travel
- User habits

