//
//  HatPickerView.swift
//  thinkingcap
//
//  Created by kyra on 7/9/24.
//

import Foundation
import SwiftUI

struct HatPickerView: View {
    @ObservedObject var appState: AppState
    let activity: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Spacer()
        Text("choose a new hat!!")
            .font(.custom("EB Garamond", size: 20))
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(appState.allHats, id: \.self) { hat in
                        Image(hat)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .onTapGesture {
                                appState.selectedHats[activity] = hat
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
