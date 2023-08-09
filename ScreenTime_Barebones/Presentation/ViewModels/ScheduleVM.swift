//
//  ScheduleVM.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/09.
//

import Foundation
import FamilyControls

enum ScheduleSectionInfo {
    case time
    case apps
    case revoke
    
    var header: String {
        switch self {
        case .time:
            return "setup Time"
        case .apps:
            return "setup Apps"
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
        case .revoke:
            return ""
        }
    }
}

class ScheduleVM: ObservableObject {
    @Published var times: [Date] = [Date(), Date() + 900]
    @Published var selection = FamilyActivitySelection()
    @Published var isFamilyActivitySectionActive = false
    @Published var isSaveAlertActive = false
}

extension ScheduleVM {
    func showFamilyActivitySelection() {
        isFamilyActivitySectionActive = true
    }
    
    func isSelectionEmpty() -> Bool {
        selection.applicationTokens.isEmpty &&
        selection.categoryTokens.isEmpty &&
        selection.webDomainTokens.isEmpty
    }
    
    func saveSchedule() {
        let startTime = Calendar.current.dateComponents([.hour, .minute], from: times[0])
        let endTime = Calendar.current.dateComponents([.hour, .minute], from: times[1])
        
        DeviceActivityManager.shared.handleStartDeviceActivityMonitoring(
            startTime: startTime,
            endTime: endTime
        )
        
        isSaveAlertActive = true
    }
}
