//
//  Bundle+Extension.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/11.
//

import Foundation

extension Bundle {
    var appGroupName: String {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath)
        else {
            fatalError("Couldn't find file 'ScreenTime-Barebones-Info.plist'.")
        }

        // plist 안쪽에 사용할 Key값을 입력해주세요.
        guard let value = plistDict.object(forKey: "APP_GROUP_NAME") as? String else {
            fatalError("Couldn't find key 'APP_GROUP_NAME' in 'ScreenTime-Barebones-Info.plist'.")
        }

        return value
    }
}
