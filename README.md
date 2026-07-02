# FitLife

FitLife is a simple, user-friendly iOS workout planner built with **SwiftUI**. It helps users organize workout routines, add exercises with training details, use exercise timers, and keep track of completed workouts in one place.

## What FitLife Helps You Do

FitLife is designed for people who want a lightweight way to plan and follow their gym or home workout routine. Instead of remembering exercises, sets, reps, weight, and exercise duration, users can save each workout plan inside the app and access it whenever they train.

The app supports common workout splits such as:

- Push Day
- Pull Day
- Leg Day
- Cardio Day
- Chest Day
- Biceps / Triceps Day
- Custom workout plans

## Features

### Workout Plan Management

Users can create and organize multiple workout plans.

- Create a new workout day or workout plan
- Choose a name such as `Push Day A`, `Leg Day`, or `Cardio`
- Select an icon for each workout plan
- Open a workout plan to view its exercises
- Edit an existing workout plan name and icon
- Duplicate a complete workout plan, including all exercises
- Delete workout plans when they are no longer needed

FitLife includes starter workout plans for Push, Pull, and Legs so users can begin quickly.

### Exercise Management

Each workout plan can contain multiple exercises.

For every exercise, users can save:

- Exercise name
- Number of sets
- Repetitions
- Weight in kilograms
- Exercise timer duration

Users can also:

- Add new exercises
- Edit exercise details
- Delete exercises
- View the number of exercises inside every workout plan

### Built-In Exercise Timer

FitLife includes a timer for each exercise.

Users can:

- Start and pause the timer
- Reset the timer
- See the remaining exercise time
- Automatically mark an exercise as completed when the timer reaches zero

After completion, the app shows when the exercise was last completed. Exercises that have not yet been completed are also clearly identified.

### Persistent Local Storage

Workout plans and exercises are stored locally using `UserDefaults`.

This means:

- Workout data stays available after closing and reopening the app
- Users do not need an account to save their workout plans
- The app works without an internet connection for its current core features

### Onboarding Experience

The first-time onboarding screens explain how to use the app:

1. Create a workout plan
2. Add exercises
3. Edit or delete exercises
4. Start an exercise timer
5. Begin using FitLife

## How to Use the App

1. Open FitLife and complete the onboarding screens.
2. Tap the **plus button** on the Workout Plans screen.
3. Enter a workout plan name and select an icon.
4. Open the new workout plan.
5. Tap the **plus button** to add an exercise.
6. Enter the exercise name, sets, repetitions, weight, and time.
7. Tap the clock button beside an exercise to start its timer.
8. Swipe left on a workout plan or exercise to reveal edit, duplicate, or delete actions.

## Main Screens

| Screen | Purpose |
|---|---|
| Onboarding | Introduces the main features for first-time users |
| Workout Plans | Displays all saved workout plans |
| Add Workout Day | Creates a new workout plan with a custom name and icon |
| Edit Workout Day | Updates a workout plan name or icon |
| Exercises | Shows all exercises inside the selected workout plan |
| Add Exercise | Adds exercise name, sets, reps, weight, and timer duration |
| Edit Exercise | Updates or deletes an existing exercise |
| Exercise Timer | Runs a countdown and marks an exercise as completed |

## Project Structure

```text
FitLife/
├── FitLifeApp.swift
├── OnboardingView.swift
├── SplashView.swift
├── WorkoutDaysView.swift
├── AddWorkoutDayView.swift
├── EditWorkoutDayView.swift
├── ExercisesView.swift
├── AddExerciseView.swift
├── EditExerciseView.swift
├── ExerciseTimerView.swift
├── WorkoutStore.swift
├── Exercise.swift
└── FitLifeBackground.swift
```

### Important Files

- `FitLifeApp.swift`  
  The app entry point. It decides whether the user sees onboarding or the workout planner.

- `WorkoutStore.swift`  
  Manages workout plans and exercises. It handles creating, updating, deleting, duplicating, saving, and loading workout data.

- `Exercise.swift`  
  Defines the `Exercise` and `WorkoutDay` data models.

- `WorkoutDaysView.swift`  
  Displays workout plans and gives users actions to add, edit, duplicate, delete, or open a plan.

- `ExercisesView.swift`  
  Displays the exercises for a selected workout plan.

- `ExerciseTimerView.swift`  
  Provides the countdown timer and records exercise completion.

## Technologies Used

- Swift
- SwiftUI
- Combine
- UserDefaults
- SF Symbols
- Xcode

## How to Run the Project

1. Clone this repository:

   ```bash
   git clone https://github.com/rajamyaqoob/FitLife.git
   ```

2. Open the project in Xcode.

3. Select an iPhone Simulator or a connected iPhone.

4. Press **Run** or use:

   ```text
   Command + R
   ```

## Current Limitations

FitLife currently stores data only on the device. It does not yet include:

- User authentication
- Cloud sync
- HealthKit integration
- Workout history dashboard
- Progress charts
- Calorie or diet planning
- Push notifications
- Multi-language support

## Future Improvements

Possible future improvements include:

- Apple Health / HealthKit integration
- Daily workout reminders and notifications
- Step-count tracking
- Workout completion history
- Progress charts for weight and strength
- Calories, BMI, and diet planning
- Cloud backup and account sync
- English and Italian localization
- Dark mode support

## License

This project is currently for educational and personal development purposes.