//
//  ShieldActionExtension.swift
//  ShieldAction
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import ManagedSettings

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
// MARK: - ShieldAction
/// 설정한 스케쥴 시간 중 FamilyActivitySelection으로 설정한 앱/웹 도메인 접근 시
/// 사용을 제한하는 Block View에서 버튼 클릭 시 동작을 작성할 수 있습니다.
class ShieldActionExtension: ShieldActionDelegate {
    
    // MARK: ApplicationToken으로 설정 된 앱에서 버튼 클릭 시 동작을 설정합니다.
    /// handle 메서드의 인자인 ShieldAction은 두 가지 case로 나누어집니다.
    ///  - .primaryButtonPressed : ShieldConfiguration의 primaryButtonLabel에 해당됩니다.
    ///  - .secondaryButtonPressed: ShieldConfiguration의 secondaryButtonLabel에 해당됩니다.
    /// * case를 구분하지 않거나, 사용하지 않을 경우, 모든 버튼 클릭 시 동작하도록 할 수 있습니다.
    /// * ShieldConfiguration로 설정 된 secondaryButtonLabel이 없을 경우, 해당 case를 사용할 수 없습니다.
    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void) {
            // Handle the action as needed.
            switch action {
            case .primaryButtonPressed:
                /// 시스템이 현재 어플리케이션이나 웹 브라우저를 닫도록 합니다.
                completionHandler(.close)
            case .secondaryButtonPressed:
                /// 액션에 대한 응답을 지연시키며 뷰를 갱신합니다.
                completionHandler(.defer)
            @unknown default:
                fatalError()
            }
        }
    
    // MARK: WebDomainToken으로 설정 된 웹에서 버튼 클릭 시 동작을 설정합니다.
    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void) {
            // Handle the action as needed.
            completionHandler(.close)
        }
    
    // MARK: ActivityCategoryToken으로 설정 된 웹에서 버튼 클릭 시 동작을 설정합니다.
    /// ActivityCategory는 각 Application이 App Category를 기준으로 분류 시킨 상위 카테고리 그룹입니다.
    /// ActivityCategory 내의 모든 Application 설정 시 ActivityCategory으로 설정하였다고 시스템은 인식합니다.
    override func handle(
        action: ShieldAction,
        for category: ActivityCategoryToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void) {
            switch action {
            case .primaryButtonPressed:
                /// 시스템이 현재 어플리케이션이나 웹 브라우저를 닫도록 합니다.
                completionHandler(.close)
            case .secondaryButtonPressed:
                /// 추가 동작이 없으며 뷰를 갱신하지 않습니다.
                completionHandler(.none)
            @unknown default:
                fatalError()
            }
        }
}
