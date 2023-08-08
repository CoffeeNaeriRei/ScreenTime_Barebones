//
//  MainTabView.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var vm = MainTabVM()
    
    var body: some View {
        TabView(selection: $vm.tabIndex) {
            ForEach(MainTab.allCases, id: \.self) { mainTab in
                mainTab.view
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .border(.red, width: 2)
                    .tabItem {
                        Label(
                            mainTab.labelInfo.text,
                            systemImage: mainTab.labelInfo.icon
                        )
                    }
                    .tag(mainTab.hashValue)
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
