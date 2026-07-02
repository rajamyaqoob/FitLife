//
//  AddExerciseView.swift
//  FitLife
//
//  Created by Jacob on 23/06/2026.
//


import SwiftUI

struct AddExerciseView: View {
    @EnvironmentObject private var workoutStore: WorkoutStore
    @Environment(\.dismiss) private var dismiss

    let workoutDayID: UUID

    @State private var exerciseName = ""
    @State private var sets = 3
    @State private var repetitions = 10
    @State private var weight: Int = 5
    @State private var time: Int = 60
    
    @State private var minutes = 1
    @State private var seconds = 0
    
    private let timeOptions = Array(stride(from: 30, through: 3600, by: 30))
    private let weightOptions = 0...300
    var body: some View {
        NavigationStack {
            ZStack {
                FitLifeBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {

                        topBar

                        header

                        formCard

                        addButton

                        Spacer(minLength: 25)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 14)
                    .padding(.bottom, 30)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var topBar: some View {
        HStack {
            Button("Cancel") {
                dismiss()
            }
            .font(.headline)
            .foregroundStyle(.teal)

            Spacer()

//            Button("Add") {
//                addExercise()
//            }
//            .font(.headline)
//            .foregroundStyle(.blue)
//            .disabled(cleanExerciseName.isEmpty)
        }
    }

    private var header: some View {
        VStack(spacing: 12) {

            Text("New Exercise")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)
        }
        .padding(.top, 5)
    }

    private var formCard: some View {
        VStack(alignment: .leading, spacing: 22) {

            //formTitle("Exercise Name")

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

            //formTitle("Sets")

            HStack(spacing: 12) {
                Image(systemName: "list.number")
                    .foregroundStyle(.teal)
                    .frame(width: 25)

                Text(sets == 1 ? "1 Set" : "\(sets) Sets")
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

            //formTitle("Reps")

            HStack(spacing: 12) {
                Image(systemName: "repeat")
                    .foregroundStyle(.teal)
                    .frame(width: 25)

                Text(repetitions == 1 ? "1 Rep" : "\(repetitions) Reps")
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
            // Weight Stack Code
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
                        Text(kilos == 1 || kilos == 0 ? "\(kilos) kg" : "\(kilos) kgs")
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
            
            // Time Stack Code
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
                .frame(width: 150, height: 110)
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

    private var addButton: some View {
        Button {
            addExercise()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                Text("Add Exercise")
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

    private func formTitle(_ title: String) -> some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.black)
    }

    private var cleanExerciseName: String {
        exerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func addExercise() {
        guard !cleanExerciseName.isEmpty else { return }

        workoutStore.addExercise(
            to: workoutDayID,
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
}

#Preview {
    let store = WorkoutStore()

    AddExerciseView(workoutDayID: store.workoutDays[0].id)
        .environmentObject(store)
}
