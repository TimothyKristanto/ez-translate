//
//  TranslationView.swift
//  EzTranslate
//
//  Created by Timothy on 19/10/23.
//

import SwiftUI

struct TranslationView: View {
	@ObservedObject var translationViewModel = TranslationViewModel()
	@State var selectedSourceLanguage = "English"
	@State var selectedTargetLanguage = "Indonesian"
	
	@StateObject var speechRecognizer = SpeechRecognizer()
	@State private var isRecording = false
	
	var languages = ["English", "Indonesian"]
	
	func convertToCode(language: String) -> String {
		switch(language) {
			case "English":
				return "en"
			case "Indonesian":
				return "id"
			default:
				return ""
		}
	}
	
	func translate() {
		let sourceLang = convertToCode(language: selectedSourceLanguage)
		let targetLang = convertToCode(language: selectedTargetLanguage)
		
		translationViewModel.postTranslate(sentence: speechRecognizer.transcript, sourceLang: sourceLang, targetLang: targetLang)
	}
	
	var body: some View {
		VStack{
			HStack{
				Picker("Source language...", selection: $selectedSourceLanguage) {
					ForEach(languages, id: \.self) {
						Text($0)
					}
				}
				
				TextField("Enter text...", text: $speechRecognizer.transcript)
			}
			.padding(.horizontal, 5)
			
			HStack{
				Picker("Target language...", selection: $selectedTargetLanguage) {
					ForEach(languages, id: \.self) {
						Text($0)
					}
				}
				
				Text("\(translationViewModel.translationModel.translate_result)")
				
				Spacer()
			}
			.padding(.horizontal, 5)
			
			Button {
				translate()
			} label: {
				Text("Translate")
			}
			.padding(10)
			.background(.blue)
			.clipShape(RoundedRectangle(cornerRadius: 17))
			.foregroundColor(.white)
			.padding(.top, 30)
			
			Button {
				if !isRecording {
					speechRecognizer.transcribe()
				} else {
					speechRecognizer.stopTranscribing()
				}
				
				isRecording.toggle()
			} label: {
				Text(isRecording ? "Stop" : "Speak")
			}
			.padding(10)
			.foregroundColor(.white)
			.background(isRecording ? .red : .blue)
			.clipShape(RoundedRectangle(cornerRadius: 17))
			.padding(.top, 10)
			
//			Text("Speech recognition: \(speechRecognizer.transcript)")
//				.font(.callout)
//				.padding(.top, 30)
		}
	}
}

#Preview {
    TranslationView()
}
