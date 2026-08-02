# Ümit Diet Companion

## Documentation

| Topic | Document |
|--------|----------|
| Vision | Product/Vision.md |
| Product Philosophy | Product/ProductPrinciples.md |
| Onboarding | Product/OnboardingExperience.md |
| Roadmap | Product/Roadmap.md |
| Coach Architecture | Architecture/CoachArchitecture.md |
| Behaviour Rules | Behaviour/*.md |
| Architecture Decisions | ADR/*.md |

An AI-powered health companion that helps people build healthier habits by recommending one meaningful action at the right moment.

Instead of overwhelming users with dashboards, charts and percentages, Ümit Diet Companion focuses on behaviour.

The goal is simple:

> Help users make one better health decision every day.

Ümit Diet Companion is not a health tracking app.

It is a behaviour-first health companion.

Every recommendation is designed to help users make one better decision at the right moment.

---

# Vision

Most health applications are excellent at collecting data.

Very few help users change their behaviour.

Ümit Diet Companion combines health data, nutrition tracking and intelligent behaviour coaching into a single experience.

The application is not designed to replace doctors, dietitians or fitness coaches.

Instead, it acts as a friendly daily companion that quietly encourages healthier habits.

---

# Product Philosophy

The project is built around a few simple principles.

## Action First Coaching

Every recommendation should answer three questions.

- What is the current problem?
- What is the best action the user can take right now?
- Why is that action important?

The coach never reports metrics without suggesting an action.

---

## Context Before Coaching

Recommendations should always consider the user's lifestyle.

Examples:

- Intermittent Fasting
- Vegetarian / Vegan
- Office Worker
- Field Worker
- Smoking
- Alcohol
- Exercise Habits

The same health problem may require different advice for different users.

---

## Progressive Profiling

The application should never overwhelm users with long onboarding forms.

Instead, it gradually learns about the user over time.

Every new answer makes future coaching more personal.

---

## Friendly Health Companion

The application is not a doctor.

The application is not a strict coach.

It behaves like a supportive friend who genuinely wants the user to become healthier.

---

## Notification Philosophy

Notifications should never create guilt.

Notifications should create curiosity.

The ideal reaction is:

> "I wonder what my companion wants to tell me today."

Every notification should provide value even if the application is never opened.

---

# Current Features

## Dashboard

- Daily Health Score
- Weight Tracking
- Water Tracking
- Step Tracking
- Sleep Tracking
- Calories

---

## Behaviour Intelligence

- Behaviour Engine
- Rule Based Coaching
- Time Aware Recommendations
- AI Coach
- Daily Health Score

---

## Nutrition

- Meal Tracking
- Calories
- Protein
- Carbohydrates
- Fat

---

## Apple Health

- Steps
- Sleep
- Weight
- Calories
- Heart Rate

---

## Garmin

Current version:

Manual integration.

Future versions:

- Garmin Health API
- Recovery
- Body Battery
- Stress
- HRV

---

# Behaviour Engine

The Behaviour Engine separates decision making from message generation.

```
Health Data
      │
      ▼
Health Status
      │
      ▼
Behaviour Engine
      │
      ▼
Behaviour Rules
      │
      ▼
Behaviour Recommendation
      │
      ▼
Coach Message
      │
      ▼
Dashboard
```

This architecture allows new coaching behaviours to be added without modifying existing logic.

---

# Roadmap

## Sprint 1

- Dashboard
- Theme
- Health Score

## Sprint 2

- Health Metrics
- AI Coach
- Daily Snapshot

## Sprint 3

- Behaviour Engine
- Rule Architecture
- Decision System

## Sprint 4

- Behaviour Catalogue
- Sleep Intelligence
- Water Intelligence
- Movement Intelligence

## Sprint 5

- Recovery Intelligence
- Progressive Profiling
- Notification Engine

## Sprint 6

- Apple Health Improvements
- Garmin Health API
- AI Foundation Integration

---

# Technologies

- SwiftUI
- HealthKit
- Foundation Models
- Git
- GitHub

---

# Long-Term Vision

The long-term goal is not to build another health tracker.

The long-term goal is to build a personal health companion that users enjoy interacting with every day.

Success is measured not by how many charts the application displays, but by how many healthy habits it helps users build.

---

# Architecture Diagram

Dashboard
      │
      ▼
AICoachService
      │
      ▼
BehaviourEngine
      │
      ▼
BehaviourRule
      │
      ▼
BehaviourRecommendation
      │
      ▼
CoachMessageFactory
      │
      ├── SleepMessageFactory
      ├── WaterMessageFactory
      ├── MovementMessageFactory
      ├── NutritionMessageFactory
      └── RecoveryMessageFactory

Developed by

Ümit Ünsoy
