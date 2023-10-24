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
	
	var languages = ["English", "Indonesian", "Japanese"]
	
	func convertToCode(language: String) -> String {
		switch(language) {
			case "English":
				return "en"
			case "Indonesian":
				return "id"
			case "Japanese":
				return "jap"
			default:
				return ""
		}
	}
	
	func translate() {
		let sourceLang = convertToCode(language: selectedSourceLanguage)
		let targetLang = convertToCode(language: selectedTargetLanguage)
		
		translationViewModel.postTranslate(sentence: speechRecognizer.transcript, sourceLang: sourceLang, targetLang: targetLang)
	}
	
	func swapSourceTargetLanguages() {
		let tempSourceLanguage = selectedSourceLanguage
		
		selectedSourceLanguage = selectedTargetLanguage
		selectedTargetLanguage = tempSourceLanguage
	}
	
	func closeKeyboard() {
		UIApplication.shared.endEditing()
	}
	
	var body: some View {
		GeometryReader { reader in
			VStack {
				HStack {
					Picker("Source language...", selection: $selectedSourceLanguage) {
						ForEach(languages, id: \.self) {
							Text($0)
						}
					}
					.pickerStyle(.menu)
					.frame(width: reader.size.width / 3)
					
					Button {
						swapSourceTargetLanguages()
					} label: {
						Image(systemName: "arrow.triangle.2.circlepath")
							.resizable()
							.scaledToFit()
							.foregroundStyle(Color.black.gradient)
							.frame(width: reader.size.width / 13)
							.shadow(radius: 7)
					}
					.padding(.horizontal, reader.size.width / 25)
					.bold()
					
					Picker("Target language...", selection: $selectedTargetLanguage) {
						ForEach(languages, id: \.self) {
							Text($0)
								.bold()
						}
					}
					.frame(width: reader.size.width / 3)
				}
				.frame(width: reader.size.width / 1.1, height: reader.size.height / 15)
				.background(.white)
				.clipShape(RoundedRectangle(cornerRadius: 15))
				.padding(.top, reader.size.height / 50)
				
				VStack {
					TextField("Enter text...", text: $speechRecognizer.transcript, axis: .vertical)
						.padding(.horizontal, reader.size.width / 17)
						.padding(.vertical , reader.size.height / 35)
						.frame(width: reader.size.width / 1.1, height: reader.size.height / 3)
						.font(.title3)
					
					Divider()
					
					VStack {
						Spacer()
						
						HStack {
							Text(translationViewModel.translate_result)
								.font(.title2)
								.bold()
								.padding(.horizontal, reader.size.width / 17)
								.foregroundStyle(Color("Purple"))
							
							Spacer()
						}
						
						Spacer()
					}
					
					Spacer()
				}
				.frame(width: reader.size.width / 1.1, height: reader.size.height / 1.4)
				.background(.white)
				.clipShape(RoundedRectangle(cornerRadius: 15))
				.padding(.top, reader.size.height / 100)
				
				Spacer()
				
				HStack {
					Button {
						
					} label: {
						Image(systemName: "line.3.horizontal.decrease")
							.resizable()
							.scaledToFit()
							.frame(width: reader.size.width / 15)
							.padding(reader.size.width / 23)
							.background(Color.white.gradient)
							.clipShape(Circle())
							.foregroundStyle(.black)
					}
					.shadow(radius: 25)
					
					Button {
						translate()
					} label: {
						Image(systemName: "checkmark")
							.resizable()
							.scaledToFit()
							.frame(width: reader.size.width / 12)
							.padding(reader.size.width / 18)
							.background(Color.black.gradient)
							.clipShape(Circle())
							.foregroundStyle(.white)
					}
					.shadow(radius: 20)
					.padding(.horizontal, reader.size.width / 100)
					
					Button {
						if !isRecording {
								speechRecognizer.transcribe()
							} else {
								speechRecognizer.stopTranscribing()
							}
			
							isRecording.toggle()
					} label: {
						Image(systemName: isRecording ? "stop.fill" : "mic.fill")
							.resizable()
							.scaledToFit()
							.frame(width: reader.size.width / 20)
							.padding(reader.size.width / 25)
							.background(isRecording ? Color.red.gradient : Color.white.gradient)
							.clipShape(Circle())
							.foregroundStyle(isRecording ? .white : .black)
					}
					.shadow(radius: 20)
				}
				.padding(.bottom, reader.size.height / 150)
			}
			.position(x: reader.frame(in: .local).midX, y: reader.frame(in: .local).midY)
			.onTapGesture {
				closeKeyboard()
			}
		}
		.background(Color("LightGray"))
		.ignoresSafeArea(.keyboard)
	}
}

#Preview {
    TranslationView()
}

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
