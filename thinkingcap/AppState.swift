//
//  AppState.swift
//  thinkingcap
//
//  Created by kyra on 7/9/24.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    
    @Published var isFirstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(!isFirstLaunch, forKey: "hasLaunchedBefore")
        }
    }
    @Published var selectedHats: [String: String] {
        didSet {
            if let encoded = try? JSONEncoder().encode(selectedHats) {
                UserDefaults.standard.set(encoded, forKey: "selectedHats")
            }
        }
    }
    @Published var selectedCharacter: String {
           didSet {
               UserDefaults.standard.set(selectedCharacter, forKey: "selectedCharacter")
           }
       }
    @Published var currentActivity: String {
        didSet {
            UserDefaults.standard.set(currentActivity, forKey: "currentActivity")
        }
    }
    @Published var dailyLog: [String: [String: Int]] {
        didSet {
            if let encoded = try? JSONEncoder().encode(dailyLog) {
                UserDefaults.standard.set(encoded, forKey: "dailyLog")
            }
        }
    }
    
    let activities = ["thinking", "reading", "working", "creating"]
    let allHats = ["hat1", "hat2", "hat3", "hat4", "hat5", "hat6", "hat7","hat8","hat9","hat10","hat11", "hat12","hat13"]
    let allCharacters = ["cutie", "cutie2", "cutie3", "cutie4"]
    
    init() {
        self.isFirstLaunch = !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
//        self.isFirstLaunch = true //for testing
        if let savedHats = UserDefaults.standard.object(forKey: "selectedHats") as? Data,
           let decodedHats = try? JSONDecoder().decode([String: String].self, from: savedHats) {
            self.selectedHats = decodedHats
        } else {
            self.selectedHats = [:]
        }
        self.currentActivity = UserDefaults.standard.string(forKey: "currentActivity") ?? "thinking"
        if let savedLog = UserDefaults.standard.object(forKey: "dailyLog") as? Data,
           let decodedLog = try? JSONDecoder().decode([String: [String: Int]].self, from: savedLog) {
            self.dailyLog = decodedLog
        } else {
            self.dailyLog = [:]
        }
        self.selectedCharacter = UserDefaults.standard.string(forKey: "selectedCharacter") ?? "defaultCharacter"


    }
    
    func logTime(activity: String, seconds: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        
        if dailyLog[dateString] == nil {
            dailyLog[dateString] = [:]
        }
        
        if dailyLog[dateString]![activity] == nil {
            dailyLog[dateString]![activity] = 0
        }
        
        dailyLog[dateString]![activity]! += seconds
    }
}
