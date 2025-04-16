//
//  OnBoardingSlide.swift
//  MyNotes
//
//  Created by Zayn on 28/02/25.
//

import Foundation


struct OnboardingSlide: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}


let onboardingSlides: [OnboardingSlide] = [
    OnboardingSlide(
        title: "Organize Your Notes",
        description: "Easily create, edit, and organize your notes with a simple and intuitive interface.",
        imageName: "note.text"
    ),
    OnboardingSlide(
        title: "Attach Images",
        description: "Add images to your notes to make them more visual and informative.",
        imageName: "photo"
    ),
    OnboardingSlide(
        title: "Secure and Private",
        description: "Your notes are securely stored and accessible only by you.",
        imageName: "lock"
    ),
    OnboardingSlide(
        title: "Extract Text from Images",
        description: "Extract Text from Images and add it to your notes.",
        imageName: "text.below.photo"
    )
]
