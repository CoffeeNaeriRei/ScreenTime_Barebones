//
//  DeviceActivtyManager.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/09.
//

import Foundation
import DeviceActivity
import ManagedSettings

// MARK: - 모니터링 관련 동작을 제어하는 클래스
class DeviceActivityManager: ObservableObject {
    static let shared = DeviceActivityManager()
    private init() {}
    
    /// DeviceActivityCenter는 설정한 스케줄에 대한 모니터링을 제어해주는 클래스입니다.
    /// 모니터링 시작 및 중단 등의 동작 처리를 위해 인스턴스를 생성해줍니다.
    let deviceActivityCenter = DeviceActivityCenter()
    
    // MARK: - Device Activity 활동 모니터링을 시작하는 메서드
    func handleStartDeviceActivityMonitoring(
        startTime: DateComponents,
        endTime: DateComponents,
        deviceActivityName: DeviceActivityName = .daily,
        warningTime: DateComponents = DateComponents(minute: 5) // TODO: - 알림 뺄 지 말 지 합의
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
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
    
    // MARK: - Device Activity 활동 모니터링을 중단하는 메서드
    func handleStopDeviceActivityMonitoring() {
        /// 모든 모니터링을 중단합니다.
        deviceActivityCenter.stopMonitoring()
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
