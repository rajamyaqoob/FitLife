//
//  EditWorkoutDayView.swift
//  FitLife
//

import SwiftUI

struct EditWorkoutDayView: View {
    @EnvironmentObject private var workoutStore: WorkoutStore
    @Environment(\.dismiss) private var dismiss

    let workoutDay: WorkoutDay

    @State private var workoutDayName: String
    @State private var selectedIcon: String

    let icons = [
        "dumbbell.fill",
        "flame.fill",
        "figure.run",
        "heart.fill",
        "figure.strengthtraining.traditional",
        "star.fill"
    ]
    
    // Inizializzatore per pre-compilare i campi con i dati attuali
    init(workoutDay: WorkoutDay) {
        self.workoutDay = workoutDay
        _workoutDayName = State(initialValue: workoutDay.name)
        _selectedIcon = State(initialValue: workoutDay.icon)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                FitLifeBackground()

                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Button("Cancel") {
                                dismiss()
                            }
                            .font(.headline)
                            .foregroundStyle(.teal)

                            Spacer()

                            .font(.headline)
                            .foregroundStyle(.blue)
                            .disabled(workoutDayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }

                        VStack(spacing: 12) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.system(size: 45, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 100, height: 100)
                                .background(
                                    LinearGradient(
                                        colors: [.teal, .blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: .blue.opacity(0.25), radius: 12, y: 7)

                            Text("Edit Workout Day")
                                .font(.system(size: 28, weight: .bold))

                            Text("Modify your workout plan")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        .padding(.top, 10)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Workout Name")
                                .font(.subheadline.weight(.semibold))

                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundStyle(.teal)

                                TextField("Example: Push Day A", text: $workoutDayName)
                                    .font(.headline)
                            }
                            .padding()
                            .background(.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
                        }

                        VStack(alignment: .leading, spacing: 14) {
                            Text("Choose Icon")
                                .font(.subheadline.weight(.semibold))

                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ],
                                spacing: 14
                            ) {
                                ForEach(icons, id: \.self) { icon in
                                    Button {
                                        selectedIcon = icon
                                    } label: {
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .foregroundStyle(
                                                selectedIcon == icon ? .white : .teal
                                            )
                                            .frame(width: 74, height: 64)
                                            .background(
                                                selectedIcon == icon
                                                ? AnyShapeStyle(
                                                    LinearGradient(
                                                        colors: [.teal, .blue],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                : AnyShapeStyle(.white.opacity(0.9))
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: 18))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        Button {
                            saveChanges()
                        } label: {
                            Text("Save Changes")
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
                                .shadow(color: .blue.opacity(0.25), radius: 10, y: 6)
                        }
                        .disabled(workoutDayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .opacity(
                            workoutDayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                            ? 0.55 : 1
                        )
                    }
                    .padding(20)
                    .padding(.bottom, 30)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    private func saveChanges() {
        workoutStore.updateWorkoutDay(
            id: workoutDay.id,
            name: workoutDayName,
            icon: selectedIcon
        )
        dismiss()
    }
}

#Preview {
    let previewStore = WorkoutStore()
    
    return EditWorkoutDayView(workoutDay: previewStore.workoutDays[0])
        .environmentObject(previewStore)
}
