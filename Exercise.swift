//
//  Exercise.swift
//  FitLife
//
//  Created by Jacob on 23/06/2026.
//


import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var sets: Int
    var repetitions: Int
    var weight: Int
    var time: Int
    var lastCompletedAt: Date?

}

struct WorkoutDay: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var icon: String
    var exercises: [Exercise]
}
