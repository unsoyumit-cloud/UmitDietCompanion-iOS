# Intelligence Coverage Matrix — v1

## Status

Working Baseline

---

## Purpose

This document defines the initial **Intelligence Coverage Matrix** for Ümit Diet Companion.

The matrix is intended to answer three progressively deeper questions:

1. **What health and behavioural metrics are potentially available to the product?**
2. **Which of those metrics does the application currently collect and store?**
3. **Which collected metrics are currently analyzed, correlated and used by the Coach?**

The matrix is a working inventory and will evolve as the data-source research and codebase analysis progress.

---

## Scope

The intelligence model is intentionally broader than HealthKit alone.

Potential data sources include:

- HealthKit
- Apple Watch / wearable-derived data where accessible
- Nutrition and meal analysis
- Liquids
- Activity and workouts
- Body measurements
- Behaviour and goals
- Calendar
- Location
- Weather
- Time and temporal patterns
- Historical DailyHealthSnapshot data
- Future contextual and manually entered data

---

## Coverage Matrix

| Domain | Metric | Available | Collected | Stored | Analyzed | Correlated | Coach |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| **Sleep** | Duration | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Sleep | Sleep stages | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Sleep | HRV | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| Sleep | Respiratory quality / rate | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Nutrition** | Calories | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Nutrition | Protein | 🟢 | 🟢 | 🟢 | 🟡 | 🔴 | 🔴 |
| Nutrition | Carbohydrates | 🟢 | 🟢 | 🟢 | 🟡 | 🔴 | 🔴 |
| Nutrition | Fat | 🟢 | 🟢 | 🟢 | 🟡 | 🔴 | 🔴 |
| Nutrition | Fiber | 🟢 | 🟢 | 🟢 | 🟡 | 🔴 | 🔴 |
| Nutrition | Meal timing | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| **Liquids** | Water | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Liquids | Total liquid intake | 🟢 | 🟡 | 🟡 | 🔴 | 🔴 | 🔴 |
| Liquids | Coffee / caffeine | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| Liquids | Tea | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| Liquids | Soft drinks | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| Liquids | Alcohol | 🟡 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Activity** | Steps | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Activity | Active Energy | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Activity | Workout type | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Activity | Workout duration | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| **Heart** | Resting HR | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Heart | HRV | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| Heart | SpO₂ | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Body** | Weight | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Body | Weight trend | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| Body | Body composition | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Behaviour** | Goals | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 |
| Behaviour | Goal adherence | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| Behaviour | Streaks | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| Behaviour | Meal patterns | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| **Environment** | Calendar / meetings | 🟢 | 🟡 | 🟡 | 🔴 | 🔴 | 🔴 |
| Environment | Location | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| Environment | Travel | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| Environment | Weather | 🟢 | 🔴 | 🔴 | 🔴 | 🔴 | 🔴 |
| **Temporal** | Time of day | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| Temporal | Weekday / weekend | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |
| Temporal | Historical baseline | 🟢 | 🟢 | 🟢 | 🔴 | 🔴 | 🔴 |

---

## Status Legend

- 🟢 **Yes / available**
- 🟡 **Partial / needs verification or implementation**
- 🔴 **No / not currently implemented**

---

## Important Distinctions

### Available

A metric can theoretically be obtained by the product through an accessible data source, device capability, framework, or user input.

This column must be validated through external research before being considered final.

### Collected

The current application actively obtains the metric.

### Stored

The application persists the metric or sufficient historical information to use it later.

### Analyzed

The current intelligence layer derives meaningful state, trend, anomaly or pattern information from the metric.

### Correlated

The metric is combined with other signals to derive higher-level patterns or insights.

### Coach

The metric can currently influence a user-facing coaching decision or message.

---

## Intelligence Philosophy

The companion should not depend on an LLM to perform deterministic health-data analysis when the required information can be calculated reliably inside the application.

The intended intelligence flow is:

```text
Raw Data
    ↓
Signals
    ↓
Observations
    ↓
Trends / Patterns
    ↓
Correlations
    ↓
Insights
    ↓
Recommendations
    ↓
Coach
```

The architecture is inspired by SIEM-style correlation:

> Individual signals may be weak or meaningless in isolation; combinations of signals across time and context can reveal meaningful patterns.

---

## Example Correlations

### Alcohol and Recovery

```text
Alcohol intake
+
HRV
+
Sleep
+
Respiratory metrics
+
Recovery
    ↓
Alcohol-associated recovery pattern
```

### Caffeine and Sleep

```text
Coffee / caffeine
+
Time of consumption
+
Sleep duration
+
Sleep quality
    ↓
Caffeine-associated sleep pattern
```

### Activity and Nutrition

```text
Workout
+
Protein intake
+
Calorie intake
+
Sleep
    ↓
Recovery / nutrition pattern
```

### Context and Nutrition

```text
Meeting-heavy day
+
Delayed meals
+
Late dinner
+
Calories
    ↓
Busy-day eating pattern
```

### Personal Baseline

```text
Current behaviour
        vs
Personal historical baseline
        ↓
Personal deviation / anomaly
```

---

## Liquids Domain

Liquids is intentionally modeled as a separate domain rather than treating every drink as water or nutrition.

Initial categories:

- Water
- Coffee
- Tea
- Soft Drinks
- Alcohol

The future data model should preserve at least:

- Drink type
- Amount / volume
- Timestamp
- Category-specific metadata

Examples:

- Coffee: coffee type, size / ml, milk
- Soft drinks: regular / zero / diet, size
- Alcohol: beverage type, serving / size
- Cocktails: initially simplified as a cocktail type plus size

**Liquids is not equivalent to Hydration.**

Total liquid volume and hydration-related signals must remain distinguishable.

---

## Future Intelligence Opportunities

Potential future analysis areas include:

- Personal baselines
- Multi-day trends
- Weekly and monthly patterns
- Behaviour sequences
- Cross-domain correlations
- Anomaly detection
- Cause/effect-like associations
- Successful-day pattern discovery
- Repeated failure pattern detection
- Context-aware opportunities
- Time-of-day patterns
- Weekday vs weekend patterns
- Recovery patterns
- Nutrition/activity interactions
- Liquid/sleep/recovery interactions
- Alcohol/HRV/recovery interactions
- Caffeine/sleep interactions

These are opportunities, not yet implemented capabilities.

---

## Next Steps

1. Research the complete set of metrics that can realistically be obtained.
2. Validate the **Available** column using authoritative sources.
3. Inspect the project codebase and validate **Collected** and **Stored**.
4. Map currently implemented **Analyzed**, **Correlated** and **Coach** capabilities.
5. Identify high-value gaps.
6. Design the Intelligence Engine from the resulting data universe.
7. Use the resulting model to guide Observation Engine and Insight Engine implementation.

---

## Version History

### v1

Initial Intelligence Coverage Matrix established as the baseline for the Intelligence Engine research and design.



