//
//  NoteDetailView.swift
//  MyNotes
//
//  Created by Zayn on 18/02/25.
//

import SwiftUI
import SwiftData

struct NoteDetailView: View {
    let note: Note
    @State private var showImagePreview = false
    @State private var selectedImageIndex: Int?
    @State private var showEditView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Note Details")
                    .font(.headline)
                    .padding(.horizontal)
                
                // Title
                Text(note.title)
                    .multilineTextAlignment(.trailing)
                    .padding()
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                            .opacity(0.3)
                    )
                
                // Creation Date
                Text("Created on: \(note.createdOn, style: .date)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Divider()
                
                // Content
                Text(note.content)
                    .font(.body)
                    .padding(.horizontal)
                
                // Display Images
                if !note.imageDataArray.isEmpty {
                    Text("Attached Images:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Divider()

                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.adaptive(minimum: 250))]) {
                            ForEach(note.imageDataArray.indices, id: \.self) { index in
                                if note.imageDataArray.indices.contains(index) {
                                    
                                    if let uiImage = UIImage(data: note.imageDataArray[index]) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 250, height: 250)
                                            .cornerRadius(10)
                                            .onTapGesture {
                                                selectedImageIndex = index
                                                showImagePreview.toggle()
                                            }
                                    } else {
                                        Text("Invalid Image")
                                            .frame(width: 100, height: 100)
                                            .background(Color.gray)
                                    }
                                }
                            }
                        }
                    }
                    .padding(5)
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .sheet(isPresented: Binding<Bool>(
            get: { selectedImageIndex != nil },
            set: { if !$0 { selectedImageIndex = nil } }
        )) {
            if let index = selectedImageIndex, index < note.imageDataArray.count {
                ImageDetailViews(imageData: note.imageDataArray[index])
            }
        }
        .sheet(isPresented: $showEditView) {
            EditNoteView(note: note)
        }
        .overlay(
            // Floating Edit Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // Show EditNoteView
                        showEditView.toggle()
                    }) {
                        Image(systemName: "pencil")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding()
                }
            }
        )
    }
}

#Preview {
    NoteDetailView(note: Note(title: "Sample Note", content: "This is a sample note.", createdOn: .now))
}
