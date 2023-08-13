//
//  PermissionView.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import SwiftUI

struct PermissionView: View {
    @State private var isShow = false
    
    var body: some View {
        VStack(alignment: .center) {
            navigationHeaderLikeView()
            decorationView()
            permissionView()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isShow = true
                }
            }
        }
    }
}

// MARK: - Views
extension PermissionView {
    private func navigationHeaderLikeView() -> some View {
        HStack {
            Button {
                print("dd")
            } label: {
                Image(systemName: "info.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.secondary)
            }
            .frame(width: 40, height: 40)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: 42, alignment: .trailing)
        .opacity(isShow ? 1 : 0)
    }
    
    private func decorationView() -> some View {
        VStack(spacing: 12) {
            Image("AppSymbol")
                .resizable()
                .frame(width: 100, height: 100)
            if isShow {
                Text("Screen Time 101")
                    .font(.largeTitle)
                    .foregroundColor(Color.primaryColor)
                    .bold()
                Text("Screen Time API의\n기본적인 기능을 알아봅시다.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func permissionView() -> some View {
        HStack {
            Button {
                DispatchQueue.main.async {
                    FamilyControlsManager.shared.requestAuthorization()
                }
            } label: {
                Text("시작하기")
            }
            .buttonStyle(.borderless)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: 128)
        .opacity(isShow ? 1 : 0)
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
