//
//  ESButton.swift
//  EazyShop
//
//  Created by Cesar Rojas on 7/31/24.
//

import SwiftUI

public struct ESButton<T: View>: View {
    var titleKey: String = ""
    var action: () -> Void
    @ViewBuilder var label: () -> T
   
    init(titleKey: String = "", action: @escaping () -> Void, @ViewBuilder label: @escaping () -> T) {
        self.titleKey = titleKey
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        if titleKey.count > 0 {
            Button(titleKey) {
                buttonAction()
            }
        } else {
            Button {
                buttonAction()
            } label: {
                label()
            }

        }
    }
    
    private func buttonAction() {
        action()
        //debugPrint("---- \(self)")
    }
}

public extension ESButton where T == EmptyView {
    init(_ titleKey: String = "", action: @escaping () -> Void, extraLogs: [String: Any] = [:]) {
        self.init(titleKey: titleKey, action: action, label: { EmptyView() })
    }
}

