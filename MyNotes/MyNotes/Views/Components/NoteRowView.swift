//
//  NoteRowView.swift
//  MyNotes
//
//  Created by Zayn on 27/02/25.
//

import SwiftUI
import SwiftData

struct NoteRowView: View {
    let note: Note
    
    var body: some View {
        HStack(spacing: 20) {
            // Note details
            VStack(alignment: .leading, spacing: 6) {
                Text(note.title)
                    .font(.title2.bold())
                    .lineLimit(1)
                
                Text(note.content)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Text("\(note.createdOn, style: .date)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if !note.imageDataArray.isEmpty {
                    Text("\(note.imageDataArray.count) image(s)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding([.top, .bottom], 8)
    }
}
#Preview {
    let exampleNote1 = Note(
        title: "Grocery List",
        content: "Milk, Eggs, Bread",
        createdOn: Date.now,
        imageDataArray: [
            UIImage(systemName: "photo")!.pngData()!
        ]
    )
    
    NoteRowView(note: exampleNote1)
}
