//
//  PermissionVM.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/13.
//

import Foundation
import SwiftUI

class PermissionVM: ObservableObject {
    @Published var isViewLoaded = false
    @Published var isSheetActive = false
    
    let HEADER_ICON_LABEL = "info.circle.fill"
    
    let DECORATION_TEXT_INFO = (
        imgSrc: "AppSymbol",
        title: "Screen Time 101",
        subTitle: "Screen Time API의\n기본적인 기능을 알아봅시다."
    )
    
    let PERMISSION_BUTTON_LABEL = "시작하기"
    
    let SHEET_INFO_LIST = [
        "ScreebTime API를 활용하여 특정 시간에 앱/웹 사용을 제한하고 모니터링할 수 있습니다.",
        "더 자세한 정보는 아래 버튼을 클릭하여 연결되는 깃허브 레포를 참고해주세요.\n개선사항 및 문의는 언제든 환영합니다"
    ]
    
    let GIT_LINK_LABEL = "[깃허브 확인하기](https://github.com/CoffeeNaeriRei/ScreenTime_Barebones)"
}

extension PermissionVM {
    func handleTranslationView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.isViewLoaded = true
            }
        }
    }
    
    func showIsSheetActive() {
        isSheetActive = true
    }
    
    @MainActor
    func handleRequestAuthorization() {
        FamilyControlsManager.shared.requestAuthorization()
    }
}
