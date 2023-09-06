# ScreenTime_Barebones

### 프로젝트 소개

- Apple의 Screen Time(스크린 타임)을 활용해 보는 데에 도움을 주는 Bare-bones 프로젝트입니다.
- **FamilyControls, DeviceActivity, ManagedSettings 3개의 프레임워크를 활용하여 기본적인 Screen Time 기능을 구현**해 봅니다.
- 사용을 제한할 앱과 원하는 시간대를 선택하면 제한을 적용해주는 앱을 구현합니다.

### Screen Time이란?

앱과 웹사이트를 얼마나 자주 사용하는지 추적하고, 사용을 제한하도록 하여 휴대폰 사용을 관리할 수 있도록 해주는 Apple의 서비스입니다.

사용량 추적과 사용 제한의 대상은 사용자 개인이 될 수도 있고, iCloud에 연동되어 있는 자녀가 될 수도 있습니다.

FamilyControls, DeviceActivity, ManagedSettings 3가지의 프레임워크를 같이 활용하여 Screen Time 관련 기능을 개발할 수 있습니다.

- **[FamilyControls](https://developer.apple.com/documentation/familycontrols)** : ManagedSettings와 DeviceActivity에 대한 접근을 허용해주며 스크린 타임 기능을 사용할 수 있도록 해주는 프레임워크
- **[DeviceActivity](https://developer.apple.com/documentation/deviceactivity)** : 앱에서 직접적인 실행을 따로 하지 않아도 사용량을 모니터링 하며, 원하는 시점에 제한 관련 동작을 수행할 수 있도록 해주는 프레임워크
- **[ManagedSettings](https://developer.apple.com/documentation/managedsettings)** : 실질적으로 앱 사용 제한을 수행해주는 프레임워크

### 프로젝트 구조

```swift
.
├── ScreenTime_Barebones // 프로젝트의 메인 타겟입니다.
│   ├── App
│   │   ├── ContentView.swift
│   │   ├── ScreenTime_BarebonesApp.swift
│   │   └── XCConfig
│   │       └── shared.xcconfig
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   ├── AppIcon_box.png
│   │   │   └── Contents.json
│   │   ├── AppSymbol.imageset
│   │   │   ├── AppIcon.png
│   │   │   └── Contents.json
│   │   └── Contents.json
│   ├── Extension
│   │   ├── Bundle+Extension.swift
│   │   └── Color+Extension.swift
│   ├── Presentation 
│   │   ├── ViewModels
│   │   │   ├── Components
│   │   │   │   └── MainTabVM.swift
│   │   │   ├── PermissionVM.swift
│   │   │   └── ScheduleVM.swift // 스크린타임을 통해 사용시간을 트래킹하는 스케쥴을 관리하기 위한 ViewModel 
│   │   └── Views
│   │       ├── Components
│   │       │   └── MainTabView.swift
│   │       ├── MonitoringView
│   │       │   └── MonitoringView.swift
│   │       ├── PermissionView
│   │       │   └── PermissionView.swift
│   │       └── ScheduleView
│   │           └── ScheduleView.swift
│   ├── Preview Content
│   │   └── Preview Assets.xcassets
│   │       └── Contents.json
│   ├── ScreenTime_Barebones.entitlements
│   └── Utils
│       ├── DeviceActivtyManager.swift
│       └── FamilyControlsManager.swift
├── DeviceActivityMonitor // 생성한 스크린타임 스케쥴에 기반한 이벤트 발생 시 호출되는 메서드를 관리하기 위한 타겟
│   ├── DeviceActivityMonitor.entitlements
│   ├── DeviceActivityMonitorExtension.swift
│   └── Info.plist
├── ScreenTimeReport // 스크린타임을 통해 사용내역을 조회하고 관리하기 위한 타겟
│   ├── Info.plist
│   ├── ScreenTimeActivityReport.swift
│   ├── ScreenTimeReport.entitlements
│   ├── ScreenTimeReport.swift
│   ├── TotalActivityReport.swift
│   └── TotalActivityView.swift
├── ShieldAction // 스크린타임을 통해 앱 사용이 제한된 화면에서의 이벤트 발생 시 호출되는 메서드를 관리하기 위한 타겟
│   ├── Info.plist
│   ├── ShieldAction.entitlements
│   └── ShieldActionExtension.swift
└── ShieldConfiguration // 스크린타임을 통해 앱 사용이 제한된 화면을 커스텀할 수 있게 도와주는 타겟
    ├── AppSymbol.png
    ├── Info.plist
    ├── ShieldConfiguration.entitlements
    └── ShieldConfigurationExtension.swift
```

### 핵심 코드

**✅ 스크린타임 사용권한 요청하기**

- 스크린타임 API는 사용자가 직접 권한 설정을 완료한 이후부터 사용가능합니다.

```swift
// ./ScreenTime_Barebones/Utils/FamilyControlsManager.swift

import FamilyControls

class FamilyControlsManager: ObservableObject {
	// MARK: - FamilyControls 권한 상태를 관리하는 객체
    let authorizationCenter = AuthorizationCenter.shared
    
    // MARK: - ScreenTime 권한 상태를 활용하기 위한 멤버 변수
    @Published var hasScreenTimePermission: Bool = false

	@MainActor
    func requestAuthorization() {
        if authorizationCenter.authorizationStatus == .approved {
            print("ScreenTime Permission approved")
        } else {
            Task {
                do {
                    try await authorizationCenter.requestAuthorization(for: .individual)
                    hasScreenTimePermission = true
                    // 동의함
                } catch {
                    // 동의 X
                    print("Failed to enroll Aniyah with error: \(error)")
                    hasScreenTimePermission = false
                    // 사용자가 허용안함.
                    // Error Domain=FamilyControls.FamilyControlsError Code=5 "(null)
                }
            }
        }
    }
}
```

**✅ 스크린타임 스케쥴 생성하기**

- 특정 시간 동안 앱 사용을 확인할 수 있는 스케쥴을 생성할 수 있습니다.

```swift
// ./ScreenTime_Barebones/Utils/DeviceActivityManager.swift

class DeviceActivityManager: ObservableObject {

	/// DeviceActivityCenter는 설정한 스케줄에 대한 모니터링을 제어해주는 클래스입니다.
    /// 모니터링 시작 및 중단 등의 동작 처리를 위해 인스턴스를 생성해줍니다.
    let deviceActivityCenter = DeviceActivityCenter()

	func handleStartDeviceActivityMonitoring(
        startTime: DateComponents,
        endTime: DateComponents,
        deviceActivityName: DeviceActivityName = .daily,
        warningTime: DateComponents = DateComponents(minute: 5)
    ) {
        let schedule: DeviceActivitySchedule
        
        if deviceActivityName == .daily {
            schedule = DeviceActivitySchedule(
                intervalStart: startTime,
                intervalEnd: endTime,
                repeats: true,
                warningTime: warningTime
            )
            
            do {
                /// deviceActivityName 인자로 받은 이름의 Device Activity에 대해 schedule로 입력받은 기간의 모니터링을 시작합니다.
                try deviceActivityCenter.startMonitoring(deviceActivityName, during: schedule)
                /// 디버깅용 주석입니다.
                /// 현재 모니터링중인 DeviceActivityName과 스케줄을 확인할 수 있습니다.
//                print("모니터링 시작 --> \(deviceActivityCenter.activities.description)")
//                print("스케줄 --> \(schedule)")
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
}

// MARK: - Schedule Name List
extension DeviceActivityName {
    static let daily = Self("daily")
}

// MARK: - MAnagedSettingsStore List
extension ManagedSettingsStore.Name {
    static let daily = Self("daily")
}

```

**✅ 스크린타임 스케쥴 이벤트 발생 시 앱 사용 제한하기**

- 스케쥴이 실행되는 동안 발생하는 이벤트를 활용해 앱 사용을 제한할 수 있습니다.

```swift
// ./DeviceActivityMonitor/DeviceActivityMonitorExtension.swift

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
	let store = ManagedSettingsStore(named: .daily)
    let vm = ScheduleVM()

	// MARK: - 스케줄의 시작 시점 이후 처음으로 기기가 사용될 때 호출되는 메서드
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
        // FamilyActivityPicker로 선택한 앱들에 실드(제한) 적용
        let appTokens = vm.selection.applicationTokens
        let categoryTokens = vm.selection.categoryTokens
        
        if appTokens.isEmpty {
            store.shield.applications = nil
        } else {
            store.shield.applications = appTokens
        }
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(categoryTokens)
    }
    
    // MARK: - 스케줄의 종료 시점 이후 처음으로 기기가 사용될 때 or 모니터링 중단 시에 호출되는 메서드
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        // 해당 store에 대해 적용되던 모든 실드 해제
        store.clearAllSettings()
    }
}
```

**✅ 스케쥴 동안 사용이 제한된 앱에서 보여지는 화면 커스텀하기**

- 사용이 제한된 앱을 실행할 경우 스크린타임이 Shield View를 해당 앱에 덧씌워 앱 사용을 제한합니다.

- Shield View는 제한된 몇 가지 항목에 대해 커스텀이 가능합니다.

```swift
// ./ShieldConfiguration/ShieldConfigurationExtension.swift

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
		private func setShieldConfig(
        _ tokenName: String,
        hasSecondaryButton: Bool = false) -> ShieldConfiguration {
            let CUSTOM_ICON = UIImage(named: "AppSymbol.png")
        let CUSTOM_TITLE = ShieldConfiguration.Label(
            text: "Screen Time 101",
            color: ColorManager.accentColor
        )
        let CUSTOM_SUBTITLE = ShieldConfiguration.Label(
            text: "\(tokenName)은(는) 사용이 제한되었습니다.",
            color: .black
        )
        let CUSTOM_PRIMARY_BUTTON_LABEL = ShieldConfiguration.Label(
            text: "종료하기",
            color: .white
        )
        let CUSTOM_PRIAMRY_BUTTON_BACKGROUND: UIColor = ColorManager.accentColor
        let CUSTOM_SECONDARY_BUTTON_LABEL = ShieldConfiguration.Label(
            text: "눌러도 효과없음",
            color: ColorManager.accentColor
        )
        
        let ONE_BUTTON_SHIELD_CONFIG = ShieldConfiguration(
            backgroundBlurStyle: .systemChromeMaterialLight,
            backgroundColor: .white,
            icon: CUSTOM_ICON,
            title: CUSTOM_TITLE,
            subtitle: CUSTOM_SUBTITLE,
            primaryButtonLabel: CUSTOM_PRIMARY_BUTTON_LABEL,
            primaryButtonBackgroundColor: CUSTOM_PRIAMRY_BUTTON_BACKGROUND
        )
        
        let TWO_BUTTON_SHIELD_CONFIG = ShieldConfiguration(
            backgroundBlurStyle: .systemChromeMaterialLight,
            backgroundColor: .white,
            icon: CUSTOM_ICON,
            title: CUSTOM_TITLE,
            subtitle: CUSTOM_SUBTITLE,
            primaryButtonLabel: CUSTOM_PRIMARY_BUTTON_LABEL,
            primaryButtonBackgroundColor: CUSTOM_PRIAMRY_BUTTON_BACKGROUND,
            secondaryButtonLabel: CUSTOM_SECONDARY_BUTTON_LABEL
        )
        
        return hasSecondaryButton ? TWO_BUTTON_SHIELD_CONFIG : ONE_BUTTON_SHIELD_CONFIG
    }

	// MARK: - 어플리케이션만 제한된 앱
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        guard let displayName = application.localizedDisplayName else {
            return setShieldConfig("확인불가 앱")
        }
        return setShieldConfig(displayName)
    }
}
```

**✅ 스크린 타임 활동 조회하기**

- Device Activity Report Extension을 추가하여 스크린 타임 활동 내용을 모니터링 할 수 있습니다.

```swift
// ./ScreenTimeReport/ScreenTimeReport.swift

import DeviceActivity
import SwiftUI

@main
struct ScreenTimeReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(activityReport: totalActivity)
        }
        // Add more reports here...
    }
}
```

```swift
// ./ScreenTimeReport/TotalActivityReport.swift

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
```





```swift
// ./ScreenTimeReport/TotalActivityReport.swift

import DeviceActivity

extension DeviceActivityReport.Context {
		static let totalActivity = Self("Total Activity")
}

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
```

```swift
// ./ScreenTimeReport/TotalActivityView.swift

import SwiftUI
import FamilyControls

// MARK: - MonitoringView에서 보여줄 SwiftUI 뷰
struct TotalActivityView: View {
    var activityReport: ActivityReport
    
    var body: some View {

        ...

        /// Report View를 원하는 대로 구성합니다.

        ...

    }
}
```

### 참고자료

**📼 Apple Developer** **Videos**

[Meet the Screen Time API - WWDC21 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2021/10123/)

[What's new in Screen Time API - WWDC22 - Videos - Apple Developer](https://developer.apple.com/videos/play/wwdc2022/110336/)

**🛠️ 삽질기록**

[Screen Time API](https://www.notion.so/Screen-Time-API-c76cf8289958418a90d14e6ffd298e14?pvs=21)

**📚 WWDC 영상 정리**

[Screen Time 관련 WWDC 영상을 보고 정리한 내용](https://healthy-degree-cc2.notion.site/Screen-Time-837e1ccfd14949eb9f441202b670d61b?pvs=4)
