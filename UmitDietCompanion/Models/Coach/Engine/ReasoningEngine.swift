//
//  ReasoningEngine.swift
//  UmitDietCompanion
//

import Foundation

struct ReasoningEngine {

    func build(
        from recommendation: RecommendationCandidate
    ) -> CoachReasoning {

        CoachReasoning(

            recommendation: recommendation,

            observation: observation(
                for: recommendation.reason
            ),

            reasoning: reasoning(
                for: recommendation.reason
            ),

            nextAction: nextAction(
                for: recommendation.behaviour
            ),

            confidence: confidence(
                score: recommendation.score
            )
        )
    }
}

// MARK: - Private

private extension ReasoningEngine {

    func observation(
        for reason: RecommendationReason
    ) -> String {

        switch reason {

        case .lowWater:
            return "Su hedefinin gerisindesin."

        case .lowMovement:
            return "Bugünkü hareket seviyen hedefin altında."

        case .poorNutrition:
            return "Beslenme kaliten bugün geliştirilebilir."

        case .poorSleep:
            return "Uyku kaliten toparlanma için yeterli görünmüyor."

        case .lowRecovery:
            return "Toparlanma seviyen bugün düşük görünüyor."

        }
    }

    func reasoning(
        for reason: RecommendationReason
    ) -> String {

        switch reason {

        case .lowWater:
            return "Günün bu aşamasında en önemli ihtiyaç su tüketimi olarak değerlendirildi."

        case .lowMovement:
            return "Hareket hedefinin gerisinde kaldığın için bu öneri seçildi."

        case .poorNutrition:
            return "Beslenme puanın diğer metriklere göre daha düşük."

        case .poorSleep:
            return "Yetersiz uyku gün içindeki performansını olumsuz etkileyebilir."

        case .lowRecovery:
            return "Vücudunun toparlanmaya öncelik vermesi gerekiyor."

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
