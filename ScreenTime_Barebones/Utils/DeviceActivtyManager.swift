//
//  DeviceActivtyManager.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/09.
//

import Foundation
import DeviceActivity

class DeviceActivityManager: ObservableObject {
    static let shared = DeviceActivityManager()
    private init() {}
    
    let deviceActivityCenter = DeviceActivityCenter()
    
    func handleStartDeviceActivityMonitoring(
        startTime: DateComponents,
        endTime: DateComponents,
        deviceActivityName: DeviceActivityName = .dailySleep,
        warningTime: DateComponents = DateComponents(minute: 5) // 5분 전 알림
    ) {
        let schedule: DeviceActivitySchedule
        
        // MARK: 기본 수면계획 스케줄일 경우
        if deviceActivityName == .dailySleep {
            schedule = DeviceActivitySchedule(
                intervalStart: startTime,
                intervalEnd: endTime,
                repeats: true,
                warningTime: warningTime
            )
        } else {
            // MARK: 추가시간 15분 스케줄일 경우
            let currentDateComponents = Calendar.current.dateComponents(
                [.hour, .minute, .second],
                from: Date()
            )
            let startHour = currentDateComponents.hour ?? 0
            let startMinute  = currentDateComponents.minute ?? 0
            var endHour = startHour + 0
            
            var endMinute = startMinute + 15 // 추가 시간 설정
            if endMinute >= 60 {
                endMinute -= 60
                endHour += 1
            }
            if endHour > 23 {
                endHour = 23
                endMinute = 59
            }
            print("Additional time schedule: \(startHour):\(startMinute) ~ \(endHour):\(endMinute)")
            
            // (추가시간 종료 시점 ~ 수면 종료 시간)의 새로운 스케줄 생성하기
            schedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: endHour, minute: endMinute),
                intervalEnd: endTime,
                repeats: false,
                warningTime: warningTime // 종료 5분 전에 알림
            )
            
        }
        
        do {
            print("Stop monitoring... --> \(deviceActivityCenter.activities.description)")
            deviceActivityCenter.stopMonitoring()
            try deviceActivityCenter.startMonitoring(deviceActivityName, during: schedule)
            print("Start monitoring... --> \(deviceActivityCenter.activities.description)")
        } catch {
            print("Unexpected error: \(error).")
        }
    }
}

// MARK: - Schedule Name List
extension DeviceActivityName {
    static let dailySleep = Self("dailySleep")
    static let additionalTime = Self("additionalTime")
}
