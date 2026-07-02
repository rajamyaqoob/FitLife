//
//  SplashView.swift
//  FitLife
//
//  Created by Jacob on 23/06/2026.
//


import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var animate = false

    var body: some View {
        Group {
            if isActive {
                WorkoutDaysView()
            } else {
                ZStack {
                    FitLifeBackground()

                    VStack(spacing: 20) {
                        Image("ICONA")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                                .cornerRadius(30)
                        .scaleEffect(animate ? 1 : 0.65)
                        .opacity(animate ? 1 : 0)

                        VStack(spacing: 8) {
                            Text("FitLife")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundStyle(.black)

                            Text("Train smarter. Feel stronger.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        .opacity(animate ? 1 : 0)

                        ProgressView()
                            .tint(.teal)
                            .padding(.top, 18)
                            .opacity(animate ? 1 : 0)
                    }
                }
                .onAppear {
                    withAnimation(.spring(response: 0.75, dampingFraction: 0.72)) {
                        animate = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            isActive = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(WorkoutStore())
}
