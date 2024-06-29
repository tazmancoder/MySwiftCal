//
//  Day.swift
//  MySwiftCal
//
//  Created by Mark Perryman on 6/28/24.
//

import Foundation
import SwiftData

@Model
class Day {
	var date: Date
	var didStudy: Bool
	
	init(date: Date, didStudy: Bool) {
		self.date = date
		self.didStudy = didStudy
	}
}
