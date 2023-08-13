//
//  PermissionView.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import SwiftUI

struct PermissionView: View {
    @StateObject private var vm = PermissionVM()
    
    var body: some View {
        VStack(alignment: .center) {
            navigationHeaderLikeView()
            decorationView()
            permissionButtonView()
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .sheet(isPresented: $vm.isSheetActive) {
            sheetView()
        }
        .onAppear {
            vm.handleTranslationView()
        }
    }
}

// MARK: - Views
extension PermissionView {
    private func navigationHeaderLikeView() -> some View {
        HStack {
            Button {
                vm.showIsSheetActive()
            } label: {
                Image(systemName: vm.HEADER_ICON_LABEL)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.secondary)
            }
            .frame(width: 40, height: 40)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: 42, alignment: .trailing)
        .opacity(vm.isViewLoaded ? 1 : 0)
    }
    
    private func decorationView() -> some View {
        VStack(spacing: 12) {
            Image(vm.DECORATION_TEXT_INFO.imgSrc)
                .resizable()
                .frame(width: 100, height: 100)
            if vm.isViewLoaded {
                Text(vm.DECORATION_TEXT_INFO.title)
                    .font(.largeTitle)
                    .foregroundColor(Color.primaryColor)
                    .bold()
                Text(vm.DECORATION_TEXT_INFO.subTitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func permissionButtonView() -> some View {
        HStack {
            Button {
                vm.handleRequestAuthorization()
            } label: {
                Text(vm.PERMISSION_BUTTON_LABEL)
            }
            .buttonStyle(.borderless)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: 128)
        .opacity(vm.isViewLoaded ? 1 : 0)
    }
    
    private func sheetView() -> some View {
        VStack {
            Text(vm.SHEET_INFO_LIST[0])
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
                .font(.title2)
            Text(vm.SHEET_INFO_LIST[1])
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.bottom, 24)
                .font(.body)
            Text(.init(vm.GIT_LINK_LABEL))
                .font(.title3)
        }
        .padding(24)
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
