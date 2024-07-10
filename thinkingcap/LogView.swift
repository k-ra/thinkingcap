//
//  LogView.swift
//  thinkingcap
//
//  Created by kyra on 7/9/24.
//


import Foundation
import SwiftUI

struct LogView: View {
    @ObservedObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Spacer()
        Text("daily thinking times:")
        NavigationView {
            List {
                ForEach(Array(appState.dailyLog.keys.sorted().reversed()), id: \.self) { date in
                    Section(header: Text(date)) {
                        ForEach(appState.activities, id: \.self) { activity in
                            if let time = appState.dailyLog[date]?[activity], time > 0 {
                                HStack {
                                    Text(activity).bold()
                                    Spacer()
                                    Text(timeString(seconds: time))
                                }
                            }
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(trailing: Button("close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    func timeString(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}
