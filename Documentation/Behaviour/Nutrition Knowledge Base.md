# Nutrition Knowledge Base

**Status:** Active

**Version:** 1.0

---

# Purpose

This document defines the nutritional knowledge used by Ümit Diet Companion.

The Recommendation Engine does not generate nutritional advice itself.

Instead, it evaluates nutritional factors and uses this knowledge base to explain:

- Why a nutrient matters
- What happens when it is insufficient
- What happens when it is excessive
- How the user can improve it

The AI Coach should communicate these concepts using natural language without making medical diagnoses.

---

# Evaluation Philosophy

No single food is inherently "good" or "bad".

Meal quality is determined by:

- Nutritional balance
- Portion appropriateness
- Overall daily context

The Companion evaluates eating patterns rather than individual foods.

---

# Nutritional Factors

---

# 🥩 Protein

## Weight

30%

## Why It Matters

Protein supports:

- Muscle maintenance
- Satiety
- Recovery
- Healthy metabolism

## Low Score

Possible consequences:

- Reduced satiety
- Difficulty reaching daily protein targets
- Lower meal quality

## High Score

Benefits:

- Better satiety
- Supports muscle preservation
- Improves overall meal quality

## Improvement Suggestions

Examples:

- Yogurt
- Eggs
- Chicken
- Fish
- Lean meat
- Legumes
- Cottage cheese

## AI Tone

Say:

"Protein intake appears lower than ideal."

Avoid:

"You didn't eat enough protein."

---

# 🥬 Fiber

## Weight

25%

## Why It Matters

Fiber supports:

- Digestive health
- Gut microbiome
- Satiety
- Blood sugar stability

## Low Score

Possible consequences:

- Reduced satiety
- Lower meal quality

## High Score

Benefits:

- Better digestion
- Longer-lasting fullness
- More balanced meal

## Improvement Suggestions

Examples:

- Vegetables
- Legumes
- Whole grains
- Fruit

---

# 🥗 Vegetables

## Weight

15%

## Why It Matters

Vegetables improve:

- Micronutrient intake
- Fiber intake
- Meal volume
- Overall nutritional balance

## Low Score

Possible consequences:

- Lower micronutrient density
- Less balanced meal

## High Score

Benefits:

- Better overall meal quality
- Improved nutrient diversity

## Improvement Suggestions

Examples:

- Salad
- Steamed vegetables
- Seasonal vegetables

---

# 🫒 Healthy Fat

## Weight

15%

## Why It Matters

Healthy fats support:

- Hormonal balance
- Fat-soluble vitamin absorption
- Satiety

## Low Score

Possible consequences:

- Meal may be less satisfying

## High Score

Benefits:

- Better nutritional balance

## Too High

Healthy fats are beneficial, but excessive portions can significantly increase total calorie intake.

## Improvement Suggestions

Examples:

- Olive oil
- Avocado
- Nuts
- Seeds

---

# 🌾 Carbohydrate Quality

## Weight

10%

## Why It Matters

Carbohydrate quality affects:

- Energy stability
- Blood sugar response
- Meal quality

## Low Score

Possible consequences:

- Faster hunger
- Less stable energy levels

## High Score

Benefits:

- More stable energy
- Better meal balance

## Improvement Suggestions

Prefer:

- Whole grains
- Oats
- Brown rice
- Legumes

Instead of highly refined carbohydrates whenever possible.

---

# 🍽 Portion Size

## Weight

5%

## Why It Matters

Portion size influences:

- Energy balance
- Daily calorie intake

Portion quality should never outweigh food quality.

A nutritious meal can still become unbalanced if portions are consistently excessive.

## Too Small

Meal may not provide sufficient energy.

## Too Large

Meal may contribute unnecessary calorie surplus.

## Improvement Suggestions

Aim for appropriate portions rather than simply eating less.

---

# Recommendation Rules

The Companion should prioritize recommendations according to factor weight.

Default priority:

1. Protein
2. Fiber
3. Vegetables
4. Healthy Fat
5. Carbohydrate Quality
6. Portion Size

However, Recommendation Engine may change this priority depending on context.

Example:

If vegetable score is critically low but protein is only slightly below target,
vegetables may become the primary recommendation.

---

# Communication Principles

The Companion should:

- Educate
- Encourage
- Motivate

The Companion should never:

- Shame
- Judge
- Label foods as "good" or "bad"

Preferred wording:

✓ "Adding vegetables would make this meal more balanced."

Avoid:

✗ "This meal is unhealthy."

---

# Future Extensions

Future versions may evaluate:

- Sugar quality
- Sodium
- Ultra-processed foods
- Micronutrients
- Meal timing
- Protein distribution
- Daily nutrition diversity
- Weekly nutrition trends

These factors should extend the existing framework rather than replace it.



# Guiding Principle

The Companion's goal is not to help users eat perfectly.

Its goal is to help users make slightly better nutritional decisions, consistently.

Small improvements repeated over time create meaningful health outcomes.
