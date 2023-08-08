//
//  ScheduleView.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        VStack {
            Button {
                FamilyControlsManager.shared.requestAuthorizationRevoke()
            } label: {
                Text("Revoke Permission")
            }
            .buttonStyle(.borderedProminent)
            Button {
                print(FamilyControlsManager.shared.requestAuthorizationStatus())
            } label: {
                Text("check Permission")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
