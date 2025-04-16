//
//  AddNoteView.swift
//  MyNotes
//
//  Created by Zayn on 18/02/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddNoteView: View {
    @State private var title = ""
    @State private var content = ""
    @State private var createdOn: Date = Date.now
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var isDisabled = false
    
    @State private var selectedImageArray: [PhotosPickerItem] = []
    @State private var selectedImageDataArray: [Data] = []
    
    @State private var showImagePreview = false
    @State private var selectedImageIndex: Int?

    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Note Details")) {
                        TextField("Add Title", text: $title)
                    }
                    TextEditor(text: $content)
                        .frame(minHeight: 300)
                        .overlay {
                            if content.isEmpty {
                                Text("Add Content Here...")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                            }
                        }
                }
                
                // Display selected images
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(selectedImageDataArray.indices, id: \.self) { index in
                            if let uiImage = UIImage(data: selectedImageDataArray[index]) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipped()
                                    .frame(width: 100, height: 100)
                                    .onTapGesture {
                                        selectedImageIndex = index
                                        showImagePreview.toggle()
                                    }
                            }
                        }
                    }
                    .padding(15)
                }
                
                // Buttons
                HStack {
                    // Add Photos
                    PhotosPicker("Attach Photos", selection: $selectedImageArray, maxSelectionCount: 10, matching: .images)
                        .onChange(of: selectedImageArray) { oldValue, newValue in
                            selectedImageArray = []
                            loadImageData(from: newValue)
                        }
                    
                    Divider()
                        .frame(minHeight: 30)
                    
                    // add text from image
                    NavigationLink("Add Text from Image") {
                        RecognizeTextView(recognizedText: $content)
                    }
                }
                .frame(maxHeight: 10)
                .padding(.bottom, 10)
            }
            
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        do {
                            let newNote = Note(
                                id: UUID(),
                                title: title,
                                content: content,
                                createdOn: createdOn,
                                imageDataArray: selectedImageDataArray
                            )
                            modelContext.insert(newNote)
                        } catch {
                            print("Failed to save note: \(error)")
                        }
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text("\(createdOn, style: .date)")
                }
            }
            
            // image preview
            .sheet(isPresented: $showImagePreview) {
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
}

#Preview {
    AddNoteView()
}
