//
//  InitialSetupView.swift
//  thinkingcap
//
//  Created by kyra on 7/9/24.
//


import Foundation

import SwiftUI

struct InitialSetupView: View {
    @ObservedObject var appState: AppState
    @State private var currentSetupStep = 0
    
    var body: some View {
        VStack {
            Text("which hat for which...")
                .padding()
            
            if currentSetupStep < appState.activities.count {
                Text("choose your \(appState.activities[currentSetupStep]) cap:")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(appState.allHats, id: \.self) { hat in
                            Image(hat)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .onTapGesture {
                                    appState.selectedHats[appState.activities[currentSetupStep]] = hat
                                    currentSetupStep += 1
                                    if currentSetupStep == appState.activities.count {
                                        appState.isFirstLaunch = false
                                    }
                                }
                        }
                    }
                }
                .frame(height: 120)
                
                Text("choose your character:")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(appState.allCharacters, id: \.self) { character in
                            Image(character)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .onTapGesture {
                                    appState.selectedCharacter = character
                                }
                        }
                    }
                }
                .frame(height: 120)
            }
        }
    }
}
