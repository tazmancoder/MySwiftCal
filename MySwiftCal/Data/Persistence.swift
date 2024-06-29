//
//  Persistence.swift
//  MySwiftCal
//
//  Created by Mark Perryman on 6/28/24.
//

import Foundation
import SwiftData

struct Persistence {
	static var container: ModelContainer {
		let container: ModelContainer = {
			let sharedStoreURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.tazmancoder.MySwiftCal")!.appendingPathComponent("SwiftCal.sqlite")
			let config = ModelConfiguration(url: sharedStoreURL)
			return try! ModelContainer(for: Day.self, configurations: config)
		}()
		
		return container
	}
}
