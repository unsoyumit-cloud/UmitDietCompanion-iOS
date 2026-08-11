# AI Context Architecture

Version: 1.0

Project: Ümit Diet Companion

---

# Philosophy

The quality of an AI Coach is determined by the quality of its context.

The Foundation Model should never guess.

The application must prepare a rich, structured context before asking the model to generate a response.

The AI receives context.

The AI generates language.

---

# AI Context

The complete AI context consists of five independent layers.

AIContext

├── UserContext
├── HealthContext
├── EnvironmentContext
├── RecommendationContext
└── ConversationContext (Future)

Each layer has a single responsibility.

---

# User Context

Represents who the user is.

Contains

• UserProfile

• UserPreferences

• CoachingProfile

• LearnedProfile

Examples

Age

Height

Target Weight

Preferred Coach Personality

Language

Units

Learned Habits

Learned Patterns

This context changes slowly.

---

# Health Context

Represents today's health status.

Generated from DailyHealthSnapshot.

Contains

Health Score

Weight

Water

Calories

Nutrition

Steps

Sleep

Recovery

Heart

Trend

Today's Progress

Today's Goals

This context changes continuously.

---

# Environment Context

Represents what is happening around the user.

This context depends on permissions.

Possible sources

Current Time

Day Phase

Calendar

Location

Weather

Travel Status

Office / Home

Workout

Current Activity

Battery Saver

Connectivity

Examples

Morning

Busy Meeting Day

At Grocery Store

At Gym

Raining

Weekend

Traveling

This context is optional.

The application must work without it.

---

# Recommendation Context

Represents today's coaching decision.

Contains

Selected Recommendation

Reason

Behaviour

Confidence

Priority

Recommendation History

Ignored Recommendations

Recent Success

Today's Focus

The Foundation Model never changes this recommendation.

---

# Conversation Context

Future

Contains

Recent Messages

Recent Conversations

Coach Memory

Topics Already Discussed

Conversation Style

This layer will be introduced with conversational AI.

---

# Permission Model

Every permission unlocks additional coaching capabilities.

HealthKit

↓

Health Context

---

Calendar

↓

Busy Day Detection

Meeting Awareness

---

Location

↓

Opportunity Coaching

Nearby Healthy Decisions

Routine Detection

---

Weather

↓

Outdoor Recommendations

Hydration Adjustments

Walking Suggestions

---

Notifications

↓

Proactive Coaching

Habit Reinforcement

---

# Earned Intelligence

The AI becomes smarter as the user shares more context.

No permission is mandatory.

Every permission increases personalization.

Never reduce usability when permissions are denied.

---

# Opportunity Coaching

The coach should speak when success is easiest.

Examples

Coffee Shop

↓

Suggest Water

---

Grocery Store

↓

Suggest Protein

---

Gym

↓

Suggest Hydration

---

Office

↓

Suggest Short Walk

---

Home Evening

↓

Suggest Earlier Sleep

Opportunity Coaching should always feel helpful.

Never intrusive.

---

# Learned Intelligence

The AI continuously discovers patterns.

Examples

Preferred walk time

Hydration habits

Meal timing

Office days

Travel habits

Weekend behaviour

Reminder effectiveness

Preferred coaching style

The user does not enter these values.

The application learns them.

---

# Privacy

The AI never stores raw personal events.

It stores insights.

Good

Usually walks after dinner.

Bad

Walked at 19:42 yesterday.

Good

Often shops on Sunday.

Bad

Visited Migros at 18:13.

The AI remembers behaviour.

Not surveillance.

---

# Context Flow

User

↓

Health Data

↓

User Context

↓

Environment Context

↓

Recommendation Engine

↓

Reasoning Engine

↓

Prompt Builder

↓

Foundation Model

↓

Coach Message

---

# Guiding Principle

Health data tells the AI what happened.

Context explains why it happened.

Opportunity determines when to help.

The AI should not simply recommend healthier choices.

It should identify the easiest moment for the next healthy decision.
