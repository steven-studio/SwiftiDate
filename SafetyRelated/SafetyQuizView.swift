//
//  SafetyQuizView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import Foundation
import SwiftUI

struct SafetyQuizView: View {
    @State private var selectedOption: String? = nil
    @State private var showExplanation: Bool = false
    @State private var showMessage: Bool = false
    @State private var currentQuestionIndex: Int = 0
    @State private var score: Int = 0 // Tracks the user's score
    @State private var navigateToResults: Bool = false // To trigger navigation
    @Binding var showSafetyTestView: Bool // Binding to return to SafetyTestView

    let questions: [QuizQuestion] = [
        QuizQuestion(
            text: "配對後，用以下哪種聊天方式會更安全？",
            options: ["配對後，在 SwiftiDate 上聊天", "配對後馬上轉去其他平台或APP"],
            correctAnswer: "配對後，在 SwiftiDate 上聊天",
            explanation: "SwiftiDate 上聊天更安全。如果配對之後馬上換到其他平台或其他APP聊天，SwiftiDate的安全團隊就沒有辦法保護您聊天的安全～"
        ),
        QuizQuestion(
            text: "系統顯示，你和一個配對距離很近。對方說想見面，並問你的具體住址在哪。這時候，你應該…",
            options: ["告訴對方自己的詳細住址", "只告訴對方自己所在的大致方位。保護隱私，不輕易透露個人訊息。"],
            correctAnswer: "只告訴對方自己所在的大致方位。保護隱私，不輕易透露個人訊息。",
            explanation: "個人詳細住址屬於個人隱私。為了你的安全，請不要輕易透露個人信息。"
        ),
        QuizQuestion(
            text: "一位條件很好的配對對象每天無微不至地關心你，聊了很久之後提出要加Line，帶你一起投資賺錢。你的態度會是：",
            options: ["立馬檢舉，這是詐騙！", "謹慎投資，先投點小錢試試看"],
            correctAnswer: "立馬檢舉，這是詐騙！",
            explanation: "網路上認識後相約一起投資的，幾乎都是詐騙。遇到這種情況，請立刻向 SwiftiDate 檢舉。無論利潤多高多好，都不能相信。"
        ),
        QuizQuestion(
            text: "配對好友跟你聊了很久，某天約你在現實生活中見面，你也想去赴約，你會：",
            options: ["相約在咖啡廳、餐廳等公共場所所見面", "可以去他家裡見面"],
            correctAnswer: "相約在咖啡廳、餐廳等公共場所所見面",
            explanation: "第一次在線下見面盡量選擇公共場所。如果對方有任何讓你感覺不適的行為，要馬上離開。"
        ),
        QuizQuestion(
            text: "你要跟某個配對好友第一次在現實生活中見面，下面哪一種出行方式更安全？",
            options: ["讓對方開車接你", "自己開車或乘坐公共交通"],
            correctAnswer: "自己開車或乘坐公共交通",
            explanation: "第一次見面乘坐自己的或公共交通工具前往更加安全哦！一定要帶好手機和家人朋友保持聯絡～"
        ),
        QuizQuestion(
            text: "你配對到一個長得不錯並對你很好的對象。你們的關係進展很快，聊了幾天，對方表示有意想發展成為戀人關係。之後，他說他家人突然生病了，想問你借一大筆錢，你會：",
            options: ["立馬檢舉，聊天過程中以任何理由借錢的都是詐騙", "詢問具體情況後再轉帳"],
            correctAnswer: "立馬檢舉，聊天過程中以任何理由借錢的都是詐騙",
            explanation: "請勿答應任何轉帳的請求。首先要求交往再要求轉帳的人，很可能是詐騙。建議立即向 SwiftiDate 檢舉。"
        )
    ]
    
    var body: some View {
        if navigateToResults {
            // Pass the binding to the ResultsView
            ResultsView(score: score, totalQuestions: questions.count, showSafetyTestView: $showSafetyTestView)
                .onAppear {
                    AnalyticsManager.shared.trackEvent("SafetyQuiz_ResultsViewed", parameters: ["score": score, "total": questions.count])
                }
        } else {
            VStack {
                // Current question text and progress bar
                Text("第 \(currentQuestionIndex + 1) 題，共 \(questions.count) 題")
                    .font(.headline)
                    .padding()
                
                ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questions.count))
                    .padding(.horizontal, 40)
                
                Spacer()
                
                Text(questions[currentQuestionIndex].text)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                
                if showExplanation {
                    ExplanationView(explanation: questions[currentQuestionIndex].explanation)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.5))
                        .onAppear {
                            AnalyticsManager.shared.trackEvent("SafetyQuiz_ExplanationShown", parameters: ["questionIndex": currentQuestionIndex])
                        }
                } else {
                    if showMessage {
                        MessageView(isCorrect: selectedOption == questions[currentQuestionIndex].correctAnswer)
                    }
                    
                    // Render question options
                    ForEach(questions[currentQuestionIndex].options, id: \.self) { option in
                        OptionButton(optionText: option, isSelected: selectedOption == option) {
                            selectedOption = option
                            showMessage = true
                            
                            let isCorrect = selectedOption == questions[currentQuestionIndex].correctAnswer
                            // 記錄選擇答案事件
                            AnalyticsManager.shared.trackEvent("SafetyQuiz_OptionSelected", parameters: ["questionIndex": currentQuestionIndex, "option": option, "isCorrect": isCorrect])
                            
                            // Check if the selected option is correct and increment the score
                            if isCorrect {
                                score += 1 // Increment score
                                print("Debug: Correct answer selected. Current score: \(score)")
                            } else {
                                print("Debug: Incorrect answer. Selected option: \(selectedOption), Correct answer: \(questions[currentQuestionIndex].correctAnswer)")
                            }
                            
                            triggerExplanation()
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // "Next" button
                // "Next" button or "View Results" button for the last question
                Button(action: {
                    if currentQuestionIndex == questions.count - 1 {
                        AnalyticsManager.shared.trackEvent("SafetyQuiz_NextQuestion", parameters: ["questionIndex": currentQuestionIndex, "action": "viewResults"])
                        navigateToResults = true // Trigger navigation to results
                    } else {
                        AnalyticsManager.shared.trackEvent("SafetyQuiz_NextQuestion", parameters: ["questionIndex": currentQuestionIndex, "action": "next"])
                        moveToNextQuestionOrShowResults()
                    }
                }) {
                    Text(currentQuestionIndex == questions.count - 1 ? "查看結果" : "下一題") // Change button label based on question index
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(showExplanation ? Color.green : Color.gray) // Change background based on explanation visibility
                        .cornerRadius(10)
                        .padding(.horizontal, 30)
                }
                .disabled(!showExplanation) // Disable button when explanation is not shown
            }
            .padding()
            .background(Color.white.ignoresSafeArea())
            .onAppear {
                AnalyticsManager.shared.trackEvent("SafetyQuizView_Appeared", parameters: nil)
            }
        }
    }
    
    // Function to show the explanation after a delay
    func triggerExplanation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showExplanation = true
            showMessage = false
        }
    }
    
    // Function to move to the next question or show results
    func moveToNextQuestionOrShowResults() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            selectedOption = nil
            showExplanation = false
        } else {
            // Handle quiz completion (you could navigate to a results page, for example)
            print("Quiz completed")
            // Add logic to show results or move to another screen if necessary
        }
    }
}

struct QuizQuestion {
    let text: String
    let options: [String]
    let correctAnswer: String
    let explanation: String
}

struct OptionButton: View {
    var optionText: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(optionText)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.green.opacity(0.2) : Color.white)
                .cornerRadius(10)
                .shadow(radius: 1)
                .foregroundColor(.black)
        }
    }
}

struct MessageView: View {
    var isCorrect: Bool
    
    var body: some View {
        Text(isCorrect ? "答對了！好厲害！" : "差一點點就能答對了！")
            .font(.headline)
            .foregroundColor(isCorrect ? Color.green : Color.red)
            .padding(.bottom, 10)
    }
}

struct ExplanationView: View {
    var explanation: String
    
    var body: some View {
        Text(explanation)
            .font(.body)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding()
            .background(Color.green.opacity(0.2))
            .cornerRadius(10)
            .padding(.horizontal, 30)
    }
}

struct SafetyQuizView_Previews: PreviewProvider {
    @State static var showSafetyTestView = true // Create a state variable for preview

    static var previews: some View {
        SafetyQuizView(showSafetyTestView: $showSafetyTestView) // Pass the binding
    }
}
