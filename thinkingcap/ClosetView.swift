//
//  ClosetView.swift
//  thinkingcap
//
//  Created by kyra on 7/9/24.
//

import Foundation
import SwiftUI

struct ClosetView: View {
    @ObservedObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedActivity: String?
    @State private var showingHatPicker = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(appState.activities, id: \.self) { activity in
                    HStack {
                        Text(activity)
                        Spacer()
                        Image(appState.selectedHats[activity] ?? "defaultHat")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 50)
                    }
                    .onTapGesture {
                        selectedActivity = activity
                        showingHatPicker = true
                    }
                }
            }
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingHatPicker, content: {
                HatPickerView(appState: appState, activity: selectedActivity ?? "")
            })
        }
    }
}
