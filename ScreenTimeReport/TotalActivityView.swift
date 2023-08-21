//
//  TotalActivityView.swift
//  ScreenTimeReport
//
//  Created by 김영빈 on 2023/08/09.
//

import SwiftUI
import FamilyControls
// MARK: - MonitoringView에서 보여줄 SwiftUI 뷰
struct TotalActivityView: View {
    var activityReport: ActivityReport
    
    var body: some View {
        VStack(spacing: 4) {
            Spacer(minLength: 24)
            Text("스크린타임 총 사용 시간")
                .font(.callout)
                .foregroundColor(.secondary)
            Text(activityReport.totalDuration.toString())
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 8)
            List {
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
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                if let token = eachApp.token {
                    Label(token)
                        .labelStyle(.iconOnly)
                        .offset(x: -4)
                }
                Text(eachApp.displayName)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    HStack(spacing: 4) {
                        Text("클릭 횟수")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(width: 72, alignment: .leading)
                        Text("\(eachApp.numberOfPickups)회")
                            .font(.headline)
                            .bold()
                            .frame(minWidth: 52, alignment: .trailing)
                    }
                    HStack(spacing: 4) {
                        Text("모니터링 시간")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(width: 72, alignment: .leading)
                        Text(String(eachApp.duration.toString()))
                            .font(.headline)
                            .bold()
                            .frame(minWidth: 52, alignment: .trailing)
                    }
                }
            }
            HStack {
                Text("앱 ID")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(eachApp.id)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .bold()
                Spacer()
            }
        }
        .background(Color.white)
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
