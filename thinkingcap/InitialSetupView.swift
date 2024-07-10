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
    @State private var isChoosingCharacter = true
    @State private var currentActivityIndex = 0
    
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        VStack {
            if isChoosingCharacter {
                characterSelectionView
            } else if currentActivityIndex < appState.activities.count {
                hatSelectionView
            } 
        }.font(.custom("EB Garamond", size: 20))
    }
    
    var characterSelectionView: some View {
        VStack {
            
            Text("welcome!!")
                .padding()

            Text("who are you? who will you be?")
                .padding()
                
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(appState.allCharacters, id: \.self) { character in
                        Image(character)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .onTapGesture {
                                appState.selectedCharacter = character
                                isChoosingCharacter = false
                            }
                    }
                }
                .padding()
            }
            
            Text("-->")
                .padding()
        }
    }
    
    var hatSelectionView: some View {
        VStack {
            Spacer()
            Text("choose your ") +
            Text(appState.activities[currentActivityIndex])
                .fontWeight(.bold) +
            Text(" cap")
            
            Spacer()
            ScrollView {
                LazyVGrid(columns:[GridItem(.adaptive(minimum: 100))]) {
                    ForEach(appState.allHats, id: \.self) { hat in
                        Image(hat)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .onTapGesture {
                                appState.selectedHats[appState.activities[currentActivityIndex]] = hat
                                moveToNextActivity()
                            }
                    }
                }
                .padding()
                .font(.custom("EB Garamond", size: 20))
            }
        }
    }
    
    private func moveToNextActivity() {
            currentActivityIndex += 1
            if currentActivityIndex >= appState.activities.count {
                // All activities completed, automatically finish setup
                appState.isFirstLaunch = false
            }
        }
}
