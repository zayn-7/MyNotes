//
//  ImageDetailView.swift
//  MyNotes
//
//  Created by Zayn on 27/02/25.
//

import SwiftUI

struct ImageDetailViews: View {
    let imageData: Data
    var sharableImage: UIImage? {
        UIImage(data: imageData) // Data to UIImage
    }
    
    var body: some View {
        ZStack {
            if let uiImage = sharableImage {
                //image
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                // ShareLink
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ShareLink(item: Image(uiImage: uiImage), preview: SharePreview("Image", image: Image(uiImage: uiImage))) {
                            
                            //icon
                            Image(systemName: "square.and.arrow.up")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            } else {
                Text("Invalid Image Data")
                    .foregroundColor(.red)
            }
        }
    }
}
