//
//  ScheduleVM.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/09.
//

import Foundation
import FamilyControls
import SwiftUI

enum ScheduleSectionInfo {
    case time
    case apps
    case monitoring
    case revoke
    
    var header: String {
        switch self {
        case .time:
            return "setup Time"
        case .apps:
            return "setup Apps"
        case .monitoring:
            return "stop Schedule Monitoring"
        case .revoke:
            return "Revoke Authorization"
        }
    }
    
    var footer: String {
        switch self {
        case .time:
            return "시작 시간과 종료 시간을 설정하여 앱 사용을 제한하고자 하는\n스케쥴 시간을 설정할 수 있습니다."
        case .apps:
            return "변경하기 버튼을 눌러 선택한 시간 동안 사용을 제한하고 싶은\n앱 및 웹 도메인을 선택할 수 있습니다."
        case .monitoring:
            return "현재 모니터링 중인 스케줄의 모니터링을 중단합니다."
        case .revoke:
            return ""
        }
    }
}

class ScheduleVM: ObservableObject {
    // MARK: - 스케쥴 설정을 위한 멤버 변수
    @AppStorage("scheduleStartTime", store: UserDefaults(suiteName: Bundle.main.appGroupName))
    var scheduleStartTime = Date() // 현재 시간
    @AppStorage("scheduleEndTime", store: UserDefaults(suiteName: Bundle.main.appGroupName))
    var scheduleEndTime = Date() + 900 // 현재 시간 + 15분
    // MARK: - 사용자가 설정한 앱/도메인을 담고 있는 멤버 변수
    @AppStorage("selection", store: UserDefaults(suiteName: Bundle.main.appGroupName))
    var selection = FamilyActivitySelection()

    @Published var isFamilyActivitySectionActive = false
    @Published var isSaveAlertActive = false
    @Published var isRevokeAlertActive = false
    @Published var isStopMonitoringAlertActive = false
    
    private func resetAppGroupData() {
        scheduleStartTime = Date()
        scheduleEndTime = Date() + 900
        selection = FamilyActivitySelection()
    }
}

extension ScheduleVM {
    // MARK: - FamilyActivity Sheet 열기
    /// 호출 시 사용자가 제한하고자 하는 기기에 설치한 앱 혹은 웹 도메인을
    /// 선택할 수 있는 FamilyActivitySelection을 엽니다.
    func showFamilyActivitySelection() {
        isFamilyActivitySectionActive = true
    }
    
    // MARK: - ScreenTime API 권한 삭제 alert 열기
    /// 호출 시 권한을 제거할 수 있는 alert을 열어 앱 사용을 위해
    /// 부여했던 ScreenTIme API 권한을 제거할 수 있습니다.
    func showRevokeAlert() {
        isRevokeAlertActive = true
    }
    
    // TODO: - ScheduleView의 tempSelection으로 확인하도록 바꿔서 ScheduleView로 위치를 옮겼습니다. (확인 후 삭제)
//    /// 사용자가 선택한 앱 & 도메인 토큰이 비어있는지 확인하기 위한 메서드입니다.
//    func isSelectionEmpty() -> Bool {
//        selection.applicationTokens.isEmpty &&
//        selection.categoryTokens.isEmpty &&
//        selection.webDomainTokens.isEmpty
//    }
    
    // MARK: - 스케쥴 저장
    /// 설정한 시간 DeviceActivityManager를 통해 전달하여 설정한 시간을 모니터링할 수 있습니다.
    /// 모니터링을 등록하면 DeviceActivityMonitorExtension를 활용해 특정 시점의 이벤트를 감지할 수 있습니다.
    func saveSchedule(selectedApps: FamilyActivitySelection) {
        selection = selectedApps
        
        let startTime = Calendar.current.dateComponents([.hour, .minute], from: scheduleStartTime)
        let endTime = Calendar.current.dateComponents([.hour, .minute], from: scheduleEndTime)
        
        DeviceActivityManager.shared.handleStartDeviceActivityMonitoring(
            startTime: startTime,
            endTime: endTime
        )
        
        isSaveAlertActive = true
    }
    
    // MARK: - 스케줄 모니터링 중단
    /// 현재 모니터링 중이던 스케줄의 모니터링을 중단합니다.
    func stopScheduleMonitoring() {
        DeviceActivityManager.shared.handleStopDeviceActivityMonitoring()
        resetAppGroupData()
    }
    
    // MARK: - 스케줄 모니터링 중단 alert 열기
    /// 호출 시 모니터링을 중단할 수 있는 alert을 열어
    /// 현재 모니터링 중인 스케줄의 모니터링을 중단할 수 있습니다.
    func showStopMonitoringAlert() {
        isStopMonitoringAlertActive = true
    }
}

// MARK: - FamilyActivitySelection Parser
extension FamilyActivitySelection: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
// MARK: - Date Parser
extension Date: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode(Date.self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
