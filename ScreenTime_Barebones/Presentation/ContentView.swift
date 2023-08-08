//
//  ContentView.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/07.
//

import SwiftUI

struct ContentView: View {
    @State var tabIndex = 0
    
    var body: some View {
        TabView(selection: $tabIndex) {
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "tray.and.arrow.down.fill")
                }
                .tag(0)
            MonitoringView()
                .tabItem {
                    Label("Monitoring", systemImage: "tray.and.arrow.down.fill")
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
