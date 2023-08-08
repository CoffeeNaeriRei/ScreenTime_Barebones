//
//  PermissionView.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import SwiftUI

struct PermissionView: View {
    var body: some View {
        Button {
            FamilyControlsManager.shared.requestAuthorization()
        } label: {
            Text("Add Permission")
        }
        .buttonStyle(.borderedProminent)
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
