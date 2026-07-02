//
//  WorkoutStore.swift
//  FitLife
//
//  Created by Jacob on 23/06/2026.
//


import Foundation
import Combine
import SwiftUI

final class WorkoutStore: ObservableObject {

    @Published var workoutDays: [WorkoutDay] = [] {
        didSet {
            saveWorkoutDays()
        }
    }

    private let storageKey = "fitlife_workout_days"

    init() {
        loadWorkoutDays()

        if workoutDays.isEmpty {
            workoutDays = sampleWorkoutDays()
        }
    }

    // MARK: - Workout Days
    func updateWorkoutDay(id: UUID, name: String, icon: String) {
            let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !cleanName.isEmpty else { return }

            if let index = workoutDays.firstIndex(where: { $0.id == id }) {
                workoutDays[index].name = cleanName
                workoutDays[index].icon = icon
            }
        }

    func addWorkoutDay(name: String) {
        addWorkoutDayWithIcon(
            name: name,
            icon: "dumbbell.fill"
        )
    }

    func addWorkoutDayWithIcon(name: String, icon: String) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else { return }

        let newWorkoutDay = WorkoutDay(
            name: cleanName,
            icon: icon,
            exercises: []
        )

        workoutDays.append(newWorkoutDay)
    }

    func deleteWorkoutDay(at offsets: IndexSet) {
        workoutDays.remove(atOffsets: offsets)
    }
    
    func duplicateWorkoutDay(at offsets: IndexSet) {
        //workoutDays.remove(atOffsets: offsets)
        dump("data in fun 1")
    }
    
    @discardableResult
    func duplicateWorkoutDay(id: UUID) -> UUID? {
        guard let originalDay = workoutDays.first(where: { $0.id == id }) else {
            return nil
        }

        let copiedExercises = originalDay.exercises.map { exercise in
            Exercise(
                id: UUID(),
                name: exercise.name,
                sets: exercise.sets,
                repetitions: exercise.repetitions,
                weight: exercise.weight,
                time: exercise.time
            )
        }

        let copiedWorkoutDay = WorkoutDay(
            id: UUID(),
            name: "\(originalDay.name) Copy",
            icon: originalDay.icon,
            exercises: copiedExercises
        )

        workoutDays.append(copiedWorkoutDay)

        // didSet on workoutDays already calls saveWorkoutDays()
        return copiedWorkoutDay.id
    }
    
    func deleteWorkoutDay(id: UUID) {
        workoutDays.removeAll { $0.id == id }
    }

    // MARK: - Exercises

    func addExercise(
        to workoutDayID: UUID,
        name: String,
        sets: Int,
        repetitions: Int,
        weight: Int,
        time: Int
    ) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else { return }

        guard let dayIndex = workoutDays.firstIndex(where: { $0.id == workoutDayID }) else {
            return
        }

        let newExercise = Exercise(
            name: cleanName,
            sets: sets,
            repetitions: repetitions,
            weight: weight,
            time: time
            
        )

        workoutDays[dayIndex].exercises.append(newExercise)
    }

    func updateExercise(
        workoutDayID: UUID,
        exerciseID: UUID,
        name: String,
        sets: Int,
        repetitions: Int,
        weight: Int,
        time: Int
    ) {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanName.isEmpty else { return }

        guard let dayIndex = workoutDays.firstIndex(where: { $0.id == workoutDayID }),
              let exerciseIndex = workoutDays[dayIndex].exercises.firstIndex(where: { $0.id == exerciseID })
        else {
            return
        }
        
        workoutDays[dayIndex].exercises[exerciseIndex].name = cleanName
        workoutDays[dayIndex].exercises[exerciseIndex].sets = sets
        workoutDays[dayIndex].exercises[exerciseIndex].repetitions = repetitions
        workoutDays[dayIndex].exercises[exerciseIndex].weight = weight
        workoutDays[dayIndex].exercises[exerciseIndex].time = time
    }

    func deleteExercise(workoutDayID: UUID, at offsets: IndexSet) {
        guard let dayIndex = workoutDays.firstIndex(where: { $0.id == workoutDayID }) else {
            return
        }

        workoutDays[dayIndex].exercises.remove(atOffsets: offsets)
    }

    func deleteExercise(
        workoutDayID: UUID,
        exerciseID: UUID
    ) {
        guard let dayIndex = workoutDays.firstIndex(where: { $0.id == workoutDayID }) else {
            return
        }

        workoutDays[dayIndex].exercises.removeAll { exercise in
            exercise.id == exerciseID
        }
    }

    // MARK: - Local Storage

    private func saveWorkoutDays() {
        do {
            let data = try JSONEncoder().encode(workoutDays)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("Unable to save workouts: \(error.localizedDescription)")
        }
    }

    private func loadWorkoutDays() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return
        }

        do {
            workoutDays = try JSONDecoder().decode(
                [WorkoutDay].self,
                from: data
            )
        } catch {
            print("Unable to load workouts: \(error.localizedDescription)")
        }
    }

    // MARK: - Starter Data

    private func sampleWorkoutDays() -> [WorkoutDay] {
        [
            WorkoutDay(
                name: "Push Day A",
                icon: "dumbbell.fill",
                exercises: [
                    Exercise(name: "Bench Press", sets: 3, repetitions: 10, weight:5, time: 1),
                    Exercise(name: "Incline Dumbbell Press", sets: 3, repetitions: 10, weight:5, time: 1),
                    Exercise(name: "Overhead Press", sets: 3, repetitions: 8, weight:5, time: 1),
                    Exercise(name: "Cable Fly", sets: 3, repetitions: 12, weight:5, time: 1)
                ]
            ),

            WorkoutDay(
                name: "Pull Day B",
                icon: "figure.strengthtraining.traditional",
                exercises: [
                    Exercise(name: "Lat Pulldown", sets: 3, repetitions: 12, weight:5, time: 1),
                    Exercise(name: "Seated Row", sets: 3, repetitions: 10, weight:5, time: 1),
                    Exercise(name: "Bicep Curl", sets: 3, repetitions: 12, weight:5, time: 1)
                ]
            ),

            WorkoutDay(
                name: "Leg Day",
                icon: "figure.run",
                exercises: [
                    Exercise(name: "Squats", sets: 4, repetitions: 12, weight:5, time: 1),
                    Exercise(name: "Lunges", sets: 3, repetitions: 10, weight:5, time: 1),
                    Exercise(name: "Calf Raises", sets: 3, repetitions: 15, weight:5, time: 1)
                ]
            )
        ]
    }
    
    
    func markExerciseCompleted(
        workoutDayID: UUID,
        exerciseID: UUID
    ) {
        guard let dayIndex = workoutDays.firstIndex(where: { $0.id == workoutDayID }),
              let exerciseIndex = workoutDays[dayIndex].exercises.firstIndex(where: { $0.id == exerciseID })
        else {
            return
        }

        workoutDays[dayIndex].exercises[exerciseIndex].lastCompletedAt = Date()
    }
    

    private func defaultExercises(for dayName: String) -> [Exercise] {
        let name = dayName.lowercased()

        if name.contains("chest") || name.contains("push") {
            return [
                Exercise(name: "Bench Press", sets: 3, repetitions: 10, weight:5, time: 1),
                Exercise(name: "Push Ups", sets: 3, repetitions: 12, weight:5, time: 1),
                Exercise(name: "Overhead Press", sets: 3, repetitions: 10, weight:5, time: 1)
            ]
        }

        if name.contains("leg") {
            return [
                Exercise(name: "Squats", sets: 4, repetitions: 12, weight:5, time: 1),
                Exercise(name: "Lunges", sets: 3, repetitions: 10, weight:5, time: 1),
                Exercise(name: "Calf Raises", sets: 3, repetitions: 15, weight:5, time: 1)
            ]
        }

        if name.contains("bicep") || name.contains("pull") {
            return [
                Exercise(name: "Bicep Curl", sets: 3, repetitions: 12, weight:5, time: 1),
                Exercise(name: "Hammer Curl", sets: 3, repetitions: 10, weight:5, time: 1),
                Exercise(name: "Lat Pulldown", sets: 3, repetitions: 12, weight:5, time:1)
            ]
        }

        if name.contains("tricep") {
            return [
                Exercise(name: "Tricep Dips", sets: 3, repetitions: 12, weight: 5, time: 1),
                Exercise(name: "Tricep Extension", sets: 3, repetitions: 10, weight:5, time: 1)
            ]
        }

        return [
            Exercise(name: "New Exercise", sets: 3, repetitions: 10, weight:5,time:1)
        ]
    }
}

struct WorkoutStorePreview: View {
    @StateObject private var workoutStore = WorkoutStore()

    var body: some View {
        WorkoutDaysView()
            .environmentObject(workoutStore)
    }
}




#Preview {
    WorkoutStorePreview()
}
