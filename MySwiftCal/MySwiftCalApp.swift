//
//  MySwiftCalApp.swift
//  MySwiftCal
//
//  Created by Mark Perryman on 6/28/24.
//

import SwiftUI
import SwiftData

@main
struct MySwiftCalApp: App {
	// This is how we go from our widget to somewhere in our app
	@State private var selectedTab = 0
	
	var body: some Scene {
		WindowGroup {
			TabView(selection: $selectedTab) {
				CalendarView()
					.tabItem { Label("Calendar", systemImage: "calendar") }
					.tag(0)
				
				StreakView()
					.tabItem { Label("Streak", systemImage: "swift") }
					.tag(1)
			}
			.modelContainer(Persistence.container)
			.onOpenURL { url in
				// If you have more links you may want to do a switch statement, since we only
				// 2 links we are using a tenary operator to go to the tab selected.
				//				switch url.absoluteString {
				//					case "calendar":
				//						selectedTab = 0
				//					case "streak":
				//						selectedTab = 1
				//					default:
				//						selectedTab = 0
				//				}
				selectedTab = url.absoluteString == "calendar" ? 0 : 1
			}
		}
	}

}
