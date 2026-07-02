import SwiftUI
import Combine

struct ExerciseTimerView: View {
    @EnvironmentObject private var workoutStore: WorkoutStore
    @Environment(\.dismiss) private var dismiss

    let workoutDayID: UUID
    let exercise: Exercise

    @State private var remainingSeconds: Int
    @State private var isRunning = false
    @State private var hasMarkedCompleted = false

    private let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    )
    .autoconnect()

    init(workoutDayID: UUID, exercise: Exercise) {
        self.workoutDayID = workoutDayID
        self.exercise = exercise

        _remainingSeconds = State(
            initialValue: max(exercise.time, 1)
        )
    }

    var body: some View {
        ZStack {
            FitLifeBackground()

            VStack(spacing: 28) {
                HStack {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundStyle(.teal)

                    Spacer()
                }

                Spacer()

                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 110, height: 110)
                    .background(
                        LinearGradient(
                            colors: [.teal, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())

                Text(exercise.name)
                    .font(.system(size: 30, weight: .bold))
                    .multilineTextAlignment(.center)

                Text(timeText)
                    .font(.system(size: 62, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.teal)

                Text(remainingSeconds == 0 ? "Exercise completed!" : "Time remaining")
                    .font(.headline)
                    .foregroundStyle(
                        remainingSeconds == 0 ? Color.green : Color.gray
                    )

                HStack(spacing: 18) {
                    Button {
                        resetTimer()
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.headline)
                            .foregroundStyle(.teal)
                            .frame(width: 130, height: 54)
                            .background(.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Button {
                        guard remainingSeconds > 0 else { return }
                        isRunning.toggle()
                    } label: {
                        Label(
                            isRunning ? "Pause" : "Start",
                            systemImage: isRunning ? "pause.fill" : "play.fill"
                        )
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 130, height: 54)
                        .background(
                            LinearGradient(
                                colors: [.teal, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }

                Spacer()
            }
            .padding(20)
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            guard remainingSeconds > 0 else { return }

            remainingSeconds -= 1

            if remainingSeconds == 0 {
                isRunning = false
                markExerciseCompleted()
            }
        }
    }

    private var timeText: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func resetTimer() {
        isRunning = false
        remainingSeconds = max(exercise.time, 1)
        hasMarkedCompleted = false
    }

    private func markExerciseCompleted() {
        guard !hasMarkedCompleted else { return }

        workoutStore.markExerciseCompleted(
            workoutDayID: workoutDayID,
            exerciseID: exercise.id
        )

        hasMarkedCompleted = true
    }
}

#Preview {
    let store = WorkoutStore()

    ExerciseTimerView(
        workoutDayID: store.workoutDays[0].id,
        exercise: store.workoutDays[0].exercises[0]
    )
    .environmentObject(store)
}
