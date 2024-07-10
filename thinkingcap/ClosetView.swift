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
        VStack{
            Text("my current closet")
                .font(.custom("EB Garamond", size:25)).bold()
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
                .listStyle(PlainListStyle())
                .navigationBarItems(trailing: Button("done") {
                    presentationMode.wrappedValue.dismiss()
                })
                .sheet(isPresented: $showingHatPicker, content: {
                    HatPickerView(appState: appState, activity: selectedActivity ?? "")
                })
            }
        }
    }
}
