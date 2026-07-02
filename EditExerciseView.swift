//
//  EditExerciseView.swift
//  FitLife
//
//  Created by Jacob on 23/06/2026.
//
//
//  EditExerciseView.swift
//  FitLife
//
//  Created by Jacob on 23/06/2026.
//

import SwiftUI

struct EditExerciseView: View {
    @EnvironmentObject private var workoutStore: WorkoutStore
    @Environment(\.dismiss) private var dismiss

    let workoutDayID: UUID
    let exercise: Exercise

    @State private var exerciseName: String
    @State private var sets: Int
    @State private var repetitions: Int
    @State private var weight: Int
    @State private var time: Int
    
    private let timeOptions = Array(stride(from: 30, through: 3600, by: 30))
    private let weightOptions = 0...300
    
    @State private var showDeleteConfirmation = false

    init(workoutDayID: UUID, exercise: Exercise) {
        self.workoutDayID = workoutDayID
        self.exercise = exercise

        _exerciseName = State(initialValue: exercise.name)
        _sets = State(initialValue: exercise.sets)
        _repetitions = State(initialValue: exercise.repetitions)
        _weight = State(initialValue: exercise.weight)

        let validTime = max(30, min(exercise.time, 3600))
        _time = State(initialValue: validTime)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FitLifeBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        
                        topBar
                        
                        header
                        
                        formCard
                        
                        saveButton
                        
                        deleteButton
                        
                        Spacer(minLength: 25)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 30)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .alert("Delete Exercise?", isPresented: $showDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }

                Button("Delete", role: .destructive) {
                    deleteExercise()
                }
            } message: {
                Text("Are you sure you want to delete this exercise? This action cannot be undone.")
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .font(.headline)
            .foregroundStyle(.teal)

            Spacer()

//            Button("Save") {
//                saveExercise()
//            }
//            .font(.headline)
//            .foregroundStyle(.blue)
//            .disabled(cleanExerciseName.isEmpty)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 12) {
//            ZStack {
//                Circle()
//                    .fill(.white.opacity(0.92))
//                    .frame(width: 108, height: 108)
//                    .shadow(
//                        color: Color.blue.opacity(0.14),
//                        radius: 14,
//                        y: 7
//                    )
//
//                RoundedRectangle(cornerRadius: 22)
//                    .fill(
//                        LinearGradient(
//                            colors: [.teal, .blue],
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        )
//                    )
//                    .frame(width: 66, height: 66)
//
//                Image(systemName: "dumbbell.fill")
//                    .font(.system(size: 29, weight: .bold))
//                    .foregroundStyle(.white)
//            }

            Text("Edit Exercise")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)

//            Text("Update your exercise details")
//                .font(.subheadline)
//                .foregroundStyle(.gray)
        }
        .padding(.top, 2)
    }

    // MARK: - Form Card

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 22) {

            HStack(spacing: 12) {
                Image(systemName: "clipboard")
                    .foregroundStyle(.teal)
                    .frame(width: 25)

                TextField("Example: Bench Press", text: $exerciseName)
                    .font(.headline)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack(spacing: 12) {
                Image(systemName: "list.number")
                    .foregroundStyle(.teal)
                    .frame(width: 25)

                Text("\(sets) Sets")
                    .font(.headline)
                    .foregroundStyle(.black)

                Spacer()

                Stepper("", value: $sets, in: 1...20)
                    .labelsHidden()
                    .tint(.teal)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack(spacing: 12) {
                Image(systemName: "repeat")
                    .foregroundStyle(.teal)
                    .frame(width: 25)

                Text("\(repetitions) Reps")
                    .font(.headline)
                    .foregroundStyle(.black)

                Spacer()

                Stepper("", value: $repetitions, in: 1...100)
                    .labelsHidden()
                    .tint(.teal)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack(spacing:12){
                Image(systemName: "dumbbell")
                    .foregroundStyle(.teal)
                    .frame(width: 25)
                Text("Weight")
                    .font(.headline)
                    .foregroundStyle(.black)
                Spacer()
                
                Picker("Weight", selection: $weight) {
                    ForEach(weightOptions, id: \.self) { kilos in
                        Text(kilos == 1 ? "\(kilos) kg" : "\(kilos) kgs")
                            .tag(kilos)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 150, height: 110)
                .clipped()

            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            HStack(spacing: 12) {
                Image(systemName: "clock")
                    .foregroundStyle(.teal)
                    .frame(width: 25)

                Text("Time")
                    .font(.headline)
                    .foregroundStyle(.black)

                Spacer()

                Picker("Time", selection: $time) {
                    ForEach(timeOptions, id: \.self) { duration in
                        Text(formattedTime(duration))
                            .tag(duration)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 170, height: 110)
                .clipped()
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .padding(20)
        .background(.white.opacity(0.70))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(
            color: Color.black.opacity(0.07),
            radius: 14,
            y: 7
        )
    }

    // MARK: - Buttons

    private var saveButton: some View {
        Button {
            saveExercise()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                Text("Save Changes")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.teal, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(
                color: Color.blue.opacity(0.28),
                radius: 12,
                y: 7
            )
        }
        .disabled(cleanExerciseName.isEmpty)
        .opacity(cleanExerciseName.isEmpty ? 0.50 : 1)
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            showDeleteConfirmation = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "trash.fill")
                Text("Delete Exercise")
            }
            .font(.headline)
        }
        .padding(.top, 4)
    }

    // MARK: - Helpers

    private var cleanExerciseName: String {
        exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func saveExercise() {
        guard !cleanExerciseName.isEmpty else { return }

        workoutStore.updateExercise(
            workoutDayID: workoutDayID,
            exerciseID: exercise.id,
            name: cleanExerciseName,
            sets: sets,
            repetitions: repetitions,
            weight: weight,
            time: time
        )

        dismiss()
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
    
    private func deleteExercise() {
        workoutStore.deleteExercise(
            workoutDayID: workoutDayID,
            exerciseID: exercise.id
        )

        dismiss()
    }
    
}

#Preview {
    let store = WorkoutStore()

    EditExerciseView(
        workoutDayID: store.workoutDays[0].id,
        exercise: store.workoutDays[0].exercises[0]
    )
    .environmentObject(store)
}


