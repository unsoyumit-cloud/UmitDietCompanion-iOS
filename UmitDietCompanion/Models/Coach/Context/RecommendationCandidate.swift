//
//  RecommendationCandidate.swift
//  UmitDietCompanion
//

import Foundation

/// Legacy model.
///
/// Sprint 6 ile birlikte RecommendationEngine artık doğrudan
/// `Recommendation` modeli üretmektedir.
///
/// Bu dosya eski katman tamamen kaldırılıncaya kadar
/// sadece geriye dönük uyumluluk amacıyla tutulmaktadır.
@available(*, deprecated, message: "Use Recommendation instead.")
typealias RecommendationCandidate = Recommendation
