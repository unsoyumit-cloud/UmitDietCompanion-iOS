//
//  ReasoningEngine.swift
//  UmitDietCompanion
//

import Foundation

struct ReasoningEngine {

    func build(
        from recommendation: Recommendation
    ) -> CoachReasoning {

        CoachReasoning(
            recommendation: recommendation,
            observation: observation(for: recommendation),
            reasoning: reasoning(for: recommendation),
            nextAction: nextAction(for: recommendation.type),
            confidence: recommendation.confidence.rawValue
        )

    }

}

// MARK: - Private

private extension ReasoningEngine {

    func observation(
        for recommendation: Recommendation
    ) -> String {

        guard let insight = recommendation.supportingInsights.first else {
            return "Bugünkü sağlık verileri analiz edildi."
        }

        switch insight.type {

        case .hydrationOpportunity:
            return "Su tüketimin hedefinin gerisinde."

        case .proteinOpportunity:
            return "Protein alımın artırılabilir."

        case .healthyMealOpportunity:
            return "Beslenme kaliten geliştirilebilir."

        case .movementOpportunity:
            return "Hareket hedefinin gerisindesin."

        case .recoveryOpportunity:
            return "Toparlanmaya daha fazla ihtiyaç duyuyorsun."

        case .dehydrationRisk:
            return "Susuz kalma riski oluşuyor."

        case .lateEatingRisk:
            return "Geç saatlerde yemek yeme eğilimi görünüyor."

        case .sedentaryRisk:
            return "Uzun süredir hareketsiz görünüyorsun."

        case .poorRecovery:
            return "Toparlanma seviyen düşük."

        case .highCaffeineIntake:
            return "Kafein tüketimin bugün yüksek."

        case .healthyMomentum:
            return "Bugün iyi bir ritim yakaladın."

        case .consistencyReward:
            return "İstikrarlı ilerliyorsun."

        case .streakContinuation:
            return "Serini devam ettiriyorsun."

        case .busyWorkday:
            return "Yoğun bir iş günündesin."

        case .travelImpact:
            return "Seyahat planın günlük düzenini etkileyebilir."

        case .socialEating:
            return "Sosyal bir öğün planın var."

        case .groceryOpportunity:
            return "Sağlıklı seçim yapmak için uygun bir ortamdasın."

        case .coffeeOpportunity:
            return "Kahve molası zamanı."
        }
    }

    func reasoning(
        for recommendation: Recommendation
    ) -> String {

        "Bu öneri mevcut sağlık durumu ve destekleyen gözlemler doğrultusunda oluşturuldu."

    }

    func nextAction(
        for type: RecommendationType
    ) -> String {

        switch type {

        case .drinkWaterNow:
            return "Bir bardak su iç."

        case .refillWaterBottle:
            return "Su şişeni doldur."

        case .eatProtein:
            return "Bir sonraki öğününe protein ekle."

        case .buyProtein:
            return "Protein açısından zengin besin satın al."

        case .eatHealthyMeal:
            return "Dengeli bir öğün tercih et."

        case .takeShortWalk:
            return "10 dakikalık kısa bir yürüyüş yap."

        case .standUp:
            return "Ayağa kalkıp birkaç dakika hareket et."

        case .stretch:
            return "5 dakikalık esneme hareketleri yap."

        case .rest:
            return "Bugün dinlenmeye öncelik ver."

        case .sleepEarlier:
            return "Bu akşam biraz daha erken uyumayı hedefle."

        case .prepareHealthySnack:
            return "Yanına sağlıklı bir atıştırmalık al."

        case .avoidLateMeal:
            return "Geç saatlerde yemek yememeye çalış."

        case .reduceCoffee:
            return "Bir sonraki kahveni suyla değiştirmeyi düşün."
        }

    }

}
