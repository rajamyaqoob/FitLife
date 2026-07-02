//
//  WorkoutDaysView.swift
//  FitLife
//
//  Created by Jacob on 25/06/2026.
//


//
//  WorkoutDaysView.swift
//  FitLife
//
import SwiftUI

struct WorkoutDaysView: View {
    @EnvironmentObject private var workoutStore: WorkoutStore

    @State private var showAddDayScreen = false
    @State private var workoutDayToDelete: WorkoutDay?
    @State private var workoutDayToDuplicate: WorkoutDay?
    @State private var showDeleteConfirmation = false
    @State private var showDuplicateConfirmation = false
    @State private var workoutDayToEdit: WorkoutDay?
    @State private var newDayID: UUID?

    var body: some View {
        NavigationStack {
            ZStack {
                FitLifeBackground()

                List {
                    headerView
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(
                            EdgeInsets(
                                top: 18,
                                leading: 20,
                                bottom: 22,
                                trailing: 20
                            )
                        )

                    ForEach(workoutStore.workoutDays) { workoutDay in
                        ZStack {
                            WorkoutDayCard(workoutDay: workoutDay)

                            NavigationLink {
                                ExercisesView(workoutDayID: workoutDay.id)
                            } label: {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(
                            EdgeInsets(
                                top: 0,
                                leading: 20,
                                bottom: 16,
                                trailing: 20
                            )
                        )
                        .swipeActions(
                            edge: .trailing,
                            allowsFullSwipe: false
                        ) {
                            Button {
                                workoutDayToEdit = workoutDay
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)

                            Button(role: .destructive) {
                                workoutDayToDelete = workoutDay
                                showDeleteConfirmation = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                workoutDayToDuplicate = workoutDay
                                showDuplicateConfirmation = true
                            } label: {
                                Label(
                                    "Duplicate",
                                    systemImage: "plus.square.on.square"
                                )
                            }
                            .tint(.orange)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $newDayID) { id in
                ExercisesView(workoutDayID: id)
            }
            .sheet(isPresented: $showAddDayScreen) {
                AddWorkoutDayView { createdID in
                    newDayID = createdID
                }
                .environmentObject(workoutStore)
            }
            .fullScreenCover(item: $workoutDayToEdit) { workoutDay in
                EditWorkoutDayView(workoutDay: workoutDay)
                    .environmentObject(workoutStore)
            }
            .alert(
                "Delete Workout Plan?",
                isPresented: $showDeleteConfirmation
            ) {
                Button("Cancel", role: .cancel) {
                    workoutDayToDelete = nil
                }

                Button("Delete", role: .destructive) {
                    guard let day = workoutDayToDelete else { return }

                    workoutStore.deleteWorkoutDay(id: day.id)
                    workoutDayToDelete = nil
                }
            } message: {
                Text(
                    "Are you sure you want to delete this workout plan? All exercises inside will be lost. This action cannot be undone."
                )
            }
            .alert(
                "Duplicate Workout Plan?",
                isPresented: $showDuplicateConfirmation
            ) {
                Button("Cancel", role: .cancel) {
                    workoutDayToDuplicate = nil
                }

                Button("Duplicate") {
                    guard let day = workoutDayToDuplicate else { return }

                    if let copiedDayID = workoutStore.duplicateWorkoutDay(
                        id: day.id
                    ) {
                        newDayID = copiedDayID
                    }

                    workoutDayToDuplicate = nil
                }
            } message: {
                Text(
                    "Are you sure you want to duplicate this workout plan? All exercises inside will be copied."
                )
            }
        }
    }

    private var headerView: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Workout Plans")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.black)

                Text("Stay consistent, get stronger")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Spacer()

            Button {
                showAddDayScreen = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 29, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 78, height: 58)
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
            .accessibilityLabel("Add workout day")
        }
    }
}

struct WorkoutDayCard: View {
    let workoutDay: WorkoutDay

    private var iconBackground: Color {
        let name = workoutDay.name.lowercased()

        if name.contains("pull") {
            return Color.orange.opacity(0.28)
        }

        if name.contains("leg") {
            return Color.purple.opacity(0.20)
        }

        return Color.teal.opacity(0.20)
    }

    private var iconColor: Color {
        let name = workoutDay.name.lowercased()

        if name.contains("pull") {
            return .orange
        }

        if name.contains("leg") {
            return .purple
        }

        return .teal
    }

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: workoutDay.icon)
                .font(.system(size: 27, weight: .semibold))
                .foregroundStyle(iconColor)
                .frame(width: 68, height: 68)
                .background(iconBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(alignment: .leading, spacing: 7) {
                Text(workoutDay.name)
                    .font(.headline)
                    .foregroundStyle(.black)

                Text("\(workoutDay.exercises.count) Exercises")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.teal)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.subheadline.bold())
                .foregroundStyle(.black.opacity(0.65))
                .frame(width: 38, height: 38)
                .background(Color.gray.opacity(0.08))
                .clipShape(Circle())
        }
        .padding(16)
        .background(.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(
            color: Color.black.opacity(0.07),
            radius: 14,
            y: 7
        )
    }
}

#Preview {
    WorkoutDaysView()
        .environmentObject(WorkoutStore())
}
