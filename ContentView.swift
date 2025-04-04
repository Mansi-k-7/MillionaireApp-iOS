//
//  ContentView.swift
//  MillionaireApp
//
//  Created by Mansi K on 10/12/24.
//
import SwiftUI
struct ContentView: View {
    // State variable to control navigation to the next screen
    @State private var navigateToNext = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Display the WWTBAMUS2020Logo image
                Image("WWTBAMUS2020Logo")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                
                // Display the WWTBAMUS2020Logo image
                NavigationLink(
                    destination: QuestionOne(),
                    isActive: $navigateToNext // Trigger navigation when navigateToNext is true
                ) {
                    EmptyView() // Placeholder view for the navigation link
                }
                .onTapGesture { // Set navigateToNext to true to trigger navigation
                    navigateToNext = true
                }
            }
            .padding()
            .background(
               
                Color.white
                    .contentShape(Rectangle()) // Make the entire background tappable
                    .onTapGesture {
                        navigateToNext = true // Trigger navigation on background tap
                    }
            )
        }
    }
}
