//
//  TranslateViewModel.swift
//  EzTranslate
//
//  Created by Timothy on 19/10/23.
//

import Foundation

class TranslationViewModel: ObservableObject {
	@Published var translationModel: TranslationModel = TranslationModel()
	
	func postTranslate(sentence: String, sourceLang: String, targetLang: String) {
		guard let url = URL(string: "http://127.0.0.1:5000/translate") else { return }
		
		let body: [String: String] = [
			"sentence": sentence,
			"target_lang": targetLang,
			"source_lang": sourceLang
		]
		
		let finalData = try! JSONSerialization.data(withJSONObject: body)
		
		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.httpBody = finalData
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		URLSession.shared.dataTask(with: request) { (data, res, err) in
			
			do {
				if let data = data {
					let result = try JSONDecoder().decode(TranslationModel.self, from: data)
					print(result)
					
					DispatchQueue.main.async {
						self.translationModel = result
					}
				} else {
					print("No data!")
				}
			} catch (let error) {
				print(String(describing: error))
			}
		}.resume()
	}
}

