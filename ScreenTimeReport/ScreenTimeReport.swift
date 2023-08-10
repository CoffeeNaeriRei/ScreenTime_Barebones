//
//  ScreenTimeReport.swift
//  ScreenTimeReport
//
//  Created by 김영빈 on 2023/08/09.
//

import DeviceActivity
import SwiftUI

@main
struct ScreenTimeReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
