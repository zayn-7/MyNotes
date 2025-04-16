//
//  HomeView.swift
//  MyNotes
//
//  Created by Zayn on 03/03/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State var searchText: String = ""
    @State var showProfileView: Bool = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    @Query(sort: \Note.createdOn, order: .reverse) private var notes: [Note]
    
    @Environment(\.modelContext) private var modelContext
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notes
        } else {
            return notes.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                
                // List of notes
                List {
                    ForEach(filteredNotes) { note in
                        NavigationLink(destination: NoteDetailView(note: note)) {
                            NoteRowView(note: note)
                        }
                    }
                    .onDelete(perform: deleteNote)
                }
                .navigationTitle("My Notes")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                            .foregroundStyle(.purple)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            
                            // profile info
                            Button(action: {
                                showProfileView = true
                            }) {
                                Label("Profile", systemImage: "person.circle")
                            }
                            
                        } label: {
                            // Menu
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(.purple)
                        }
                    }
                }
                .searchable(text: $searchText, prompt: "Search notes")
                
                // Floating button
                NavigationLink(
                    destination: AddNoteView()
                        .navigationBarBackButtonHidden(true)
                ) {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.purple)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .hoverEffect(.lift)
                }
                .padding()
                .transition(.scale)
                .animation(.easeInOut(duration: 0.3), value: notes.count)
            }
        }
        .onAppear {
            print("Fetched notes: \(notes.count)")
            
            Task {
                await viewModel.fetchUser()
            }
        }
        .sheet(isPresented: $showProfileView) {
            ProfileView()
        }
    }
    
    private func deleteNote(indexSet: IndexSet) {
        for index in indexSet {
            let note = notes[index]
            modelContext.delete(note)
        }
    }
}

#Preview {
    HomeView()
}
