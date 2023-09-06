//
//  ScreenTime_BarebonesApp.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/07.
//

import SwiftUI

@main
struct ScreenTime_BarebonesApp: App {
    @StateObject var familyControlsManager = FamilyControlsManager.shared
    @StateObject var scheduleVM = ScheduleVM()
    var body: some Scene {
        WindowGroup {
            VStack {
                if !familyControlsManager.hasScreenTimePermission {
                    PermissionView()
                } else {
                    ContentView()
                }
            }
            .onReceive(familyControlsManager.authorizationCenter.$authorizationStatus) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    familyControlsManager.updateAuthorizationStatus(authStatus: newValue)
                }
            }
            .environmentObject(familyControlsManager)
            .environmentObject(scheduleVM)
        }
    }
}
