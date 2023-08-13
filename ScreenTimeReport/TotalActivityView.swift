//
//  TotalActivityView.swift
//  ScreenTimeReport
//
//  Created by 김영빈 on 2023/08/09.
//

import SwiftUI

// MARK: - MonitoringView에서 보여줄 SwiftUI 뷰
struct TotalActivityView: View {
    var activityReport: ActivityReport
    
    var body: some View {
        VStack {
            Spacer(minLength: 50)
            Text("Total Screen Time")
            Spacer(minLength: 10)
            Text(activityReport.totalDuration.toString())
            List {
                HStack {
                    Text("앱")
                    Spacer()
                    Text("앱ID")
                    Spacer()
                    Text("클릭 횟수")
                    Spacer()
                    Text("모니터링 시간")
                }
                
                ForEach(activityReport.apps) { eachApp in
                    ListRow(eachApp: eachApp)
                }
            }
        }
    }
}

struct ListRow: View {
    var eachApp: AppDeviceActivity
    
    var body: some View {
        HStack {
            Text(eachApp.displayName)
            Spacer()
            Text(eachApp.id)
            Spacer()
            Text("\(eachApp.numberOfPickups)")
            Spacer()
            Text(String(eachApp.duration.formatted()))
        }
    }
}

// In order to support previews for your extension's custom views, make sure its source files are
// members of your app's Xcode target as well as members of your extension's target. You can use
// Xcode's File Inspector to modify a file's Target Membership.
struct TotalActivityView_Previews: PreviewProvider {
    static var previews: some View {
        TotalActivityView(
            activityReport: ActivityReport(
                totalDuration: .zero,
                apps: [
                    AppDeviceActivity(id: "id1", displayName: "app1", duration: .zero, numberOfPickups: 3),
                    AppDeviceActivity(id: "id2", displayName: "app2", duration: .zero, numberOfPickups: 5)
                ]
            )
        )
    }
}
