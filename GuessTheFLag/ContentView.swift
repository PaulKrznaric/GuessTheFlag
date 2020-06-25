//
//  ContentView.swift
//  GuessTheFLag
//
//  Created by Paul Krznaric on 2020-06-03.
//  Copyright © 2020 Krznarnetic. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland",
                     "Italy", "Nigeria", "Poland", "Russia",
                     "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var angle: Double = 0
    @State private var fade = false;
    @State private var spin = false;
    @State private var wrong = false;
    @State private var isTapped = [false, false, false]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]),
                           startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    })
                    {
                        Image(self.countries[number])
                            .renderingMode(.original)
                        .FlagImage()
                            .rotation3DEffect(.degrees(self.angle), axis: self.correctAnswer == number && self.spin ? (x: 0, y: 1, z: 0) : (x: 0, y: 0, z: 0))
                            .animation(.easeIn)
                            .offset(x: number != self.correctAnswer && self.wrong && self.isTapped[number] ? -10 : 0)
                            .animation(Animation.default.repeatCount(5))
                            .opacity( self.correctAnswer != number && self.fade ? 0.25 : 1.0)
                    }
                }
                Text("Current Score: \(score)")
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message:
            Text("Your score is \(score)"),
                  dismissButton:
                .default(Text("Continue")){
                    self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int){
        isTapped[number] = true
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
            angle += 360
            spin = true
        } else {
            scoreTitle = "Wrong! That's the flag of \(countries[number])"
            score -= 1
            wrong = true
        }
        fade = true;
        showingScore = true
    }
    
    func askQuestion() {
        fade = false
        isTapped = [false, false, false]
        spin = false
        wrong = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct FormatFlag: ViewModifier{
    
    func body (content: Content) -> some View {
        content
        .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)

        
    }
}

extension View {
    func FlagImage() -> some View {
        self.modifier(FormatFlag())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
