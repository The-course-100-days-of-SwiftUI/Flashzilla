//
//  Card.swift
//  Flashzilla
//
//  Created by Margarita Mayer on 13/03/24.
//

import Foundation

struct Card: Codable, Identifiable  {
	 
	var prompt: String
	var answer: String
	var id = UUID()
	
	static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
