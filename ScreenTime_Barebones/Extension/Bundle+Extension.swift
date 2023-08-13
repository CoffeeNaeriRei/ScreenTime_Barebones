//
//  Bundle+Extension.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/11.
//

import Foundation

extension Bundle {
    // TODO: - 확인 후 주석 삭제
//    var appGroupName: String {
//        guard let filePath = Bundle.main.path(forResource: "ScreenTime-Barebones-Info", ofType: "plist"),
//              let plistDict = NSDictionary(contentsOfFile: filePath)
//        else {
//            fatalError("Couldn't find file 'ScreenTime-Barebones-Info.plist'.")
//        }
//
//        // plist 안쪽에 사용할 Key값을 입력해주세요.
//        guard let value = plistDict.object(forKey: "APP_GROUP_NAME") as? String else {
//            fatalError("Couldn't find key 'APP_GROUP_NAME' in 'ScreenTime-Barebones-Info.plist'.")
//        }
//
//        return value
//    }
//
//    static let APP_GROUP_NAME: String = {
//        guard let value = Bundle.main.infoDictionary?["APP_GROUP_NAME"] as? String else {
//            fatalError("APP_NAME not set in Info.plist")
//        }
//
//        print(value)
//
//        return value
//    }()
    
    var APP_GROUP_NAME: String {
        /// plist 파일에서 key값에 해당하는 값을 String으로 불러옵니다.
        guard let value = Bundle.main.infoDictionary?["APP_GROUP_NAME"] as? String else {
            fatalError("APP_NAME not set in Info.plist")
        }
        return value
    }
}
