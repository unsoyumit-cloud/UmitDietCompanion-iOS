//
//  HealthKitService.swift
//  UmitDietCompanion
//

import Foundation
import HealthKit

struct SleepHeartRateSample: Identifiable {
  let id: UUID
  let date: Date
  let bpm: Double

  init(
    id: UUID = UUID(),
    date: Date,
    bpm: Double
  ) {
    self.id = id
    self.date = date
    self.bpm = bpm
  }
}

struct HealthKitWorkoutSummary: Identifiable {
  let id: UUID
  let activityType: HKWorkoutActivityType
  let startDate: Date
  let endDate: Date
  let duration: TimeInterval
  let totalEnergyBurned: Double?
  let totalDistance: Double?

  init(workout: HKWorkout) {
    self.id = workout.uuid
    self.activityType = workout.workoutActivityType
    self.startDate = workout.startDate
    self.endDate = workout.endDate
    self.duration = workout.duration
    self.totalEnergyBurned =
      workout.totalEnergyBurned?
      .doubleValue(for: .kilocalorie())
    self.totalDistance =
      workout.totalDistance?
      .doubleValue(for: .meter())
  }
}

struct HealthKitNightMetrics {
  let averageHeartRate: Double
  let averageHRV: Double
  let sevenDayAverageHRV: Double
  let averageSpO2: Double
  let minimumSpO2: Double
  let averageRespiratoryRate: Double
  let minimumRespiratoryRate: Double
  let sleepingWristTemperature: Double?
  let breathingDisturbancesElevated: Bool?

  var hasHRVData: Bool {
    averageHRV > 0
  }

  var hasSpO2Data: Bool {
    averageSpO2 > 0
  }

  var hasRespiratoryRateData: Bool {
    averageRespiratoryRate > 0
  }
}

final class HealthKitService {

  private let healthStore = HKHealthStore()

  var isAvailable: Bool {
    HKHealthStore.isHealthDataAvailable()
  }

    func requestAuthorization()
        async throws {

        guard isAvailable else {
            return
        }

        var readTypes:
            Set<HKObjectType> = [

                // MARK: Activity

                HKQuantityType.quantityType(
                    forIdentifier:
                        .stepCount
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .distanceWalkingRunning
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .runningSpeed
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .runningStrideLength
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .runningPower
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .runningGroundContactTime
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .runningVerticalOscillation
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .distanceCycling
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .cyclingCadence
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .cyclingPower
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .cyclingFunctionalThresholdPower
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .flightsClimbed
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .appleExerciseTime
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .appleMoveTime
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .appleStandTime
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .vo2Max
                )!,

                // MARK: Mobility

                HKQuantityType.quantityType(
                    forIdentifier:
                        .appleWalkingSteadiness
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .sixMinuteWalkTestDistance
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .walkingSpeed
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .walkingStepLength
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .walkingAsymmetryPercentage
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .walkingDoubleSupportPercentage
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .stairAscentSpeed
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .stairDescentSpeed
                )!,

                // MARK: Existing Activity Energy

                HKQuantityType.quantityType(
                    forIdentifier:
                        .activeEnergyBurned
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .basalEnergyBurned
                )!,

                // MARK: Existing Health Data

                HKObjectType.categoryType(
                    forIdentifier:
                        .sleepAnalysis
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .restingHeartRate
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .heartRate
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .heartRateVariabilitySDNN
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .oxygenSaturation
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .respiratoryRate
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .bodyMass
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .bodyFatPercentage
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .leanBodyMass
                )!,

                HKQuantityType.quantityType(
                    forIdentifier:
                        .waistCircumference
                )!,

                // MARK: Workout

                HKObjectType.workoutType(),

                // MARK: Workout Route

                HKSeriesType.workoutRoute()
            ]

        // MARK: Optional iOS 16+ Health Data

        if #available(iOS 16.0, *) {

            if let wristTemperatureType =
                HKQuantityType.quantityType(
                    forIdentifier:
                        .appleSleepingWristTemperature
                ) {

                readTypes.insert(
                    wristTemperatureType
                )
            }
        }

        print(
            "➡️ Requesting HealthKit authorization..."
        )

        do {

            try await healthStore.requestAuthorization(
                toShare: [],
                read: readTypes
            )

            print(
                "✅ Authorization finished"
            )

        } catch {

            print(
                "❌ HealthKit Error:"
            )

            print(
                error
            )
        }
    }

  private func dayRange(
    for date: Date
  ) -> (
    start: Date,
    end: Date
  ) {

    let calendar =
      Calendar.current

    let start =
      calendar.startOfDay(
        for: date
      )

    let end =
      calendar.date(
        byAdding: .day,
        value: 1,
        to: start
      )!

    return (
      start,
      end
    )
  }

  private func nightRange(
    for date: Date
  ) -> (
    start: Date,
    end: Date
  ) {

    let calendar =
      Calendar.current

    let dayStart =
      calendar.startOfDay(
        for: date
      )

    let previousEvening =
      calendar.date(
        byAdding: .day,
        value: -1,
        to: dayStart
      )!

    let start =
      calendar.date(
        bySettingHour: 18,
        minute: 0,
        second: 0,
        of: previousEvening
      )!

    let noon =
      calendar.date(
        bySettingHour: 12,
        minute: 0,
        second: 0,
        of: dayStart
      )!

    let end =
      min(
        Date(),
        noon
      )

    return (
      start,
      end
    )
  }

  private func nightPredicate(
    for date: Date
  ) -> NSPredicate {

    let range =
      nightRange(
        for: date
      )

    return HKQuery.predicateForSamples(
      withStart: range.start,
      end: range.end,
      options: .strictStartDate
    )
  }

  func getSleepHeartRateSamples(
    for date: Date
  ) async throws -> [SleepHeartRateSample] {

    let sleepRange =
      try await getActualSleepRange(
        for: date
      )

    guard let sleepRange else {
      return []
    }

    let heartRateType =
      HKQuantityType.quantityType(
        forIdentifier: .heartRate
      )!

    let predicate =
      HKQuery.predicateForSamples(
        withStart: sleepRange.start,
        end: sleepRange.end,
        options: .strictStartDate
      )

    let samples =
      try await getRawQuantitySamples(
        type: heartRateType,
        predicate: predicate
      )

    let unit =
      HKUnit.count()
      .unitDivided(
        by: .minute()
      )

    return samples.map {
      SleepHeartRateSample(
        id: $0.uuid,
        date: $0.startDate,
        bpm: $0.quantity
          .doubleValue(
            for: unit
          )
      )
    }
  }

  private func getActualSleepRange(
    for date: Date
  ) async throws -> (
    start: Date,
    end: Date
  )? {

    let sleepType =
      HKObjectType.categoryType(
        forIdentifier: .sleepAnalysis
      )!

    let predicate =
      nightPredicate(
        for: date
      )

    let samples =
      try await withCheckedThrowingContinuation {
        (
          continuation:
            CheckedContinuation<
              [HKCategorySample],
              Error
            >
        ) in

        let query =
          HKSampleQuery(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [
              NSSortDescriptor(
                key:
                  HKSampleSortIdentifierStartDate,
                ascending:
                  true
              )
            ]
          ) {
            _,
            samples,
            error
            in

            if let error {

              let nsError = error as NSError

              if nsError.domain == HKError.errorDomain
                && nsError.code == HKError.Code.errorNoData.rawValue
              {

                print("ℹ️ No sleep data available for this period.")

                continuation.resume(
                  returning: []
                )

                return
              }

              continuation.resume(
                throwing: error
              )

              return
            }

            continuation.resume(
              returning:
                samples
                as? [HKCategorySample]
                ?? []
            )
          }

        healthStore.execute(
          query
        )
      }

    let asleepSamples =
      samples.filter {
        isAsleepSample($0)
      }

    guard
      let first =
        asleepSamples.first,
      let last =
        asleepSamples.last
    else {
      return nil
    }

    return (
      start:
        first.startDate,

      end:
        asleepSamples
        .map {
          sample in
          sample.endDate
        }
        .max()
        ?? last.endDate
    )
  }

  private func isAsleepSample(
    _ sample: HKCategorySample
  ) -> Bool {

    let value =
      sample.value

    if #available(iOS 16.0, *) {

      switch value {

      case HKCategoryValueSleepAnalysis
        .asleepCore.rawValue,

        HKCategoryValueSleepAnalysis
        .asleepDeep.rawValue,

        HKCategoryValueSleepAnalysis
        .asleepREM.rawValue,

        HKCategoryValueSleepAnalysis
        .asleepUnspecified.rawValue:

        return true

      default:
        break
      }
    }

    return value
      == HKCategoryValueSleepAnalysis
      .asleep.rawValue
  }

  func getTodayStepCount() async throws -> Int {
    try await getStepCount(
      for: Date()
    )
  }

  func getStepCount(
    for date: Date
  ) async throws -> Int {

    let stepType =
      HKQuantityType.quantityType(
        forIdentifier: .stepCount
      )!

    let range =
      dayRange(
        for: date
      )

    let predicate =
      HKQuery.predicateForSamples(
        withStart: range.start,
        end: range.end,
        options: .strictStartDate
      )

    return try await withCheckedThrowingContinuation {
      continuation in

      let query =
        HKStatisticsQuery(
          quantityType: stepType,
          quantitySamplePredicate: predicate,
          options: .cumulativeSum
        ) {
          _,
          result,
          error
          in

          if let error {

            let nsError = error as NSError

            if nsError.domain == HKError.errorDomain
              && nsError.code == HKError.Code.errorNoData.rawValue
            {

              continuation.resume(
                returning: 0
              )

              return
            }

            continuation.resume(
              throwing: error
            )

            return
          }

          let steps =
            Int(
              result?
                .sumQuantity()?
                .doubleValue(
                  for: .count()
                )
                ?? 0
            )

          continuation.resume(
            returning:
              steps
          )
        }

      healthStore.execute(
        query
      )
    }
  }

  func getTodayWalkingRunningDistance()
    async throws -> Double
  {

    try await getWalkingRunningDistance(
      for: Date()
    )
  }

  func getWalkingRunningDistance(
    for date: Date
  ) async throws -> Double {

    let distanceType =
      HKQuantityType.quantityType(
        forIdentifier:
          .distanceWalkingRunning
      )!

    let range =
      dayRange(
        for: date
      )

    let predicate =
      HKQuery.predicateForSamples(
        withStart: range.start,
        end: range.end,
        options: .strictStartDate
      )

    return try await withCheckedThrowingContinuation {
      continuation in

      let query =
        HKStatisticsQuery(
          quantityType:
            distanceType,
          quantitySamplePredicate:
            predicate,
          options:
            .cumulativeSum
        ) {
          _,
          result,
          error
          in

          if let error {
            continuation.resume(
              throwing:
                error
            )

            return
          }

          let meters =
            result?
            .sumQuantity()?
            .doubleValue(
              for: .meter()
            )
            ?? 0

          continuation.resume(
            returning:
              meters / 1000.0
          )
        }

      healthStore.execute(
        query
      )
    }
  }

  func getLastNightSleepHours()
    async throws -> Double
  {

    let metrics =
      try await getLastNightSleepMetrics(
        for: Date()
      )

    return metrics.totalSleepHours
  }

  func getLastNightSleepMetrics(
    for date: Date
  ) async throws -> SleepMetrics {

    let sleepType =
      HKObjectType.categoryType(
        forIdentifier:
          .sleepAnalysis
      )!

    let predicate =
      nightPredicate(
        for: date
      )

    return try await withCheckedThrowingContinuation {
      continuation
      in

      let query =
        HKSampleQuery(
          sampleType:
            sleepType,

          predicate:
            predicate,

          limit:
            HKObjectQueryNoLimit,

          sortDescriptors: [
            NSSortDescriptor(
              key:
                HKSampleSortIdentifierStartDate,

              ascending:
                true
            )
          ]
        ) {

          _,
          samples,
          error
          in

          if let error {

            let nsError = error as NSError

            if nsError.domain == HKError.errorDomain
              && nsError.code == HKError.Code.errorNoData.rawValue
            {

              print("ℹ️ No sleep data available for this period.")

              continuation.resume(
                returning:
                  SleepMetrics(
                    deepSleep: 0,
                    coreSleep: 0,
                    remSleep: 0,
                    awakeTime: 0,
                    unspecifiedSleep: 0,
                    primeSleepTime: 0
                  )
              )

              return
            }

            continuation.resume(
              throwing: error
            )

            return
          }

          guard
            let samples =
              samples
              as? [HKCategorySample]
          else {

            continuation.resume(
              returning:
                SleepMetrics(
                  deepSleep: 0,
                  coreSleep: 0,
                  remSleep: 0,
                  awakeTime: 0,
                  unspecifiedSleep: 0,
                  primeSleepTime: 0
                )
            )

            return
          }

            // =================================================
            
            // MARK: - SLEEP SOURCE DIAGNOSTIC
            // =================================================
            //
            // This diagnostic does NOT change sleep calculations.
            // It shows exactly what HealthKit returned,
            // including the source/device of each sleep sample.
            //

            let diagnosticRange =
                self.nightRange(
                    for:
                        date
                )

            print("")
            print(
                "==================================="
            )
            print(
                "🧪 SLEEP SOURCE DIAGNOSTIC"
            )
            print(
                "==================================="
            )

            print(
                "Query Start:",
                diagnosticRange.start
            )

            print(
                "Query End:",
                diagnosticRange.end
            )

            print(
                "Now:",
                Date()
            )

            print(
                "Total Sleep Samples:",
                samples.count
            )

            if samples.isEmpty {

                print("")
                print(
                    "❌ HEALTHKIT RETURNED NO SLEEP SAMPLES"
                )

                print(
                    "This means no sleep samples were available"
                )

                print(
                    "inside the current HealthKit query window."
                )

            } else {

                print("")

                for sample in samples {

                    let source =
                        sample.sourceRevision.source

                    print(
                        "-----------------------------------"
                    )

                    print(
                        "Start:",
                        sample.startDate
                    )

                    print(
                        "End:",
                        sample.endDate
                    )

                    print(
                        "Value:",
                        sample.value
                    )

                    print(
                        "Source Name:",
                        source.name
                    )

                    print(
                        "Source Bundle:",
                        source.bundleIdentifier
                    )

                

                    if let device =
                        sample.device {

                        print(
                            "Device Name:",
                            device.name
                                ?? "unknown"
                        )

                        print(
                            "Device Manufacturer:",
                            device.manufacturer
                                ?? "unknown"
                        )

                        print(
                            "Device Model:",
                            device.model
                                ?? "unknown"
                        )

                    } else {

                        print(
                            "Device: nil"
                        )
                    }
                }
            }

            print("")
            print(
                "==================================="
            )
            print(
                "🧪 END SLEEP SOURCE DIAGNOSTIC"
            )
            print(
                "==================================="
            )
            print("")

            // =================================================
            // END DIAGNOSTIC
            // =================================================
            
          let asleepSamples =
            samples.filter {
              self.isAsleepSample(
                $0
              )
            }

          let sleepStart =
            asleepSamples
            .map {
              $0.startDate
            }
            .min()

          let sleepEnd =
            asleepSamples
            .map {
              $0.endDate
            }
            .max()

          print("")
          print(
            "🌙 ACTUAL SLEEP SESSION"
          )

          print(
            "Sleep Start:",
            sleepStart as Any
          )

          print(
            "Sleep End:",
            sleepEnd as Any
          )

          let calculator =
            SleepMetricsCalculator()

          let metrics =
            calculator.calculate(
              from:
                samples,

              sleepStart:
                sleepStart,

              sleepEnd:
                sleepEnd
            )

          continuation.resume(
            returning:
              metrics
          )
        }

      healthStore.execute(
        query
      )
    }
  }
    func getLastNightMetrics(
      for date: Date
    ) async throws -> HealthKitNightMetrics {

      async let heartRate =
        getNightAverageHeartRate(
          for: date
        )

      async let hrv =
        getNightAverageHRV(
          for: date
        )

      async let sevenDayHRV =
        getSevenDayAverageHRV(
          endingAt: date
        )

      async let spo2 =
        getNightSpO2(
          for: date
        )

      async let respiratory =
        getNightRespiratoryRate(
          for: date
        )

      async let wristTemperature =
        getSleepingWristTemperature(
          for: date
        )

      async let breathingDisturbances =
        getBreathingDisturbances(
          for: date
        )

      let (
        averageHeartRate,
        averageHRV,
        sevenDayAverageHRV,
        spo2Values,
        respiratoryValues,
        wristTemperatureValue,
        breathingDisturbancesValue
      ) = try await (
        heartRate,
        hrv,
        sevenDayHRV,
        spo2,
        respiratory,
        wristTemperature,
        breathingDisturbances
      )

      return HealthKitNightMetrics(
        averageHeartRate:
          averageHeartRate,

        averageHRV:
          averageHRV,

        sevenDayAverageHRV:
          sevenDayAverageHRV,

        averageSpO2:
          spo2Values.average,

        minimumSpO2:
          spo2Values.minimum,

        averageRespiratoryRate:
          respiratoryValues.average,

        minimumRespiratoryRate:
          respiratoryValues.minimum,

        sleepingWristTemperature:
          wristTemperatureValue,

        breathingDisturbancesElevated:
          breathingDisturbancesValue
      )
    }

    private func getNightAverageHeartRate(
      for date: Date
    ) async throws -> Double {

      let type =
        HKQuantityType.quantityType(
          forIdentifier:
            .heartRate
        )!

      return try await getAverageQuantity(
        type:
          type,

        predicate:
          nightPredicate(
            for: date
          ),

        unit:
          HKUnit.count()
          .unitDivided(
            by: .minute()
          )
      )
    }

    private func getNightAverageHRV(
      for date: Date
    ) async throws -> Double {

      let type =
        HKQuantityType.quantityType(
          forIdentifier:
            .heartRateVariabilitySDNN
        )!

      return try await getAverageQuantity(
        type:
          type,

        predicate:
          nightPredicate(
            for: date
          ),

        unit:
          HKUnit.secondUnit(
            with: .milli
          )
      )
    }

    private func getSevenDayAverageHRV(
      endingAt date: Date
    ) async throws -> Double {

      let calendar =
        Calendar.current

      let dayStart =
        calendar.startOfDay(
          for: date
        )

      let start =
        calendar.date(
          byAdding:
            .day,
          value:
            -6,
          to:
            dayStart
        )!

      let end =
        calendar.date(
          byAdding:
            .day,
          value:
            1,
          to:
            dayStart
        )!

      let predicate =
        HKQuery.predicateForSamples(
          withStart:
            start,

          end:
            min(
              Date(),
              end
            ),

          options:
            .strictStartDate
        )

      let type =
        HKQuantityType.quantityType(
          forIdentifier:
            .heartRateVariabilitySDNN
        )!

      return try await getAverageQuantity(
        type:
          type,

        predicate:
          predicate,

        unit:
          HKUnit.secondUnit(
            with: .milli
          )
      )
    }

    private func getNightSpO2(
      for date: Date
    ) async throws -> (
      average: Double,
      minimum: Double
    ) {

      let type =
        HKQuantityType.quantityType(
          forIdentifier:
            .oxygenSaturation
        )!

      let values =
        try await getQuantityValues(
          type:
            type,

          predicate:
            nightPredicate(
              for: date
            ),

          unit:
            .percent()
        )

      let percentages =
        values.map {
          $0 * 100
        }

      guard
        !percentages.isEmpty
      else {
        return (
          average: 0,
          minimum: 0
        )
      }

      return (
        average:
          percentages.reduce(
            0,
            +
          )
          / Double(
            percentages.count
          ),

        minimum:
          percentages.min()
          ?? 0
      )
    }

    private func getNightRespiratoryRate(
      for date: Date
    ) async throws -> (
      average: Double,
      minimum: Double
    ) {

      let type =
        HKQuantityType.quantityType(
          forIdentifier:
            .respiratoryRate
        )!

      let values =
        try await getQuantityValues(
          type:
            type,

          predicate:
            nightPredicate(
              for: date
            ),

          unit:
            HKUnit.count()
            .unitDivided(
              by: .minute()
            )
        )

      guard
        !values.isEmpty
      else {
        return (
          average: 0,
          minimum: 0
        )
      }

      return (
        average:
          values.reduce(
            0,
            +
          )
          / Double(
            values.count
          ),

        minimum:
          values.min()
          ?? 0
      )
    }

    private func getSleepingWristTemperature(
      for date: Date
    ) async throws -> Double? {

      guard
        #available(iOS 16.0,
        *)
      else {
        return nil
      }

      guard
        let type =
          HKQuantityType.quantityType(
            forIdentifier:
              .appleSleepingWristTemperature
          )
      else {
        return nil
      }

      let values =
        try await getQuantityValues(
          type:
            type,

          predicate:
            nightPredicate(
              for: date
            ),

          unit:
            HKUnit.degreeCelsius()
        )

      return values.first
    }

    private func getBreathingDisturbances(
      for date: Date
    ) async throws -> Bool? {

      guard
        #available(iOS 18.0,
        *)
      else {
        return nil
      }

      _ = date

      return nil
    }

    private func getRawQuantitySamples(
        type: HKQuantityType,
        predicate: NSPredicate
    ) async throws -> [HKQuantitySample] {

        try await withCheckedThrowingContinuation { continuation in

            let query =
                HKSampleQuery(
                    sampleType: type,
                    predicate: predicate,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [
                        NSSortDescriptor(
                            key: HKSampleSortIdentifierStartDate,
                            ascending: true
                        )
                    ]
                ) {

                    _,
                    samples,
                    error
                    in

                    if let error {

                        let nsError =
                            error as NSError

                        if nsError.domain == HKError.errorDomain
                            && nsError.code == HKError.Code.errorNoData.rawValue {

                            continuation.resume(
                                returning: []
                            )

                            return
                        }

                        continuation.resume(
                            throwing: error
                        )

                        return
                    }

                    let quantitySamples =
                        samples
                        as? [HKQuantitySample]
                        ?? []

                    continuation.resume(
                        returning: quantitySamples
                    )
                }

            self.healthStore.execute(
                query
            )
        }
    }
    
    func getActivityRawSamples(
        type: HKQuantityType,
        unit: HKUnit,
        predicate: NSPredicate
    ) async throws -> [ActivityRawSample] {

        let samples =
            try await getRawQuantitySamples(
                type: type,
                predicate: predicate
            )

        return samples.map { sample in

            let value =
                sample.quantity.doubleValue(
                    for: unit
                )

            var metadataJSON: String?

            if let metadata =
                sample.metadata,
                JSONSerialization.isValidJSONObject(
                    metadata
                ) {

                if let data =
                    try? JSONSerialization.data(
                        withJSONObject: metadata,
                        options: []
                    ) {

                    metadataJSON =
                        String(
                            data: data,
                            encoding: .utf8
                        )
                }
            }

            return ActivityRawSample(
                id:
                    sample.uuid,

                metricType:
                    sample.quantityType.identifier,

                value:
                    value,

                unit:
                    unit.unitString,

                startDate:
                    sample.startDate,

                endDate:
                    sample.endDate,

                sourceName:
                    sample.sourceRevision.source.name,

                sourceBundleIdentifier:
                    sample.sourceRevision.source.bundleIdentifier,

                metadataJSON:
                    metadataJSON
            )
        }
    }
    
    func diagnoseTodayActivityRawCoverage() async {

        let range =
            dayRange(
                for: Date()
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart:
                    range.start,
                end:
                    range.end,
                options:
                    .strictStartDate
            )

        let metrics:
            [(String, HKQuantityTypeIdentifier)] = [

                // MARK: Activity

                (
                    "Steps",
                    .stepCount
                ),

                (
                    "Walking / Running Distance",
                    .distanceWalkingRunning
                ),

                (
                    "Running Speed",
                    .runningSpeed
                ),

                (
                    "Running Stride Length",
                    .runningStrideLength
                ),

                (
                    "Running Power",
                    .runningPower
                ),

                (
                    "Running Ground Contact Time",
                    .runningGroundContactTime
                ),

                (
                    "Running Vertical Oscillation",
                    .runningVerticalOscillation
                ),

                (
                    "Cycling Distance",
                    .distanceCycling
                ),

                (
                    "Cycling Cadence",
                    .cyclingCadence
                ),

                (
                    "Cycling Power",
                    .cyclingPower
                ),

                (
                    "Cycling Functional Threshold Power",
                    .cyclingFunctionalThresholdPower
                ),

                (
                    "Flights Climbed",
                    .flightsClimbed
                ),

                (
                    "Exercise Time",
                    .appleExerciseTime
                ),

                (
                    "Move Time",
                    .appleMoveTime
                ),

                (
                    "Stand Time",
                    .appleStandTime
                ),

                (
                    "VO2 Max",
                    .vo2Max
                ),

                // MARK: Mobility

                (
                    "Walking Steadiness",
                    .appleWalkingSteadiness
                ),

                (
                    "Six Minute Walk Distance",
                    .sixMinuteWalkTestDistance
                ),

                (
                    "Walking Speed",
                    .walkingSpeed
                ),

                (
                    "Walking Step Length",
                    .walkingStepLength
                ),

                (
                    "Walking Asymmetry",
                    .walkingAsymmetryPercentage
                ),

                (
                    "Walking Double Support",
                    .walkingDoubleSupportPercentage
                ),

                (
                    "Stair Ascent Speed",
                    .stairAscentSpeed
                ),

                (
                    "Stair Descent Speed",
                    .stairDescentSpeed
                ),

                // MARK: Energy

                (
                    "Active Energy",
                    .activeEnergyBurned
                ),

                (
                    "Basal Energy",
                    .basalEnergyBurned
                )
            ]

        print("")
        print("===================================")
        print("🏃 ACTIVITY RAW COVERAGE")
        print("===================================")
        print("Date:", Date())
        print("")

        for (
            name,
            identifier
        ) in metrics {

            guard
                let type =
                    HKQuantityType.quantityType(
                        forIdentifier:
                            identifier
                    )
            else {
                print(
                    "❌",
                    name,
                    "→ Type unavailable"
                )

                continue
            }

            do {

                let samples =
                    try await getRawQuantitySamples(
                        type:
                            type,
                        predicate:
                            predicate
                    )

                print(
                    String(
                        format:
                            "%-38@ %5d",
                        name,
                        samples.count
                    )
                )

            } catch {

                print(
                    "❌",
                    name,
                    "→",
                    error
                )
            }
        }

        print("")
        print("===================================")
        print("🏃 END ACTIVITY RAW COVERAGE")
        print("===================================")
        print("")
    }
    
    func getTodayActivityRawSamples()
        async throws -> [ActivityRawSample] {

        let range =
            dayRange(
                for: Date()
            )

        let predicate =
            HKQuery.predicateForSamples(
                withStart:
                    range.start,
                end:
                    range.end,
                options:
                    .strictStartDate
            )

        let stepType =
            HKQuantityType.quantityType(
                forIdentifier:
                    .stepCount
            )!

        return try await getActivityRawSamples(
            type:
                stepType,
            unit:
                HKUnit.count(),
            predicate:
                predicate
        )
    }
    
    private func getAverageQuantity(
      type:
        HKQuantityType,

      predicate:
        NSPredicate,

      unit:
        HKUnit
    ) async throws -> Double {

      let values =
        try await getQuantityValues(
          type:
            type,

          predicate:
            predicate,

          unit:
            unit
        )

      guard
        !values.isEmpty
      else {
        return 0
      }

      return
        values.reduce(
          0,
          +
        )
        / Double(
          values.count
        )
    }

    private func getQuantityValues(
      type:
        HKQuantityType,

      predicate:
        NSPredicate,

      unit:
        HKUnit
    ) async throws -> [Double] {

      try await withCheckedThrowingContinuation {
        continuation
        in

        let query =
          HKSampleQuery(
            sampleType:
              type,

            predicate:
              predicate,

            limit:
              HKObjectQueryNoLimit,

            sortDescriptors: [
              NSSortDescriptor(
                key:
                  HKSampleSortIdentifierEndDate,

                ascending:
                  true
              )
            ]
          ) {

            _,
            samples,
            error
            in

            if let error {

              let nsError = error as NSError

              if nsError.domain == HKError.errorDomain
                && nsError.code == HKError.Code.errorNoData.rawValue
              {

                continuation.resume(
                  returning: []
                )

                return
              }

              continuation.resume(
                throwing: error
              )

              return
            }

            let values =
              (samples
              as? [HKQuantitySample]
              ?? [])
              .map {
                $0.quantity
                  .doubleValue(
                    for: unit
                  )
              }

            continuation.resume(
              returning:
                values
            )
          }

        healthStore.execute(
          query
        )
      }
    }
    func getLastNightHRV()
      async throws -> Double
    {

      let metrics =
        try await getLastNightMetrics(
          for: Date()
        )

      return metrics.averageHRV
    }

    func getLastNightSpO2()
      async throws -> Double
    {

      let metrics =
        try await getLastNightMetrics(
          for: Date()
        )

      return metrics.averageSpO2
    }

    func getLastNightRespiratoryRate()
      async throws -> Double
    {

      let metrics =
        try await getLastNightMetrics(
          for: Date()
        )

      return metrics.averageRespiratoryRate
    }

    func getTodayActiveEnergy()
      async throws -> Int
    {

      try await getActiveEnergy(
        for: Date()
      )
    }

    func getActiveEnergy(
      for date: Date
    ) async throws -> Int {

      let energyType =
        HKQuantityType.quantityType(
          forIdentifier:
            .activeEnergyBurned
        )!

      let range =
        dayRange(
          for: date
        )

      let predicate =
        HKQuery.predicateForSamples(
          withStart:
            range.start,

          end:
            range.end,

          options:
            .strictStartDate
        )

      return try await withCheckedThrowingContinuation {
        continuation
        in

        let query =
          HKSampleQuery(
            sampleType:
              energyType,

            predicate:
              predicate,

            limit:
              HKObjectQueryNoLimit,

            sortDescriptors: [
              NSSortDescriptor(
                key:
                  HKSampleSortIdentifierStartDate,

                ascending:
                  true
              )
            ]
          ) {

            _,
            samples,
            error
            in

            if let error {

              continuation.resume(
                throwing:
                  error
              )

              return
            }

            let energySamples =
              samples
              as? [HKQuantitySample]
              ?? []

            var rawTotal =
              0.0

            for sample in energySamples {

              rawTotal +=
                sample.quantity
                .doubleValue(
                  for:
                    .kilocalorie()
                )
            }

            continuation.resume(
              returning:
                Int(
                  rawTotal
                )
            )
          }

        healthStore.execute(
          query
        )
      }
    }

    func getTodayRestingEnergy()
      async throws -> Int
    {

      try await getRestingEnergy(
        for: Date()
      )
    }

    func getRestingEnergy(
      for date: Date
    ) async throws -> Int {

      let energyType =
        HKQuantityType.quantityType(
          forIdentifier:
            .basalEnergyBurned
        )!

      let range =
        dayRange(
          for: date
        )

      let predicate =
        HKQuery.predicateForSamples(
          withStart:
            range.start,

          end:
            range.end,

          options:
            .strictStartDate
        )

      return try await withCheckedThrowingContinuation {
        continuation
        in

        let query =
          HKSampleQuery(
            sampleType:
              energyType,

            predicate:
              predicate,

            limit:
              HKObjectQueryNoLimit,

            sortDescriptors: [
              NSSortDescriptor(
                key:
                  HKSampleSortIdentifierStartDate,

                ascending:
                  true
              )
            ]
          ) {

            _,
            samples,
            error
            in

            if let error {

              continuation.resume(
                throwing:
                  error
              )

              return
            }

            let energySamples =
              samples
              as? [HKQuantitySample]
              ?? []

            var includedTotal =
              0.0

            for sample in energySamples {

              let sourceBundle =
                sample
                .sourceRevision
                .source
                .bundleIdentifier

              if sourceBundle == "com.garmin.connect.mobile" {
                continue
              }

              includedTotal +=
                sample.quantity
                .doubleValue(
                  for:
                    .kilocalorie()
                )
            }

            continuation.resume(
              returning:
                Int(
                  includedTotal
                    .rounded()
                )
            )
          }

        healthStore.execute(
          query
        )
      }
    }

    func getTodayWorkouts()
      async throws -> [HealthKitWorkoutSummary]
    {

      try await getWorkouts(
        for: Date()
      )
    }

    func getWorkouts(
      for date: Date
    ) async throws -> [HealthKitWorkoutSummary] {

      let workoutType =
        HKObjectType.workoutType()

      let range =
        dayRange(
          for: date
        )

      let predicate =
        HKQuery.predicateForSamples(
          withStart:
            range.start,

          end:
            range.end,

          options:
            .strictStartDate
        )

      return try await withCheckedThrowingContinuation {
        continuation
        in

        let query =
          HKSampleQuery(
            sampleType:
              workoutType,

            predicate:
              predicate,

            limit:
              HKObjectQueryNoLimit,

            sortDescriptors: [
              NSSortDescriptor(
                key:
                  HKSampleSortIdentifierStartDate,

                ascending:
                  true
              )
            ]
          ) {

            _,
            samples,
            error
            in

            if let error {

              continuation.resume(
                throwing:
                  error
              )

              return
            }

            let workouts =
              (samples
              as? [HKWorkout]
              ?? [])
              .map {
                HealthKitWorkoutSummary(
                  workout:
                    $0
                )
              }

            continuation.resume(
              returning:
                workouts
            )
          }

        healthStore.execute(
          query
        )
      }
    }

    func getTodayWorkoutCalories()
      async throws -> Int
    {

      let workouts =
        try await getTodayWorkouts()

      return workouts.reduce(
        0
      ) {
        total,
        workout
        in

        total
          + Int(
            (workout.totalEnergyBurned
              ?? 0)
              .rounded()
          )
      }
    }

    func getTodayWorkoutDistance()
      async throws -> Double
    {

      let workouts =
        try await getTodayWorkouts()

      let meters =
        workouts.reduce(
          0.0
        ) {
          total,
          workout
          in

          total
            + (workout.totalDistance
              ?? 0)
        }

      return meters / 1000.0
    }

    func getTodayDailyMovementCalories()
      async throws -> Int
    {

      let totalActive =
        try await getTodayActiveEnergy()

      let workoutCalories =
        try await getTodayWorkoutCalories()

      return max(
        0,
        totalActive - workoutCalories
      )
    }

    func getRestingHeartRate()
      async throws -> Int
    {

      let heartRateType =
        HKQuantityType.quantityType(
          forIdentifier:
            .restingHeartRate
        )!

      let sortDescriptor =
        NSSortDescriptor(
          key:
            HKSampleSortIdentifierEndDate,

          ascending:
            false
        )

      return try await withCheckedThrowingContinuation {
        continuation
        in

        let query =
          HKSampleQuery(
            sampleType:
              heartRateType,

            predicate:
              nil,

            limit:
              1,

            sortDescriptors: [
              sortDescriptor
            ]
          ) {

            _,
            samples,
            error
            in

            if let error {

              continuation.resume(
                throwing:
                  error
              )

              return
            }

            guard
              let sample =
                samples?.first
                as? HKQuantitySample
            else {

              continuation.resume(
                returning:
                  0
              )

              return
            }

            let bpm =
              sample.quantity
              .doubleValue(
                for:
                  HKUnit.count()
                  .unitDivided(
                    by: .minute()
                  )
              )

            continuation.resume(
              returning:
                Int(
                  bpm.rounded()
                )
            )
          }

        healthStore.execute(
          query
        )
      }
    }

    func getRestingHeartRateHistory(
      days: Int = 7
    ) async throws -> [(
      date: Date,
      bpm: Int
    )] {

      let heartRateType =
        HKQuantityType.quantityType(
          forIdentifier:
            .restingHeartRate
        )!

      let calendar =
        Calendar.current

      let endDate =
        Date()

      let startDate =
        calendar.startOfDay(
          for:
            calendar.date(
              byAdding:
                .day,

              value:
                -(days - 1),

              to:
                endDate
            )!
        )

      let predicate =
        HKQuery.predicateForSamples(
          withStart:
            startDate,

          end:
            endDate,

          options:
            .strictStartDate
        )

      return try await withCheckedThrowingContinuation {
        continuation
        in

        let query =
          HKSampleQuery(
            sampleType:
              heartRateType,

            predicate:
              predicate,

            limit:
              HKObjectQueryNoLimit,

            sortDescriptors: [
              NSSortDescriptor(
                key:
                  HKSampleSortIdentifierEndDate,

                ascending:
                  true
              )
            ]
          ) {

            _,
            samples,
            error
            in

            if let error {

              continuation.resume(
                throwing:
                  error
              )

              return
            }

            let heartSamples =
              samples
              as? [HKQuantitySample]
              ?? []

            var dailyValues:
              [Date:
                [Int]] = [:]

            for sample in heartSamples {

              let day =
                calendar.startOfDay(
                  for:
                    sample.endDate
                )

              let bpm =
                sample.quantity
                .doubleValue(
                  for:
                    HKUnit.count()
                    .unitDivided(
                      by:
                        .minute()
                    )
                )

              dailyValues[
                day,
                default: []
              ]
              .append(
                Int(
                  bpm.rounded()
                )
              )
            }

            let result =
              dailyValues
              .map {
                day,
                values
                in

                let average =
                  values.reduce(
                    0,
                    +
                  )
                  / values.count

                return (
                  date:
                    day,

                  bpm:
                    average
                )
              }
              .sorted {
                $0.date < $1.date
              }

            continuation.resume(
              returning:
                result
            )
          }

        healthStore.execute(
          query
        )
      }
    }
    func getLatestWeight()
      async throws -> Double
    {

      let weightType =
        HKQuantityType.quantityType(
          forIdentifier:
            .bodyMass
        )!

      let sortDescriptor =
        NSSortDescriptor(
          key:
            HKSampleSortIdentifierEndDate,

          ascending:
            false
        )

      return try await withCheckedThrowingContinuation {
        continuation
        in

        let query =
          HKSampleQuery(
            sampleType:
              weightType,

            predicate:
              nil,

            limit:
              1,

            sortDescriptors: [
              sortDescriptor
            ]
          ) {

            _,
            samples,
            error
            in

            if let error {

              continuation.resume(
                throwing:
                  error
              )

              return
            }

            guard
              let sample =
                samples?.first
                as? HKQuantitySample
            else {

              continuation.resume(
                returning:
                  0
              )

              return
            }

            let weight =
              sample.quantity
              .doubleValue(
                for:
                  .gramUnit(
                    with:
                      .kilo
                  )
              )

            continuation.resume(
              returning:
                weight
            )
          }

        healthStore.execute(
          query
        )
      }
    }

    func diagnoseNightMetrics(
      for date: Date
    ) async {

      let range =
        nightRange(
          for: date
        )

      print("")
      print(
        "==================================="
      )
      print(
        "🔎 NIGHT METRICS DIAGNOSTIC"
      )
      print(
        "==================================="
      )

      print(
        "Start:",
        range.start
      )

      print(
        "End:",
        range.end
      )

      do {

        let type =
          HKQuantityType.quantityType(
            forIdentifier:
              .heartRateVariabilitySDNN
          )!

        let values =
          try await getQuantityValues(
            type:
              type,

            predicate:
              nightPredicate(
                for: date
              ),

            unit:
              HKUnit.secondUnit(
                with:
                  .milli
              )
          )

        print("")
        print(
          "❤️ HRV"
        )

        print(
          "Sample count:",
          values.count
        )

        if !values.isEmpty {

          print(
            "Values:",
            values
          )

          print(
            "Average:",
            values.reduce(
              0,
              +
            )
              / Double(
                values.count
              ),
            "ms"
          )

        } else {

          print(
            "❌ No HRV samples found"
          )
        }

      } catch {

        print(
          "❌ HRV query error:",
          error
        )
      }

      do {

        let type =
          HKQuantityType.quantityType(
            forIdentifier:
              .oxygenSaturation
          )!

        let values =
          try await getQuantityValues(
            type:
              type,

            predicate:
              nightPredicate(
                for: date
              ),

            unit:
              .percent()
          )

        let percentages =
          values.map {
            $0 * 100
          }

        print("")
        print(
          "💧 SpO₂"
        )

        print(
          "Sample count:",
          percentages.count
        )

        if !percentages.isEmpty {

          print(
            "Values:",
            percentages
          )

          print(
            "Average:",
            percentages.reduce(
              0,
              +
            )
              / Double(
                percentages.count
              ),
            "%"
          )

          print(
            "Minimum:",
            percentages.min()
              ?? 0,
            "%"
          )

        } else {

          print(
            "❌ No SpO₂ samples found"
          )
        }

      } catch {

        print(
          "❌ SpO₂ query error:",
          error
        )
      }

      do {

        let type =
          HKQuantityType.quantityType(
            forIdentifier:
              .respiratoryRate
          )!

        let values =
          try await getQuantityValues(
            type:
              type,

            predicate:
              nightPredicate(
                for: date
              ),

            unit:
              HKUnit.count()
              .unitDivided(
                by:
                  .minute()
              )
          )

        print("")
        print(
          "🫁 RESPIRATORY RATE"
        )

        print(
          "Sample count:",
          values.count
        )

        if !values.isEmpty {

          print(
            "Values:",
            values
          )

          print(
            "Average:",
            values.reduce(
              0,
              +
            )
              / Double(
                values.count
              ),
            "brpm"
          )

          print(
            "Minimum:",
            values.min()
              ?? 0,
            "brpm"
          )

        } else {

          print(
            "❌ No respiratory rate samples found"
          )
        }

      } catch {

        print(
          "❌ Respiratory Rate query error:",
          error
        )
      }

      print("")
      print(
        "==================================="
      )
      print(
        "🔎 END NIGHT METRICS DIAGNOSTIC"
      )
      print(
        "==================================="
      )
      print("")
    }

    func diagnoseSevenDayNightMetrics(
      endingAt date: Date
    ) async {

      let calendar =
        Calendar.current

      let dayStart =
        calendar.startOfDay(
          for:
            date
        )

      guard
        let startDate =
          calendar.date(
            byAdding:
              .day,

            value:
              -6,

            to:
              dayStart
          )
      else {
        return
      }

      let endDate =
        min(
          Date(),

          calendar.date(
            byAdding:
              .day,

            value:
              1,

            to:
              dayStart
          )!
        )

      let predicate =
        HKQuery.predicateForSamples(
          withStart:
            startDate,

          end:
            endDate,

          options:
            .strictStartDate
        )

      print("")
      print(
        "==================================="
      )
      print(
        "🔎 LAST 7 DAYS HEALTHKIT CHECK"
      )
      print(
        "==================================="
      )

      print(
        "Start:",
        startDate
      )

      print(
        "End:",
        endDate
      )

      do {

        let type =
          HKQuantityType.quantityType(
            forIdentifier:
              .heartRateVariabilitySDNN
          )!

        let samples =
          try await getRawQuantitySamples(
            type:
              type,

            predicate:
              predicate
          )

        print("")
        print(
          "❤️ HRV"
        )

        print(
          "Total samples:",
          samples.count
        )

        if let first =
          samples.first
        {

          print(
            "Oldest:",
            first.startDate,
            "→",
            first.endDate,
            "|",
            first.quantity
              .doubleValue(
                for:
                  HKUnit.secondUnit(
                    with:
                      .milli
                  )
              ),
            "ms"
          )
        }

        if let last =
          samples.last
        {

          print(
            "Newest:",
            last.startDate,
            "→",
            last.endDate,
            "|",
            last.quantity
              .doubleValue(
                for:
                  HKUnit.secondUnit(
                    with:
                      .milli
                  )
              ),
            "ms"
          )
        }

      } catch {

        print(
          "❌ HRV query error:",
          error
        )
      }

      do {

        let type =
          HKQuantityType.quantityType(
            forIdentifier:
              .oxygenSaturation
          )!

        let samples =
          try await getRawQuantitySamples(
            type:
              type,

            predicate:
              predicate
          )

        print("")
        print(
          "💧 SpO₂"
        )

        print(
          "Total samples:",
          samples.count
        )

        if let first =
          samples.first
        {

          print(
            "Oldest:",
            first.startDate,
            "→",
            first.endDate,
            "|",
            first.quantity
              .doubleValue(
                for:
                  .percent()
              )
              * 100,
            "%"
          )
        }

        if let last =
          samples.last
        {

          print(
            "Newest:",
            last.startDate,
            "→",
            last.endDate,
            "|",
            last.quantity
              .doubleValue(
                for:
                  .percent()
              )
              * 100,
            "%"
          )
        }

      } catch {

        print(
          "❌ SpO₂ query error:",
          error
        )
      }

      do {

        let type =
          HKQuantityType.quantityType(
            forIdentifier:
              .respiratoryRate
          )!

        let samples =
          try await getRawQuantitySamples(
            type:
              type,

            predicate:
              predicate
          )

        print("")
        print(
          "🫁 RESPIRATORY RATE"
        )

        print(
          "Total samples:",
          samples.count
        )

        if let first =
          samples.first
        {

          print(
            "Oldest:",
            first.startDate,
            "→",
            first.endDate,
            "|",
            first.quantity
              .doubleValue(
                for:
                  HKUnit.count()
                  .unitDivided(
                    by:
                      .minute()
                  )
              ),
            "brpm"
          )
        }

        if let last =
          samples.last
        {

          print(
            "Newest:",
            last.startDate,
            "→",
            last.endDate,
            "|",
            last.quantity
              .doubleValue(
                for:
                  HKUnit.count()
                  .unitDivided(
                    by:
                      .minute()
                  )
              ),
            "brpm"
          )
        }

      } catch {

        print(
          "❌ Respiratory Rate query error:",
          error
        )
      }

      print("")
      print(
        "==================================="
      )
      print(
        "🔎 END 7 DAY HEALTHKIT CHECK"
      )
      print(
        "==================================="
      )
      print("")

    }


    // MARK: - Body Composition

    func getBodyFatSamples(
      from startDate: Date? = nil,
      to endDate: Date = Date()
    ) async throws -> [HKQuantitySample] {

      let type =
        HKQuantityType.quantityType(
          forIdentifier:
            .bodyFatPercentage
        )!

      return try await getRawQuantitySamples(
        type:
          type,

        predicate:
          samplePredicate(
            from:
              startDate,

            to:
              endDate
          )
      )
    }

    func getLeanBodyMassSamples(
      from startDate: Date? = nil,
      to endDate: Date = Date()
    ) async throws -> [HKQuantitySample] {

      let type =
        HKQuantityType.quantityType(
          forIdentifier:
            .leanBodyMass
        )!

      return try await getRawQuantitySamples(
        type:
          type,

        predicate:
          samplePredicate(
            from:
              startDate,

            to:
              endDate
          )
      )
    }

    func getWaistCircumferenceSamples(
      from startDate: Date? = nil,
      to endDate: Date = Date()
    ) async throws -> [HKQuantitySample] {

      let type =
        HKQuantityType.quantityType(
          forIdentifier:
            .waistCircumference
        )!

      return try await getRawQuantitySamples(
        type:
          type,

        predicate:
          samplePredicate(
            from:
              startDate,

            to:
              endDate
          )
      )
    }

    private func samplePredicate(
      from startDate: Date?,
      to endDate: Date
    ) -> NSPredicate {

      if let startDate {

        return HKQuery.predicateForSamples(
          withStart:
            startDate,

          end:
            endDate,

          options:
            .strictStartDate
        )
      }

      return HKQuery.predicateForSamples(
        withStart:
          Date.distantPast,

        end:
          endDate,

        options:
          .strictEndDate
      )
    }

    func diagnoseBodyComposition() async {

      print("")
      print("===================================")
      print("🧍 BODY COMPOSITION DIAGNOSTIC")
      print("===================================")

      do {

        let bodyFatSamples =
          try await getBodyFatSamples()

        print("")
        print("📊 BODY FAT")

        print(
          "Sample count:",
          bodyFatSamples.count
        )

        for sample in bodyFatSamples {

          let value =
            sample.quantity
              .doubleValue(
                for:
                  .percent()
              ) * 100

          print(
            "•",
            sample.startDate,
            "→",
            sample.endDate,
            "|",
            value,
            "%",
            "|",
            sample.sourceRevision.source.name
          )
        }

      } catch {

        print(
          "❌ Body Fat query error:",
          error
        )
      }

      do {

        let leanBodyMassSamples =
          try await getLeanBodyMassSamples()

        print("")
        print("💪 LEAN BODY MASS")

        print(
          "Sample count:",
          leanBodyMassSamples.count
        )

        for sample in leanBodyMassSamples {

          let value =
            sample.quantity
              .doubleValue(
                for:
                  .gramUnit(
                    with:
                      .kilo
                  )
              )

          print(
            "•",
            sample.startDate,
            "→",
            sample.endDate,
            "|",
            value,
            "kg",
            "|",
            sample.sourceRevision.source.name
          )
        }

      } catch {

        print(
          "❌ Lean Body Mass query error:",
          error
        )
      }

      do {

        let waistSamples =
          try await getWaistCircumferenceSamples()

        print("")
        print("📏 WAIST CIRCUMFERENCE")

        print(
          "Sample count:",
          waistSamples.count
        )

        for sample in waistSamples {

          let value =
            sample.quantity
              .doubleValue(
                for:
                  .meter()
              )

          print(
            "•",
            sample.startDate,
            "→",
            sample.endDate,
            "|",
            value,
            "m",
            "|",
            sample.sourceRevision.source.name
          )
        }

      } catch {

        print(
          "❌ Waist Circumference query error:",
          error
        )
      }

      print("")
      print("===================================")
      print("🧍 END BODY COMPOSITION DIAGNOSTIC")
      print("===================================")
      print("")
    }
    
}
