//
//  TabVM.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import Foundation
import SwiftUI

class MainTabVM: ObservableObject {
    @Published var tabIndex = 0
}

enum MainTab: CaseIterable {
    case schedule
    case report
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .schedule:
            ScheduleView()
        case .report:
            MonitoringView()
        }
    }
    
    var labelInfo: (text: String, icon: String) {
        switch self {
        case .schedule:
            return (text: "Schedule", icon: "person.badge.shield.checkmark.fill")
        case .report:
            return (text: "Report", icon: "chart.bar.xaxis")
        }
    }
}
