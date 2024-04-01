//
//  EditCards.swift
//  Flashzilla
//
//  Created by Margarita Mayer on 17/03/24.
//

import SwiftUI

struct EditCards: View {
	@Environment(\.dismiss) var dismiss
	@State private var cards = [Card]()
	@State private var newPrompt = ""
	@State private var newAnswer = ""
	 
    var body: some View {
		NavigationStack {
			List {
				Section("Add a new card ") {
					TextField("Prompt", text: $newPrompt)
					TextField("Answer", text: $newAnswer)
					Button("Add card", action: addCard)
				}
				
				Section {
					ForEach(cards) { card in
						VStack(alignment: .leading) {
							Text(card.prompt)
								.font(.headline)
							 
							Text(card.answer)
								.foregroundStyle(.secondary)
						}
					}
					.onDelete(perform: removeCard)
				}
			}
			.navigationTitle("Edit cards")
			.toolbar {
				 Button("Done", action: done)
			}
			.onAppear(perform: loadData)
		}
    }
	
	func done() {
		dismiss()
	}
	
//	func loadData() {
//		if let data = UserDefaults.standard.data(forKey: "Cards") {
//			if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//				  cards = decoded
//			}
//		}
//	}
	
//	func saveData() {
//		if let data = try? JSONEncoder().encode(cards) {
//			UserDefaults.standard.set(data, forKey: "Cards")
//		}
//	}
	
	func loadData() {
		
		let url = URL.documentsDirectory.appending(path: "Cards")

		do {
			let inputData = try Data(contentsOf: url)
			let decoded = try JSONDecoder().decode([Card].self, from: inputData)
			cards = decoded
//			print(decoded)
			
		} catch {
			print(error.localizedDescription)
			
		}
		
	}
	
	
	func saveData() {
		if let data = try? JSONEncoder().encode(cards) {
			let url = URL.documentsDirectory.appending(path: "Cards")
			
			do {
				try data.write(to: url, options: [.atomic, .completeFileProtection])
				
			} catch {
				print(error.localizedDescription)
			}
		}
	}
	
	func addCard() {
		let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
		let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
		guard trimmedAnswer.isEmpty == false && trimmedPrompt.isEmpty == false else { return }
		 
		let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
		cards.insert(card, at: 0)
		saveData()
		
//		newPrompt = ""
//		newAnswer = ""
	}
	
	func removeCard(at offset: IndexSet)  {
		cards.remove(atOffsets: offset)
		saveData()
	}
}

#Preview {
    EditCards()
}
