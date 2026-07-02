//
//  OnboardingView.swift
//  FitLife
//
//  Created by Jacob on 30/06/2026.
//


import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0

    var body: some View {
        ZStack {
            FitLifeBackground()

            VStack(spacing: 28) {
                Spacer()

                TabView(selection: $currentPage) {

                    OnboardingPage(
                        logoName: "ICONA",
                        title: "Welcome to FitLife",
                        description: "Create workout plans and track your exercises in one place."
                    )
                    .tag(0)

                    OnboardingPage(
                        systemImage: "plus.circle.fill",
                        title: "Create a Workout Plan",
                        description: "Tap the plus button to create a workout day such as Push, Pull, Legs, or Cardio."
                    )
                    .tag(1)

                    OnboardingPage(
                        systemImage: "dumbbell.fill",
                        title: "Add Exercises",
                        description: "Open a workout plan and tap the plus button to add exercises, sets, reps, weight, and time."
                    )
                    .tag(2)

                    OnboardingPage(
                        systemImage: "hand.draw.fill",
                        title: "Edit or Delete Exercises",
                        description: "Swipe left on an exercise to reveal Edit and Delete options."
                    )
                    .tag(3)

                    OnboardingPage(
                        systemImage: "clock.fill",
                        title: "Start Your Timer",
                        description: "Tap the green clock button beside an exercise to start its timer."
                    )
                    .tag(4)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 430)

                Button {
                    if currentPage == 4 {
                        hasSeenOnboarding = true
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                } label: {
                    Text(currentPage == 4 ? "Get Started" : "Next")
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
                }

                Button("Skip") {
                    hasSeenOnboarding = true
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.gray)
                .opacity(currentPage == 4 ? 0 : 1)
                .disabled(currentPage == 4)

                Spacer()
                    .frame(height: 10)
            }
            .padding(.horizontal, 24)
        }
    }
}

struct OnboardingPage: View {
    var systemImage: String? = nil
    var logoName: String? = nil

    let title: String
    let description: String

    var body: some View {
        VStack(spacing: 22) {

            if let logoName {
                Image(logoName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .cornerRadius(30)
                    .shadow(
                        color: Color.blue.opacity(0.30),
                        radius: 15,
                        y: 8
                    )

            } else if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 72, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 150, height: 150)
                    .background(
                        LinearGradient(
                            colors: [.teal, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                    .shadow(
                        color: Color.blue.opacity(0.30),
                        radius: 15,
                        y: 8
                    )
            }

            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)

            Text(description)
                .font(.body)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
        }
    }
}

#Preview {
    OnboardingView()
}
