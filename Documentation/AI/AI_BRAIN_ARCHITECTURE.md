# AI Brain Architecture

Version: 1.0

Project: Ümit Diet Companion

---

# Vision

The AI Brain is responsible for transforming health data into meaningful coaching.

It does not simply generate recommendations.

It observes.

It understands.

It learns.

It identifies opportunities.

It prioritizes.

It coaches.

It improves over time.

The AI Brain exists to answer one question:

"What is the most valuable thing I can do for this user right now?"

---

# Design Principles

Every engine has a single responsibility.

No engine should perform another engine's work.

Each engine receives structured input and produces structured output.

The Foundation Model is only responsible for language generation.

The application owns the decision-making process.

---

# Brain Pipeline

                Daily Snapshot
                       │
                       ▼
             Observation Engine
                       │
                       ▼
               Insight Engine
                       │
                       ▼
            Opportunity Engine
                       │
                       ▼
              Priority Engine
                       │
                       ▼
              Coaching Engine
                       │
                       ▼
                 Coach Feed
                       │
                       ▼
              Learning Engine
                       │
                       ▼
               Learned Profile

Each engine solves one specific problem.

---

# Observation Engine

Purpose

Observe what is happening.

Responsibility

Convert raw health and context data into meaningful observations.

Input

Health Context

User Context

Environment Context

Output

Observation[]

Examples

Water intake below expected.

Protein goal is incomplete.

Recovery is poor.

Busy meeting day.

User is at grocery store.

Weekend detected.

Never

Never recommend.

Never prioritize.

Never generate messages.

---

# Insight Engine

Purpose

Understand why observations matter.

Responsibility

Identify patterns, trends and relationships.

Input

Observation[]

Learned Profile

Output

Insight[]

Examples

Meeting days reduce hydration.

Better sleep improves recovery.

Weekend routines increase activity.

Protein intake drops on travel days.

Never

Never create actions.

Never coach.

Never write messages.

---

# Opportunity Engine

Purpose

Find the easiest moment for success.

Responsibility

Transform insights into contextual opportunities.

Input

Insight[]

Environment Context

Permissions

Output

Opportunity[]

Examples

Coffee shop

↓

Drink water.

Grocery store

↓

Buy protein.

Office

↓

Walk after meeting.

Gym

↓

Hydrate before training.

Never

Never decide priorities.

Never generate language.

---

# Priority Engine

Purpose

Select today's single priority.

Responsibility

Evaluate every opportunity, insight and health need.

Input

Needs

Insights

Opportunities

Health Score

Recommendation Score

Output

Priority

Rules

Exactly one priority.

Always explainable.

Never overwhelm.

Never

Never create multiple priorities.

Never generate messages.

---

# Coaching Engine

Purpose

Transform decisions into coaching.

Responsibility

Generate natural communication.

Input

Priority

Personality

Context

AI Principles

Output

Coach Feed Cards

Foundation Prompt

Coach Message

Never

Never change priorities.

Never change health decisions.

Never invent health data.

---

# Learning Engine

Purpose

Become smarter over time.

Responsibility

Update Learned Profile.

Measure what works.

Input

User behaviour

Dismissed cards

Completed actions

Health improvements

Feedback

Output

Updated Learned Profile

Examples

User prefers evening walks.

Celebration cards increase engagement.

Morning reminders are ignored.

Opportunity coaching is effective.

Never

Never manipulate behaviour.

Never create fake learning.

Never overwrite user preferences.

---

# Validation Layer

Every output passes validation before reaching the user.

Validation checks

Medical Safety

Repetition

Tone

Context

Priority consistency

Length

Language quality

AI Principles

Only validated content reaches the Coach Feed.

---

# Context Sources

User Context

Health Context

Environment Context

Recommendation Context

Conversation Context (Future)

Each engine may use only the context it requires.

Unused context should not be passed.

---

# Learning Cycle

Observe

↓

Understand

↓

Find Opportunity

↓

Prioritize

↓

Coach

↓

Measure Outcome

↓

Learn

↓

Improve

This loop repeats every day.

---

# Explainability

Every coaching message must be explainable.

The AI must always know why it selected a priority.

The application should always be able to answer:

Why this recommendation?

Why now?

Why not another recommendation?

Explainability builds trust.

---

# Privacy

The AI learns behaviour.

Not personal secrets.

The AI stores patterns.

Not surveillance.

The AI remembers habits.

Not locations.

Privacy is a product feature.

Not a legal requirement.

---

# Foundation Model

The Foundation Model is not the brain.

It is the voice.

The brain thinks.

The model speaks.

Business logic never leaves the application.

---

# Success Criteria

The user should feel

Understood

Supported

Motivated

Respected

The user should never feel

Judged

Manipulated

Overwhelmed

Monitored

---

# North Star

The AI Brain does not try to control behaviour.

It identifies the smallest possible action that creates the biggest long-term health improvement.
