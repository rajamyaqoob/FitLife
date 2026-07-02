//
//  FitLifeBackground 2.swift
//  FitLife
//
//  Created by Jacob on 25/06/2026.
//


import SwiftUI

struct FitLifeBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.94, green: 0.985, blue: 1.0),
                    Color(red: 0.88, green: 0.97, blue: 1.0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color.cyan.opacity(0.15))
                .frame(width: 260, height: 260)
                .blur(radius: 22)
                .offset(x: 140, y: -310)

            Circle()
                .fill(Color.teal.opacity(0.12))
                .frame(width: 210, height: 210)
                .blur(radius: 20)
                .offset(x: -145, y: 310)

            Circle()
                .fill(Color.blue.opacity(0.09))
                .frame(width: 130, height: 130)
                .blur(radius: 15)
                .offset(x: 145, y: 120)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    FitLifeBackground()
}
