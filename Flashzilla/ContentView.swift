//
//  ContentView.swift
//  Flashzilla
//
//  Created by Margarita Mayer on 10/03/24.
//

import SwiftUI

extension View {
	
	func stacked(at position: Int, in total: Int) -> some View {
		let offset = Double(total - position)
		return self.offset(x: 0, y: offset * 10)
	}
}

struct ContentView: View {
	@Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
	@Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
	@State private var cards = [Card]()
	@State private var timeRemaining = 100
	@State private var showingEditScreen = false
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	@Environment(\.scenePhase) var scenePhase
	@State private var isActive = true
	 
	var body: some View {
		ZStack {
			Image(decorative: "background")
				.resizable()
				.ignoresSafeArea()
			
			VStack {
				Text("Time is \(timeRemaining)")
					.font(.largeTitle)
					.foregroundStyle(.white)
					.padding(.horizontal, 20)
					.padding(.vertical, 5 )
					.background(.black.opacity(0.75))
					.clipShape(.capsule )
				 
				ZStack {
					ForEach(cards) { card in
						if let index = cards.firstIndex(where: {$0.id == card.id}) {
							CardView(card: card, removal: {
								removeCard(index: index)
							}, repeatition: {
								repeatCard(card: card)
							})
							
							.stacked(at: index, in: cards.count)
							//							.allowsHitTesting(index == cards.count - 1 )
							//							.accessibilityHidden(index < cards.count - 1  )
						}
					}
				}
				.allowsHitTesting(timeRemaining > 0)
				
				if cards.isEmpty {
					Button("Start again", action: resetCards)
						.padding()
						.background(.white)
						.foregroundStyle(.black)
						.clipShape(.capsule)
				}
			}
			VStack {
				HStack {
					Spacer()
					Button {
						showingEditScreen = true
//						print(cards.count)
					} label: {
						Image(systemName: "plus.circle")
							.padding()
							.background(.black.opacity(0.7))
							.clipShape(.circle)
					}
				}
				
				Spacer()
			}
			.foregroundStyle(.white)
			.font(.largeTitle)
			.padding()
			 
			
			
			if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled  {
				VStack {
					Spacer()
					HStack {
						Button {
							withAnimation {
//								removeCard(at: cards.count - 1)
							}
						} label: {
 							Image(systemName: "xmark.circle")
								.padding()
								.background(.black.opacity(0.7))
								.clipShape(.circle)
						}
						.accessibilityLabel("Wrong")
						.accessibilityHint("Mark your answer as incorrect")
						 
						
						Spacer()
						Button {
							withAnimation {
//								removeCard(at: cards.count - 1)
							}
						} label: {
							Image(systemName: "checkmark.circle")
								.padding()
								.background(.black.opacity(0.7))
								.clipShape(.circle)
						}
						.accessibilityLabel("Correct")
						.accessibilityHint("Mark your answer as incorrect ")
						
					}
					.foregroundStyle(.white)
					.font(.largeTitle)
					.padding()
				}
			}
		}
		.onReceive(timer) { time in
			guard isActive else { return  }
			if timeRemaining > 0 {
				 timeRemaining -= 1
			}
		}
		.onChange(of: scenePhase) {
			if scenePhase == .active {
				if cards.isEmpty == false {
					isActive = true
				}
		  	} else {
				isActive = false
			}
		}
		.sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init)
		.onAppear(perform: resetCards)
		
	}
	
	

	
	func removeCard(index: Int) {
		guard index >= 0 else { return }
		cards.remove(at: index)
		if cards.isEmpty {
			isActive = false
		}
	}
	
	func repeatCard(card: Card) {
		let newCard = Card(prompt: card.prompt, answer: card.answer)
		cards.insert(newCard, at: 0)
		
		if let index = cards.firstIndex(where: {$0.id == card.id}) {
			cards.remove(at: index)
		}
	}
	
	
	func resetCards() {
		loadData()
		timeRemaining = 100
		isActive = true
	}
	
//	func loadData() {
//		if let data = UserDefaults.standard.data(forKey: "Cards") {
//			if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//				  cards = decoded
//			} else {
//				print("failed")
//			}
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
	 
}

#Preview {
	ContentView()
}
