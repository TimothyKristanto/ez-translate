//
//  TranslationView.swift
//  EzTranslate
//
//  Created by Timothy on 19/10/23.
//

import SwiftUI

struct TranslationView: View {
	@ObservedObject var translationViewModel = TranslationViewModel()
	@State var sentence = ""
	@State var selectedSourceLanguage = "English"
	@State var selectedTargetLanguage = "Indonesian"
	
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
		
		translationViewModel.postTranslate(sentence: sentence, sourceLang: sourceLang, targetLang: targetLang)
	}
	
	var body: some View {
		VStack{
			HStack{
				Picker("Source language...", selection: $selectedSourceLanguage) {
					ForEach(languages, id: \.self) {
						Text($0)
					}
				}
				
				TextField("Enter text...", text: $sentence)
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
					.padding(10)
					.background(.blue)
					.clipShape(RoundedRectangle(cornerRadius: 17))
					.foregroundColor(.white)
					.padding()
			}
			.padding(.top, 30)
		}
	}
}

#Preview {
    TranslationView()
}
