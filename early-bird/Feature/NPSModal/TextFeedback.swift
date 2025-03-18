//
//  TextFeedBack.swift
//  early-bird
//
//  Created by JAYOU KOO on 3/16/25.
//

import SwiftUI

struct TextFeedBackJson: Codable {
    var comment: String
    var clientId : String
    var createdAt : String
}

struct TextFeedbackModal: View {
    @State private var showSubmitAlert = false
    @Binding var showModal: Bool
    @State private var submittedText: String = ""
    @State private var inputText: String = ""
    
    var body: some View {
        VStack(spacing:0) {
            // 멀티라인 텍스트 입력 필드
            TextEditor(text: $inputText)
                .font(.custom("Pretendard-Ragular", size: 18))
                .frame(maxHeight: .infinity)
                .padding(.leading, 20.0)
                .padding(.top, 16.0)
                .background(Color.clear)
                .cornerRadius(8)
                .overlay(alignment: .topLeading) {
                    Text("서비스에 대한 피드백을 300자 이내로 작성해주세요")
                        .padding([.top, .leading], 25.0)
                        .foregroundStyle(inputText.isEmpty ? .gray : .clear)
                        .font(.custom("Pretendard-Ragular", size: 14))
                }
                
            Button(action: {
                sendTextFeedBack()
            }) {
                Text("제출하기")
                    .frame(maxWidth: .infinity)
                    .frame(height: 48.0)
                    .background(inputText.isEmpty ? Theme.disabledColor : Theme.primaryColor)
                    .foregroundColor(.white)
            }
            
        }
        .frame(width: 342, height: 243)
        .background(Theme.backgroundColor)
        .cornerRadius(12)
        .shadow(radius: 20)
        .transition(.scale)
        .alert("제출완료", isPresented: $showSubmitAlert) {
            Button("확인", role: .cancel) {
                showModal = false
            }
        } message: {
            Text("소중한 의견 감사합니다.")
        }
    }
    
    func sendTextFeedBack() {
        if (inputText.isEmpty){return}
        
        submittedText = inputText
        
        
        let TextFeedBackData = TextFeedBackJson(
            comment: submittedText,
            clientId: ClientIDManager.getClientID(),
            createdAt: formatDate(Date())
        )
        
        sendPostRequest(to: "/api/v1/feedbacks/comments", with: TextFeedBackData){ result in
            switch result {
            case .success(_):
                showSubmitAlert = true
            case .failure(_):
                showModal = false
                break
            }
        }
        
        
    }
}
