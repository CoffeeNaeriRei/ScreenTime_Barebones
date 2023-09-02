//
//  TotalActivityReport.swift
//  ScreenTimeReport
//
//  Created by 김영빈 on 2023/08/09.
//

import DeviceActivity
import SwiftUI

// MARK: - 각각의 Device Activity Report들에 대응하는 컨텍스트 정의
extension DeviceActivityReport.Context {
    // If your app initializes a DeviceActivityReport with this context, then the system will use
    // your extension's corresponding DeviceActivityReportScene to render the contents of the
    // report.
    /// 해당 리포트의 내용 렌더링에 사용할 DeviceActivityReportScene에 대응하는 익스텐션이 필요합니다.  ex) TotalActivityReport
    static let totalActivity = Self("Total Activity")
}

// MARK: - Device Activity Report의 내용을 어떻게 구성할 지 설정
struct TotalActivityReport: DeviceActivityReportScene {
    // Define which context your scene will represent.
    /// 보여줄 리포트에 대한 컨텍스트를 정의해줍니다.
    let context: DeviceActivityReport.Context = .totalActivity
    
    // Define the custom configuration and the resulting view for this report.
    /// 어떤 데이터를 사용해서 어떤 뷰를 보여줄 지 정의해줍니다. (SwiftUI View)
    let content: (ActivityReport) -> TotalActivityView
    
    /// DeviceActivityResults 데이터를 받아서 필터링
    func makeConfiguration(
        representing data: DeviceActivityResults<DeviceActivityData>) async -> ActivityReport {
        // Reformat the data into a configuration that can be used to create
        // the report's view.
        var totalActivityDuration: Double = 0 /// 총 스크린 타임 시간
        var list: [AppDeviceActivity] = [] /// 사용 앱 리스트
        
        /// DeviceActivityResults 데이터에서 화면에 보여주기 위해 필요한 내용을 추출해줍니다.
        for await eachData in data {
            /// 특정 시간 간격 동안 사용자의 활동
            for await activitySegment in eachData.activitySegments {
                /// 활동 세그먼트 동안 사용자의 카테고리 별 Device Activity
                for await categoryActivity in activitySegment.categories {
                    /// 이 카테고리의 totalActivityDuration에 기여한 사용자의 application Activity
                    for await applicationActivity in categoryActivity.applications {
                        let appName = (applicationActivity.application.localizedDisplayName ?? "nil") /// 앱 이름
                        let bundle = (applicationActivity.application.bundleIdentifier ?? "nil") /// 앱 번들id
                        let duration = applicationActivity.totalActivityDuration /// 앱의 total activity 기간
                        totalActivityDuration += duration
                        let numberOfPickups = applicationActivity.numberOfPickups /// 앱에 대해 직접적인 pickup 횟수
                        let token = applicationActivity.application.token /// 앱의 토큰
                        let appActivity = AppDeviceActivity(
                            id: bundle,
                            displayName: appName,
                            duration: duration,
                            numberOfPickups: numberOfPickups,
                            token: token
                        )
                        list.append(appActivity)
                    }
                }

            }
        }
        
        /// 필터링된 ActivityReport 데이터들을 반환
        return ActivityReport(totalDuration: totalActivityDuration, apps: list)
    }
}
