//
//  SearchFlowApp.swift
//  SearchFlow
//
//  Created by Chr1s on 2021/9/29.
//

import SwiftUI

@main
struct SearchFlowApp: App {
    
    @StateObject var vm = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            if vm.isSearch {
                SearchView().environmentObject(vm)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.4)))
            } else {
                HomeView().environmentObject(vm)
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.4)))
            }
        }
    }
}
