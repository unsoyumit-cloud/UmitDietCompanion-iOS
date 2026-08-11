//
//  ReasoningEngine.swift
//  UmitDietCompanion
//

import Foundation

struct ReasoningEngine {

    func build(
        from recommendation: RecommendationCandidate
    ) -> CoachReasoning {

        let content = content(for: recommendation.reason)

        return CoachReasoning(
            recommendation: recommendation,
            observation: content.observation,
            reasoning: content.reasoning,
            nextAction: nextAction(for: recommendation.behaviour),
            confidence: confidence(score: recommendation.score)
        )
    }
}

// MARK: - Private

private extension ReasoningEngine {

    typealias ReasoningContent = (
        observation: String,
        reasoning: String
    )

    func content(
        for reason: RecommendationReason
    ) -> ReasoningContent {

        switch reason {

        case .lowWater:
            return (
                observation: "Su hedefinin gerisindesin.",
                reasoning: "Günün bu aşamasında en önemli ihtiyaç su tüketimi olarak değerlendirildi."
            )

        case .lowMovement:
            return (
                observation: "Bugünkü hareket seviyen hedefin altında.",
                reasoning: "Hareket hedefinin gerisinde kaldığın için bu öneri seçildi."
            )

        case .poorNutrition:
            return (
                observation: "Beslenme kaliten bugün geliştirilebilir.",
                reasoning: "Beslenme puanın diğer metriklere göre daha düşük."
            )

        case .poorSleep:
            return (
                observation: "Uyku kaliten toparlanma için yeterli görünmüyor.",
                reasoning: "Yetersiz uyku gün içindeki performansını olumsuz etkileyebilir."
            )

        case .lowRecovery:
            return (
                observation: "Toparlanma seviyen bugün düşük görünüyor.",
                reasoning: "Vücudunun toparlanmaya öncelik vermesi gerekiyor."
            )
        }
    }

    func nextAction(
        for behaviour: Behaviour
    ) -> String {

        switch behaviour {

        case .drinkWater:
            return "Bir büyük bardak su iç."

        case .walk:
            return "10–15 dakikalık kısa bir yürüyüş yap."

        case .standUp:
            return "Ayağa kalkıp birkaç dakika hareket et."

        case .eatProtein:
            return "Bir sonraki öğünde protein ağırlıklı seçim yap."

        case .sleepEarlier:
            return "Bu akşam biraz daha erken uyumayı hedefle."

        case .stretch:
            return "5 dakikalık esneme hareketleri yap."

        case .eatBetter:
            return "Bir sonraki öğünde daha dengeli beslenmeye odaklan."

        case .recover:
            return "Kendine dinlenmek için zaman ayır."
        }
    }

    func confidence(
        score: RecommendationScore
    ) -> Double {

        min(
            max(score.total / 100.0, 0.0),
            1.0
        )
    }
}
