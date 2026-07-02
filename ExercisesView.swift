//
//  ExercisesView.swift
//  FitLife
//
//  Created by Jacob on 23/06/2026.
//

import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject private var workoutStore: WorkoutStore
    @Environment(\.dismiss) private var dismiss

    let workoutDayID: UUID

    @State private var showAddExercise = false

    // Edit sheet item
    @State private var selectedExercise: Exercise?

    // Delete alert
    @State private var exerciseToDelete: Exercise?
    @State private var showDeleteConfirmation = false

    // Timer sheet item
    @State private var selectedTimerExercise: Exercise?

    private var workoutDay: WorkoutDay? {
        workoutStore.workoutDays.first { $0.id == workoutDayID }
    }

    var body: some View {
        ZStack {
            FitLifeBackground()

            if let workoutDay {
                VStack(spacing: 0) {
                    topHeader(workoutDay: workoutDay)

                    if workoutDay.exercises.isEmpty {
                        emptyExercisesView
                    } else {
                        List {
                            ForEach(
                                Array(workoutDay.exercises.enumerated()),
                                id: \.element.id
                            ) { index, exercise in

                                ElegantExerciseCard(
                                    number: index + 1,
                                    exercise: exercise,
                                    onTimerTap: {
                                        selectedTimerExercise = exercise
                                    }
                                )
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                                .swipeActions(
                                    edge: .trailing,
                                    allowsFullSwipe: false
                                ) {
                                    Button {
                                        selectedExercise = exercise
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)

                                    Button(role: .destructive) {
                                        exerciseToDelete = exercise
                                        showDeleteConfirmation = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }

                //addExerciseButton
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)

        // Add Exercise
        .sheet(isPresented: $showAddExercise) {
            AddExerciseView(workoutDayID: workoutDayID)
                .environmentObject(workoutStore)
        }

        // Edit Exercise
        .sheet(item: $selectedExercise) { exercise in
            EditExerciseView(
                workoutDayID: workoutDayID,
                exercise: exercise
            )
            .environmentObject(workoutStore)
        }

        // Exercise Timer
        .sheet(item: $selectedTimerExercise) { exercise in
            ExerciseTimerView(
                workoutDayID: workoutDayID,
                exercise: exercise
            )
            .environmentObject(workoutStore)
        }

        // Delete Alert
        .alert(
            "Delete Exercise?",
            isPresented: $showDeleteConfirmation
        ) {
            Button("Cancel", role: .cancel) {
                exerciseToDelete = nil
            }

            Button("Delete", role: .destructive) {
                deleteSelectedExercise()
            }
        } message: {
            Text("Are you sure you want to delete this exercise? This action cannot be undone.")
        }
    }

    // MARK: - Header

    private func topHeader(workoutDay: WorkoutDay) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Button {
                    dismiss()
                    
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline.bold())
                        .foregroundStyle(.black)
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.85))
                        .clipShape(Circle())
                }

                Spacer()
                Button {
                    showAddExercise = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            Color(.blue)
                        )
                        .clipShape(Circle())
                        .shadow(
                            color: Color.blue.opacity(0.30),
                            radius: 10,
                            y: 5
                        )
                }
                .accessibilityLabel("Add exercise")
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(workoutDay.name)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)

                Text("Build strength and stay consistent")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            HStack(spacing: 8) {
                Text("\(workoutDay.exercises.count) Exercises")
                    .foregroundStyle(.teal)

                Text("•")
                    .foregroundStyle(.gray)

                Text("Workout Plan")
                    .foregroundStyle(.gray)
            }
            .font(.subheadline.weight(.medium))
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Empty State

    private var emptyExercisesView: some View {
        VStack(spacing: 12) {
            Spacer()

            Image(systemName: "dumbbell.fill")
                .font(.system(size: 42))
                .foregroundStyle(.teal)

            Text("No exercises yet")
                .font(.headline)

            Text("Tap the plus button to add an exercise.")
                .font(.subheadline)
                .foregroundStyle(.gray)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .padding(.horizontal, 20)
    }

    // MARK: - Add Button

    private var addExerciseButton: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button {
                    showAddExercise = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 68, height: 68)
                        .background(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(
                            color: .blue.opacity(0.35),
                            radius: 14,
                            y: 8
                        )
                }
            }
            .padding(.trailing, 24)
            .padding(.bottom, 20)
        }
    }

    // MARK: - Delete

    private func deleteSelectedExercise() {
        guard let exercise = exerciseToDelete else { return }

        workoutStore.deleteExercise(
            workoutDayID: workoutDayID,
            exerciseID: exercise.id
        )

        self.exerciseToDelete = nil
    }
}

// MARK: - Exercise Card

struct ElegantExerciseCard: View {
    let number: Int
    let exercise: Exercise
    let onTimerTap: () -> Void

    var body: some View {
        HStack(spacing: 14) {
//            Image(systemName: "figure.walk")
//                .font(.title2)
//                .foregroundStyle(.teal)
//                .frame(width: 64, height: 64)
//                .background(Color.teal.opacity(0.16))
//                .clipShape(RoundedRectangle(cornerRadius: 20))
            Button {
                onTimerTap()
            } label: {
                Image(systemName: "clock")
                    .font(.headline)
                    .foregroundStyle(.black.opacity(0.9))
                    .frame(width: 50, height: 50)
                    .background(Color.green.opacity(0.5))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 7) {
                Text("\(number). \(exercise.name)")
                    .font(.headline)
                    .foregroundStyle(.black)
                
                Text(exerciseDetails)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            
                if let lastCompletedAt = exercise.lastCompletedAt {
                       Text("Done \(lastCompletedAt, style: .relative) ago")
                           .font(.caption)
                           .foregroundStyle(.green)
                   } else {
                       Text("Not completed yet")
                           .font(.caption)
                           .foregroundStyle(.orange)
                   }
            }

            Spacer()

//            Button {
//                onTimerTap()
//            } label: {
//                Image(systemName: "clock")
//                    .font(.headline)
//                    .foregroundStyle(.black.opacity(0.9))
//                    .frame(width: 50, height: 50)
//                    .background(Color.green.opacity(0.5))
//                    .clipShape(Circle())
//            }
//            .buttonStyle(.plain)
        }
        .padding(16)
        .background(.white.opacity(0.90))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(
            color: .black.opacity(0.07),
            radius: 12,
            y: 6
        )
    }

    private var exerciseDetails: String {
        var details = "\(exercise.sets) Sets × \(exercise.repetitions) Reps"

        if exercise.weight > 0 {
            details += " • \(exercise.weight) kg"
        }

        details += " • \(formattedTime(exercise.time))"
        return details
    }

    private func formattedTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60

        if minutes == 0 {
            return "\(seconds) sec"
        }

        if seconds == 0 {
            return minutes == 1 ? "1 min" : "\(minutes) min"
        }

        return "\(minutes) min \(seconds) sec"
    }
}

// MARK: - Preview

#Preview {
    let store = WorkoutStore()

    ExercisesView(
        workoutDayID: store.workoutDays[0].id
    )
    .environmentObject(store)
}
