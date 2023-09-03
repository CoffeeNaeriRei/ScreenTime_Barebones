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
                Section {
                    ForEach(activityReport.apps) { eachApp in
                        ListRow(eachApp: eachApp)
                    }
                } footer: {
                    /**
                     Pickup에 대한 참고 아티클
                     - 자료들을 조사해보면 Pickup은 단순 화면을 켠 횟수로 계산되는 것이 아니라, Apple에서 설정한 특정 기준의 상호작용이 이루어졌을 때 카운트가 된다고 합니다.
                     - 그렇기 때문에 앱 모니터링 시간이 계산되어도 화면 깨우기 횟수는 카운트되지 않는 경우도 많이 확인할 수 있습니다.
                     https://www.imobie.com/support/what-are-pickups-in-screen-time.htm#q1
                     https://www.theverge.com/2018/9/17/17870126/ios-12-screen-time-app-limits-downtime-features-how-to-use
                     */
                    Text(
                    """
                    [화면 깨우기]는 해당 앱을 사용하기 위해 어두운 상태의 화면을 켠 횟수를 의미합니다.
                    👉[설정]앱 → [스크린 타임] → [모든 활동 보기]에서도 화면 깨우기 횟수를 확인해볼 수 있습니다.
                    """
                    )
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
                        Text("화면 깨우기")
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
