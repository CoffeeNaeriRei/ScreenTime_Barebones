//
//  ScheduleView.swift
//  ScreenTime_Barebones
//
//  Created by Yun Dongbeom on 2023/08/08.
//

import SwiftUI
import FamilyControls
/**
 
 1. 권한 설정 확인할 수 있어야함
 2. 스케쥴 설정(시간 설정)
 3. 앱 설정
 4. 설정한 스케쥴 및 앱 설정을 바탕으로 모니터링 스케쥴 만들기
 
 */

struct ScheduleView: View {
    @StateObject var vm = ScheduleVM()
    
    var body: some View {
        NavigationView {
            VStack {
                setupListView()
            }
            .background(Color(UIColor.secondarySystemBackground))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar { savePlanButtonView() }
            .navigationTitle("Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .alert("저장 되었습니다.", isPresented: $vm.isSaveAlertActive) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

// MARK: - Views
extension ScheduleView {
    
    private func savePlanButtonView() -> ToolbarItemGroup<Button<Text>> {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            let BUTTON_LABEL = "스케쥴 저장"
            
            Button {
                vm.saveSchedule()
            } label: {
                Text(BUTTON_LABEL)
            }
        }
    }
    
    // MARK: - Settings List View
    private func setupListView() -> some View {
        List {
            setUpTimeSectionView()
            setUPAppSectionView()
            revokeAuthSectionView()
        }
        .listStyle(.insetGrouped)
    }
    
    private func setUpTimeSectionView() -> some View {
        let TIME_LABEL_LIST = ["시작 시간", "종료 시간"]
        
        return Section(
            header: Text(ScheduleSectionInfo.time.header),
            footer: Text(ScheduleSectionInfo.time.footer)) {
                ForEach(0..<TIME_LABEL_LIST.count, id: \.self) { index in
                    DatePicker(selection: $vm.times[index], displayedComponents: .hourAndMinute) {
                        Text(TIME_LABEL_LIST[index])
                    }
                }
            }
    }
    
    private func setUPAppSectionView() -> some View {
        let BUTTON_LABEL = "변경"
        let EMPTY_TEXT = "Choose Your App"
        
        return Section(
            header: HStack {
                Text(ScheduleSectionInfo.apps.header)
                Spacer()
                Button {
                    vm.showFamilyActivitySelection()
                } label: {
                    Text(BUTTON_LABEL)
                }
                .familyActivityPicker(
                    isPresented: $vm.isFamilyActivitySectionActive,
                    selection: $vm.selection
                )
            },
            footer: Text(ScheduleSectionInfo.apps.footer)
        ) {
            if vm.isSelectionEmpty() {
                Text(EMPTY_TEXT)
                    .foregroundColor(Color.secondary)
            } else {
                ForEach(Array(vm.selection.applicationTokens), id: \.self) { token in
                    Label(token)
                }
                ForEach(Array(vm.selection.categoryTokens), id: \.self) { token in
                    Label(token)
                }
                ForEach(Array(vm.selection.webDomainTokens), id: \.self) { token in
                    Label(token)
                }
            }
        }
    }
    
    private func revokeAuthSectionView() -> some View {
        Section(
            header: Text(ScheduleSectionInfo.revoke.header)
        ) {
            revokeAuthButtonView()
        }
    }
    
    private func revokeAuthButtonView() -> some View {
        let BUTTON_LABEL = "스크린 타임 권한 제거"
        
        return Button {
            FamilyControlsManager.shared.requestAuthorizationRevoke()
        } label: {
            Text(BUTTON_LABEL)
                .tint(Color.red)
        }
    }
    
    private func checkAuthStatusButtonView() -> some View {
        let BUTTON_LABEL = "권한 확인하기"
        
        return Button {
            print(FamilyControlsManager.shared.requestAuthorizationStatus())
        } label: {
            Text(BUTTON_LABEL)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
