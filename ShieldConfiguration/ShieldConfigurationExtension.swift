//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
// MARK: - ShieldView 커스터마이징
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    let CUSTOM_ICON = UIImage(systemName: "hand.raised.fill")?.withTintColor(.tintColor)
    let CUSTOM_TITLE = ShieldConfiguration.Label(text: "Block", color: .tintColor)
    
    lazy var DEFAULT_SHIELD_CONFIG = ShieldConfiguration(
        /// ShieldView의 backgroundBlurStyle을 변경합니다.
        /// ShieldView는 실행중인 해당 앱/웹의 상위 레이어에 올라와 스타일에 따라 비춰질 수 있습니다.
        backgroundBlurStyle: .none,
        backgroundColor: .white,
        icon: CUSTOM_ICON,
        title: CUSTOM_TITLE
    )
        
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        DEFAULT_SHIELD_CONFIG
    }
    
    override func configuration(
        shielding application: Application,
        in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        DEFAULT_SHIELD_CONFIG
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        DEFAULT_SHIELD_CONFIG
    }
    
    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        DEFAULT_SHIELD_CONFIG
    }
}
