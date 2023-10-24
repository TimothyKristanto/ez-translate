//
//  TranslateViewModel.swift
//  EzTranslate
//
//  Created by Timothy on 19/10/23.
//

import Foundation

class TranslationViewModel: ObservableObject {
	@Published var translate_result: String = ""
	
	func postTranslate(sentence: String, sourceLang: String, targetLang: String) {
		guard let url = URL(string: "https://ddc4-34-82-167-159.ngrok.io") else { return }
		
		let body: [String: String] = [
			"text": sentence,
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
					let result = try JSONDecoder().decode(String.self, from: data)
					print(result)
					
					DispatchQueue.main.async {
						self.translate_result = result
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

