//
//  StepCard.swift
//  UmitDietCompanion
//
//  Created by Ümit Ünsoy on 2.07.2026.
//

import SwiftUI

struct StepCard: View {
    
    let dailyStepGoal: Int
    let dailySteps: Int
    var remainingSteps: Int {
        return dailyStepGoal - dailySteps
    }
    var progress: Double {
        min(Double(dailySteps) / Double(dailyStepGoal), 1.0)
    }
    
    
    var body: some View {
        VStack {
            
            HStack {
                Text("👣")
                Text("Günlük Adım")
                
                Spacer()
                
                VStack(alignment: .trailing) {

                    Text("\(dailySteps) / \(dailyStepGoal)")
                        .font(.headline)

                    

                }
            }

            ProgressView(value: progress)

            HStack {

                Text("Kalan")

                Spacer()

                Text("\(max(remainingSteps, 0)) adım")
                    .font(.headline)

            }
            }
            }
                
        }

#Preview {
    StepCard(
        dailyStepGoal: 10000,
        dailySteps: 8500
    )
}
