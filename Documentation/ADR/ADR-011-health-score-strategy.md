# ADR-011 — Health Score Strategy

## Status

Proposed / Not Final

## Context

Ümit Diet Companion'da Daily Health Score'un amacı,
kullanıcının günlük sağlık davranışlarını tek bir anlaşılır skor
halinde özetlemektir.

Score, günlük olarak değişebilen ve kullanıcının davranışlarıyla
etkilenebilen metriklere öncelik vermelidir.

Weight ve Heart Rate gibi metrikler doğrudan günlük davranış skoru
olarak değerlendirilmek zorunda değildir.

---

## Principles

1. Daily Health Score 100 üzerinden gösterilir.
2. Score ile Dashboard ring değerleri aynı temel metric progress'lerini
   kullanmalıdır.
3. Aynı veri farklı yerlerde farklı scoring mantıklarıyla
   hesaplanmamalıdır.
4. Weight, doğrudan günlük score'a katkı vermek zorunda değildir.
5. Heart Rate şimdilik score'a dahil edilmez.
6. Kullanıcının weight goal'u scoring strategy'yi ileride
   etkileyebilir.
7. Nutrition sisteme dahil edildiğinde scoring yeniden dengelenebilir.
8. Score weights ileride değiştirilebilir olmalıdır.

---

# Candidate Scoring Models

## Model A — Equal Weight

Şimdiki başlangıç modeli.

Water        33.3
Activities   33.3
Sleep        33.4

Total        100

Nutrition sisteme eklendiğinde yeniden normalize edilir.

### Advantages

- Basit
- Anlaşılması kolay
- İlk MVP için yeterli
- Davranışların hiçbirini gereksiz şekilde öne çıkarmaz

### Disadvantages

- Her davranışın sağlık hedefindeki önemini aynı kabul eder
- Kullanıcının hedefini dikkate almaz

---

## Model B — Fixed Weighted Model

Her metric için ürün tarafından belirlenen sabit ağırlıklar.

Örnek:

Sleep        40
Nutrition    30
Activities   20
Water        10

Total        100

### Advantages

- Sağlık açısından daha anlamlı önceliklendirme yapılabilir
- Nutrition eklendiğinde daha kontrollü bir model oluşturulabilir

### Disadvantages

- Tüm kullanıcılar için aynı öncelikleri kullanır
- Kişisel hedefleri dikkate almaz

---

## Model C — Goal-Aware Dynamic Weighting

Weight goal doğrudan score'a puan olarak eklenmez.

Bunun yerine kullanıcının:

- Current Weight
- Target Weight
- Target Date
- Desired Weight Loss

bilgilerinden bir Goal Intensity oluşturulur.

Örnek:

Goal Intensity = High

Scoring emphasis:

Activities ↑
Nutrition ↑
Sleep ↔
Water ↔

Bu durumda örnek ağırlık:

Sleep        30
Nutrition    35
Activities   25
Water        10

Total        100

Goal Intensity = Normal olduğunda farklı ağırlıklar kullanılabilir.

### Advantages

- Score kullanıcı hedefini dikkate alır
- Aynı davranış farklı hedeflere sahip kullanıcılarda farklı önem taşıyabilir
- AI Coach için güçlü context sağlar

### Disadvantages

- Daha karmaşık
- Goal intensity hesaplamasının doğru tasarlanması gerekir
- Kullanıcı hedefinin gerçekçiliği ayrıca değerlendirilmelidir

---

## Model D — Hybrid Model

Base weights + goal modifier.

Örneğin:

Base:

Sleep        35
Nutrition    30
Activities   20
Water        15

Goal intensity yüksekse:

Activities +5
Nutrition +5
Sleep -5
Water -5

Sonuç:

Sleep        30
Nutrition    35
Activities   25
Water        10

Total        100

Bu modelde goal intensity doğrudan yeni bir scoring sistemi yaratmaz;
mevcut scoring modelinin ağırlıklarını kontrollü şekilde değiştirir.

---

# Current Direction

İlk implementation için:

Water + Activities + Sleep

eşit ağırlıklı olarak kullanılabilir.

Nutrition henüz gerçek veri modeliyle sisteme dahil edilmemiştir.

Nutrition eklendiğinde Model B, C veya D tekrar değerlendirilecektir.

Weight şu aşamada doğrudan Daily Health Score metric'i değildir.

Ancak Weight Goal, ileride Goal-Aware veya Hybrid scoring modelinde
scoring weights'i belirleyen bir context olarak kullanılabilir.

Heart Rate şu aşamada Daily Health Score'a dahil değildir.

---

# Scoring Algorithm — V1

V1 scoring modelinde iki seviyeli bir yapı kullanılır.

Her sağlık kategorisi önce kendi içinde **0–100** arasında hesaplanır.

Daha sonra kategori skoru, o kategorinin Daily Health Score ağırlığı
ile çarpılır.

## Daily Health Score Weights

| Category | Weight |
|---|---:|
| Water | 33.33% |
| Activities | 33.33% |
| Sleep | 33.34% |
| **Total** | **100%** |

Ağırlıklar merkezi ve değiştirilebilir olmalıdır.

Nutrition sisteme eklendiğinde veya ürün deneyimi farklı bir ağırlık
dağılımını gerektirdiğinde yeniden değerlendirilebilir.

### Formula

```text
Daily Health Score =
    Water Score × 33.33%
  + Activities Score × 33.33%
  + Sleep Score × 33.34%

### Water Threshold Rule — First 1 Litre

The first 1 litre of the daily water target is intentionally treated
as the most important behavioral milestone.

The first 1 litre should **not** be awarded as a single all-or-nothing
50-point milestone. It should be divided into smaller thresholds so
that progress toward the first litre is continuously rewarded.

For a 2.5 L daily target, the first 1 litre is worth 50 internal
Water Score points:

| Total Water | Water Score |
|---:|---:|
| 0 L | 0 |
| 0.25 L | 10 |
| 0.50 L | 20 |
| 0.75 L | 35 |
| 1.00 L | 50 |

The thresholds are intentionally non-linear. Reaching the first
milestones provides meaningful progress, while completing the first
full litre remains the major behavioral milestone.

This rule prevents an all-or-nothing outcome where a user who drinks
0.75 L receives no meaningful credit simply because the 1 L milestone
has not yet been reached.

The same principle should be preserved for other water targets:
the first meaningful hydration milestone should be split into
progressive thresholds rather than being treated as a single
all-or-nothing block.

The exact thresholds for different daily water targets may be
configured separately.
