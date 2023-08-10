//
//  Color+Extension.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/10.
//

import Foundation
import SwiftUI

// swiftlint:disable identifier_name
extension Color {
    static var accentColor: Self {
        .init(hex: "#5856D6")
    }
            
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
// swiftlint:enable identifier_name

enum ColorManager {
    static let accentColor: UIColor = UIColor(Color.accentColor)
}
