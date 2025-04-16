//
//  RecognizeTextView.swift
//  MyNotes
//
//  Created by Zayn on 25/02/25.
//


import SwiftUI
import PhotosUI
import Vision

struct RecognizeTextView: View {
    @Binding var recognizedText: String
    @State var selectedItem: PhotosPickerItem?
    @State var selectedImage: UIImage?
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                // Display the image
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .cornerRadius(10)
                        .padding()
                }
                
                // Display the recognized text
                if !recognizedText.isEmpty {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Recognized Text:")
                                .font(.headline.bold())
                                .padding(.trailing, 5)
                            
                            Image(systemName: "pencil")
                                .font(.headline.bold())
                                .foregroundColor(.blue)
                        }
                        TextEditor(text: $recognizedText)
                    }
                    .padding()
                } else {
                    Spacer()
                    Text("Select an Image to add Text")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
                
                Spacer()
                
                
                if recognizedText.isEmpty {
                    PhotosPicker("Pick a Photo", selection: $selectedItem, matching: .images)
                        .buttonStyle(.borderedProminent)
                        .onChange(of: selectedItem) { oldItem, newItem in
                            Task {
                                if let data = try await selectedItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        selectedImage = uiImage
                                        await recognizeText(image: uiImage)
                                    }
                                }
                            }
                        }
                        .padding()
                    
                } else {
                    Button("Add") {
                        dismiss()
                    }
                }
            }
            .navigationTitle("Text Recognition")
        }
    }
    
    //recognize text
    func recognizeText(image: UIImage) async {
        guard let cgImage = image.cgImage else { return }
        
        let textRequest = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                recognizedText = "Failed to recognize text"
                print("Failed to recognize text")
                return
            }
            
            let recognizedStrings = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }
            
            recognizedText = recognizedStrings.joined(separator: "\n")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage)
        
        do {
            try handler.perform([textRequest])
        } catch {
            recognizedText = "Failed to recognize text"
            print(error)
        }
    }
}
    
#Preview {
    RecognizeTextView(recognizedText: .constant("Ersedaf"))
}
