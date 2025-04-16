//
//  EditNoteView.swift
//  MyNotes
//
//  Created by Zayn on 27/02/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditNoteView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var note: Note
    
    @State private var selectedImageArray: [PhotosPickerItem] = []
    @State private var selectedImageDataArray: [Data]
    @State private var selectedImageIndex: Int?
    
    //initializer
    init(note: Note) {
        self._note = Bindable(wrappedValue: note)
        self._selectedImageDataArray = State(initialValue: note.imageDataArray)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Note")) {
                    TextField("Title", text: $note.title)
                    TextEditor(text: $note.content)
                        .frame(minHeight: 200)
                }
                
                NavigationLink("Add Text from Image") {
                    RecognizeTextView(recognizedText: $note.content)
                }
                
                // editing images
                Section(header: Text("Edit Images")) {
                    // images with remove option
                    ForEach(selectedImageDataArray.indices, id: \.self) { index in
                        HStack {
                            if let uiImage = UIImage(data: selectedImageDataArray[index]) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .cornerRadius(10)
                                
                                Spacer()
                                
                                Button(action: {
                                    selectedImageDataArray.remove(at: index)
                                    
                                    // Reset selectedImageIndex
                                    if selectedImageDataArray.isEmpty {
                                        selectedImageIndex = nil
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteImage) //swipe to delete
                    
                    // Add new images
                    PhotosPicker("Add Photos", selection: $selectedImageArray, maxSelectionCount: 10, matching: .images)
                        .onChange(of: selectedImageArray) { oldValue, newValue in
                            loadImageData(from: newValue)
                        }
                }
            }
            .navigationTitle("Edit Note")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        // Update imageDataArray with edited images
                        note.imageDataArray = selectedImageDataArray
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: Binding<Bool>(
                get: { selectedImageIndex != nil },
                set: { if !$0 { selectedImageIndex = nil } }
            )) {
                if let index = selectedImageIndex, index < selectedImageDataArray.count {
                    ImageDetailViews(imageData: selectedImageDataArray[index])
                }
            }
        }
    }
    
    // Load image data from PhotosPicker
    func loadImageData(from items: [PhotosPickerItem]) {
        Task {
            for item in items {
                if let data = try await item.loadTransferable(type: Data.self) {
                    selectedImageDataArray.append(data)
                }
                if selectedImageDataArray.count >= 10 {
                    break
                }
            }
        }
    }
    
    // Delete image using swipe to delete
    func deleteImage(at offsets: IndexSet) {
        selectedImageDataArray.remove(atOffsets: offsets)
        
        // Reset selectedImageIndex if all images are deleted
        if selectedImageDataArray.isEmpty {
            selectedImageIndex = nil
        }
    }
}
