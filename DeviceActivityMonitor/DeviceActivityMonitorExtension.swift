//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import DeviceActivity
import ManagedSettings
import SwiftUI

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore(named: .daily)
    @StateObject var scheduleVM = ScheduleVM()
    
    // MARK: - 스케줄의 시작 시점 이후 처음으로 기기가 사용될 때 호출되는 메서드
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
        // FamilyActivityPicker로 선택한 앱들에 실드(제한) 적용
        let appTokens = scheduleVM.selection.applicationTokens
        let categoryTokens = scheduleVM.selection.categoryTokens
        
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
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(
        _ event: DeviceActivityEvent.Name,
        activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
