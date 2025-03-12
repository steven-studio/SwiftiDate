//
//  TabStateMachineManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/12.
//

import Foundation
import StateMachine

// 定義所有可能的 Tab 狀態
enum TabState: String, StateMachineHashable {
    case swipe    // 對應 tag 0
    case turbo    // 對應 tag 1
    case guide    // 對應 tag 2 (男生用戶)
    case astrology // 對應 tag 2 (女生用戶)
    case chat     // 對應 tag 3
    case profile  // 對應 tag 4

    var hashableIdentifier: String { self.rawValue }
    var associatedValue: Any { self }
}

// 定義所有可能的事件，針對每個頁籤建立一個事件
enum TabEvent: StateMachineHashable {
    case selectSwipe
    case selectTurbo
    case selectGuide
    case selectAstrology
    case selectChat
    case selectProfile

    var hashableIdentifier: String { String(describing: self) }
    var associatedValue: Any { self }
}

extension TabEvent {
    // 將事件對應到預期的狀態
    func toState(userGender: Gender) -> TabState {
        switch self {
        case .selectSwipe:
            return .swipe
        case .selectTurbo:
            return .turbo
        case .selectGuide:
            return .guide
        case .selectAstrology:
            return .astrology
        case .selectChat:
            return .chat
        case .selectProfile:
            return .profile
        }
    }
}

// 用來將狀態轉換成 TabView tag 數值
func tabIndex(for state: TabState) -> Int {
    switch state {
    case .swipe:      return 0
    case .turbo:      return 1
    case .guide, .astrology: return 2
    case .chat:       return 3
    case .profile:    return 4
    }
}

// MARK: - 自定義 TabStateMachineManager
// 這個 class 繼承自 StateMachineBuilder，並封裝狀態機邏輯
class TabStateMachineManager: StateMachineBuilder, ObservableObject {
    typealias State = TabState
    typealias Event = TabEvent
    typealias SideEffect = Void

    // 使用 DSL 建構狀態機
    let stateMachine: StateMachine<TabState, TabEvent, Void> = StateMachine<TabState, TabEvent, Void> {
        // 初始狀態設定為 swipe
        initialState(TabState.swipe)
        
        // 定義 swipe 狀態的轉換規則
        state(TabState.swipe.hashableIdentifier) {
            on(TabEvent.selectTurbo.hashableIdentifier) { _, _ in
                transition(to: .turbo, emit: nil)
            }
            on(TabEvent.selectGuide.hashableIdentifier) { _, _ in
                transition(to: .guide, emit: nil)
            }
            on(TabEvent.selectAstrology.hashableIdentifier) { _, _ in
                transition(to: .astrology, emit: nil)
            }
            on(TabEvent.selectChat.hashableIdentifier) { _, _ in
                transition(to: .chat, emit: nil)
            }
            on(TabEvent.selectProfile.hashableIdentifier) { _, _ in
                transition(to: .profile, emit: nil)
            }
        }
        
        // 定義 turbo 狀態的轉換規則
        state(TabState.turbo.hashableIdentifier) {
            on(TabEvent.selectSwipe.hashableIdentifier) { _, _ in
                transition(to: .swipe, emit: nil)
            }
            on(TabEvent.selectGuide.hashableIdentifier) { _, _ in
                transition(to: .guide, emit: nil)
            }
            on(TabEvent.selectAstrology.hashableIdentifier) { _, _ in
                transition(to: .astrology, emit: nil)
            }
            on(TabEvent.selectChat.hashableIdentifier) { _, _ in
                transition(to: .chat, emit: nil)
            }
            on(TabEvent.selectProfile.hashableIdentifier) { _, _ in
                transition(to: .profile, emit: nil)
            }
        }
        
        // 定義 guide 狀態（男用戶）的轉換規則
        state(TabState.guide.hashableIdentifier) {
            on(TabEvent.selectSwipe.hashableIdentifier) { _, _ in
                transition(to: .swipe, emit: nil)
            }
            on(TabEvent.selectGuide.hashableIdentifier) { _, _ in
                transition(to: .guide, emit: nil)
            }
            on(TabEvent.selectAstrology.hashableIdentifier) { _, _ in
                transition(to: .astrology, emit: nil)
            }
            on(TabEvent.selectChat.hashableIdentifier) { _, _ in
                transition(to: .chat, emit: nil)
            }
            on(TabEvent.selectProfile.hashableIdentifier) { _, _ in
                transition(to: .profile, emit: nil)
            }
        }
        
        // 定義 astrology 狀態（女用戶）的轉換規則
        state(TabState.astrology.hashableIdentifier) {
            on(TabEvent.selectSwipe.hashableIdentifier) { _, _ in
                transition(to: .swipe, emit: nil)
            }
            on(TabEvent.selectTurbo.hashableIdentifier) { _, _ in
                transition(to: .turbo, emit: nil)
            }
            // 對於 astrology 狀態，也保持自身不變
            on(TabEvent.selectAstrology.hashableIdentifier) { _, _ in
                transition(to: .astrology, emit: nil)
            }
            on(TabEvent.selectChat.hashableIdentifier) { _, _ in
                transition(to: .chat, emit: nil)
            }
            on(TabEvent.selectProfile.hashableIdentifier) { _, _ in
                transition(to: .profile, emit: nil)
            }
        }
        
        // 定義 chat 狀態的轉換規則
        state(TabState.chat.hashableIdentifier) {
            on(TabEvent.selectSwipe.hashableIdentifier) { _, _ in
                transition(to: .swipe, emit: nil)
            }
            on(TabEvent.selectTurbo.hashableIdentifier) { _, _ in
                transition(to: .turbo, emit: nil)
            }
            on(TabEvent.selectGuide.hashableIdentifier) { _, _ in
                transition(to: .guide, emit: nil)
            }
            on(TabEvent.selectAstrology.hashableIdentifier) { _, _ in
                transition(to: .astrology, emit: nil)
            }
            on(TabEvent.selectProfile.hashableIdentifier) { _, _ in
                transition(to: .profile, emit: nil)
            }
        }
        
        // 定義 profile 狀態的轉換規則
        state(TabState.profile.hashableIdentifier) {
            on(TabEvent.selectSwipe.hashableIdentifier) { _, _ in
                transition(to: .swipe, emit: nil)
            }
            on(TabEvent.selectTurbo.hashableIdentifier) { _, _ in
                transition(to: .turbo, emit: nil)
            }
            on(TabEvent.selectGuide.hashableIdentifier) { _, _ in
                transition(to: .guide, emit: nil)
            }
            on(TabEvent.selectAstrology.hashableIdentifier) { _, _ in
                transition(to: .astrology, emit: nil)
            }
            on(TabEvent.selectChat.hashableIdentifier) { _, _ in
                transition(to: .chat, emit: nil)
            }
        }
    }
}
