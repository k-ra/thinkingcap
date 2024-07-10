//
//  ContentView.swift
//  trying
//
//  Created by kyra on 7/5/24.
import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @State private var showingCloset = false
    @State private var showingMenu = false
    @State private var showingLog = false
    @State private var isWearing = false
    @State private var elapsed = 0
    @State private var timer: Timer?
    
    var body: some View {
        if appState.isFirstLaunch {
            InitialSetupView(appState: appState)
        } else {
            mainView
        }
    }
    
    var mainView: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(appState.currentActivity)
                    .padding().bold()
                
                Image(appState.selectedHats[appState.currentActivity] ?? "defaultHat").resizable().scaledToFit().frame(height: 60)
                
                Image("cutie").resizable().scaledToFit().frame(height: 160)
                
                Spacer()
                
                Button(action: {
                    self.isWearing.toggle()
                    if self.isWearing {
                        self.startTimer()
                    } else {
                        self.stopTimer()
                    }
                }) {
                    Text(isWearing ? "take off" : "put on!")
                        .padding(5)
                        .foregroundColor(.black)
                        .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            
                Spacer()
                
                if isWearing {
                    Text(timeString(time: elapsed))
                        .padding()
                } else {
                    Text("00:00").padding().hidden()
                }
                Button(action: { showingMenu = true }) {
                    Text("change activity").italic()
                }
            }
            
            .navigationBarItems(
                leading:Button(action: {showingLog = true}) {
                        Image(systemName: "list.clipboard")
                    },
                trailing: Button(action: {
                    showingCloset = true
                }) {
                    Image(systemName: "hanger")
                }
            )
            
            .sheet(isPresented: $showingCloset) {
                ClosetView(appState: appState)
            }
            .sheet(isPresented: $showingMenu) {
                MenuView2(appState: appState, showingMenu: $showingMenu)
            }
            .sheet(isPresented: $showingLog) {
                LogView(appState: appState)
            }
    
            
        }
        .font(.custom("EB Garamond", size: 20))
    }
    
    //increment by seconds
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.elapsed += 1
            appState.logTime(activity: appState.currentActivity, seconds: 1)
        }
    }
    // shut down timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        elapsed = 0
    }
    
    func timeString(time: Int) -> String {
        let hours = time / 3600
        let minutes = (time % 3600) / 60
        let seconds = time % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


struct MenuView2: View {
    @ObservedObject var appState: AppState
    @Binding var showingMenu: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(appState.activities, id: \.self) { activity in
                    Button(action: {
                        appState.currentActivity = activity
                        showingMenu = false
                    })
                    {Text(activity).foregroundColor((appState.currentActivity == activity) ? .green : .black)}
                }
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .listStyle(PlainListStyle())
            .navigationBarItems(trailing: Button("Close") {
                showingMenu = false
            }
            )
        }
    }
}

struct MenuView: View {
    @ObservedObject var appState: AppState
    @Binding var showingMenu: Bool
    @State private var showingDailyLog = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(appState.activities, id: \.self) { activity in
                    Button(action: {
                        appState.currentActivity = activity
                        showingMenu = false
                    }) {
                        Text(activity)
                    }
                }
                
                Button(action: {
                    showingDailyLog = true
                }) {
                    Text("Daily Log")
                }
            }
            .navigationTitle("Menu")
            .navigationBarItems(trailing: Button("Close") {
                showingMenu = false
            })
        }
        .sheet(isPresented: $showingDailyLog) {
            LogView(appState: appState)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
