# Contributing

Thank you for your interest in Ümit Diet Companion.

This project is currently under active development.

## Development Principles

The project follows a few simple engineering principles.

### Build First

Every change should compile successfully.

Never leave the repository in a broken state.

### Small Commits

Each commit should represent one meaningful improvement.

Avoid mixing unrelated changes.

### Real Device Testing

HealthKit features should always be tested on a physical iPhone whenever possible.

Simulator testing is acceptable only for UI changes.

### Architecture

The project follows a layered architecture.

```
Dashboard
      │
      ▼
HealthStore
      │
      ▼
Providers
      │
      ▼
Services
      │
      ▼
Calculators
```

Responsibilities should remain separated.

- Views display information.
- Stores manage state.
- Providers gather data.
- Services communicate with Apple frameworks.
- Calculators contain business logic.

### Coding Style

- Prefer readable code over clever code.
- Keep functions focused on one responsibility.
- Avoid duplicated logic.
- Prefer composition over large classes.

### Git Workflow

Typical workflow:

```
Feature

↓

Build

↓

Real Device Test

↓

Commit

↓

Push

↓

Tag (Sprint Complete)
```

### Documentation

Please keep the following files up to date whenever significant changes are made.

- README.md
- CHANGELOG.md
- ROADMAP.md

## Project Goal

Ümit Diet Companion is not designed to be another health tracking application.

The goal is to build an AI-powered health companion that helps users make one better health decision every day.
