//
//  MyNotesApp.swift
//  MyNotes
//
//  Created by Zayn on 24/02/25.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct AiNotesApp: App {
    @StateObject var ViewModel = AuthViewModel()
    
    init () {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel)
        }
        .modelContainer(for: Note.self)
    }
}
