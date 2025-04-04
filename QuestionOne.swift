//
//  SwiftUIView.swift
//  MillionaireApp
//
//  Created by Mansi K on 10/12/24.
//

import SwiftUI

struct QuestionOne: View {
    // State variables to track game progress and status
    @State private var MoneyEarned = 0
    @State private var currentQuestIndex = 0
    @State private var isError = false
    @State private var isHomeScreen = true

    // Predefined question data with options and answers
    let questions: [QuestionData] = [
        .init(question: "Who wrote the play Romeo and Juliet?", options: ["Sylvia Plath", "Zadie Smith", "William Shakespeare", "Roald Dahl"], correctAnswer: "William Shakespeare", prize: 1000),
        .init(question: "Which element has the chemical symbol O?", options: ["Ox", "Oz", "O", "Xy"], correctAnswer: "O", prize: 2000),
        .init(question: "What is the capital of France?", options: ["Berlin", "Madrid", "Paris", "Rome"], correctAnswer: "Paris", prize: 5000),
        .init(question: "What is the largest ocean on Earth?", options: ["Atlantic", "Indian", "Pacific", "Arctic"], correctAnswer: "Pacific", prize: 10000),
        .init(question: "Who developed the theory of relativity?", options: ["Isaac Newton", "Albert Einstein", "Galileo Galilei", "Nikola Tesla"], correctAnswer: "Albert Einstein", prize: 20000),
        .init(question: "Which planet is known as the Red Planet?", options: ["Earth", "Mars", "Jupiter", "Venus"], correctAnswer: "Mars", prize: 50000),
        .init(question: "Who painted the Mona Lisa?", options: ["Vincent van Gogh", "Pablo Picasso", "Leonardo da Vinci", "Claude Monet"], correctAnswer: "Leonardo da Vinci", prize: 100000),
        .init(question: "What is the largest mammal?", options: ["Elephant", "Blue Whale", "Shark", "Giraffe"], correctAnswer: "Blue Whale", prize: 150000),
        .init(question: "Which country is the Eiffel Tower located in?", options: ["France", "Italy", "Spain", "Germany"], correctAnswer: "France", prize: 300000),
        .init(question: "What is the boiling point of water?", options: ["90°C", "100°C", "110°C", "120°C"], correctAnswer: "100°C", prize: 362000)
    ]
    
    var body: some View {
        VStack {
            // Display welcome message when on home screen
            if isHomeScreen {
                
                Text("Welcome to Who Wants to Be a Millionaire!")
                    .font(.largeTitle)
                    .padding()
                
                Button(action: {
                    // Reset game state when starting
                    isHomeScreen = false
                    MoneyEarned = 0
                    currentQuestIndex = 0
                    isError = false
                }) {
                    Text("Start the game")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                // Display current earnings and handle errors
                VStack {
                    Text("You have earned: $\(MoneyEarned)")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .padding(.top, 50)
                    
                    if isError {
                        // Show error message and "Start Over" button if wrong answer
                        Text("Incorrect answer. Click the button to return to home screen.")
                            .foregroundColor(.red)
                            .font(.headline)
                            .padding()
                        Button(action: {
                            // Reset game state on error
                            isHomeScreen = true
                            currentQuestIndex = 0
                            MoneyEarned = 0
                            isError = false
                        }) {
                            Text("Start Over")
                                .font(.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        // Display current question or completion message
                        if currentQuestIndex < questions.count {
                            // Show current question if not finished
                            QuizQuestion(data: questions[currentQuestIndex], MoneyEarned: $MoneyEarned, currentQuestIndex: $currentQuestIndex, isError: $isError)
                        } else {
                            // Show completion message
                            Text("Congratulations! You've completed the Game!")
                                .font(.title)
                                .padding()
                            Button(action: {
                                // Reset game state on completion
                                isHomeScreen = true
                                MoneyEarned = 0
                                currentQuestIndex = 0
                            }) {
                                Text("Back to Home")
                                    .font(.title)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true) // Hide back button
    }
}
// Struct to define a question with options and answer
struct QuestionData {
    var question: String
    var options: [String]
    var correctAnswer: String
    var prize: Int
}

// View for displaying and handling individual questions

struct QuizQuestion: View {
    var data: QuestionData
    @Binding var MoneyEarned: Int
    @Binding var currentQuestIndex: Int
    @Binding var isError: Bool
    @State private var chosenOption: String? = nil
    @State private var submitted = false
    @State private var showToast = false
    
    var body: some View {
        VStack {
            Text(data.question)
                .font(.title)
                .padding(.top, 50)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(data.options, id: \.self) { option in
                    OptionButton(option: option, selectedOption: $chosenOption)
                }
            }
            
            Button(action: {
                submitted = true
                if chosenOption == data.correctAnswer {
                    // Update earnings and show toast for correct answer
                    MoneyEarned += data.prize
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        currentQuestIndex += 1
                    }
                } else {
                    isError = true
                }
            }) {
                Text("Submit")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        
            if showToast {
                Text("Correct answer! You have won $\(data.prize)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .transition(.move(edge: .top))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }
            }
            
            Spacer()
        }
        .padding()
    }
}

struct OptionButton: View {
    var option: String
    @Binding var selectedOption: String?

    var body: some View {
        Button(action: {
            selectedOption = option
        }) {
            HStack {
                Image(systemName: selectedOption == option ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                
                Text(option)
                    .font(.title2)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

