//
//  ContentView.swift
//  Ai Notes
//
//  Created by Zayn on 18/02/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var ViewModel: AuthViewModel
    @AppStorage("isFirstTimeLogin") var isFirstTimeLogin: Bool = true
    
    var body: some View {
        Group {
            if ViewModel.userSession != nil {
                HomeView()
                    .environmentObject(ViewModel)
            } else {
                OnboardingView()
                    .environmentObject(ViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
