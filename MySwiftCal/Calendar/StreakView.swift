//
//  StreakView.swift
//  MySwiftCal
//
//  Created by Mark Perryman on 6/28/24.
//

import SwiftUI
import SwiftData

struct StreakView: View {
	// MARK: - Data Properites
	@Query(filter: #Predicate<Day> { $0.date > startDate && $0.date < endDate }, sort: \Day.date)
	var days: [Day]
	
	static var startDate: Date { .now.startOfMonth }
	static var endDate: Date { .now.endOfMonth }
	
	// MARK: - State
	@State private var streakValue = 0
	
	var body: some View {
		VStack {
			Text("\(streakValue)")
				.font(.system(size: 200, weight: .bold, design: .rounded))
				.foregroundStyle(streakValue > 0 ? .orange : .pink)
				.contentTransition(.numericText())
				.animation(.bouncy, value: streakValue)
			
			Text("Current Streak")
				.font(.title2)
				.bold()
				.foregroundStyle(.secondary)
			
		}
		.offset(y: -50)
		.onAppear {
			streakValue = calculateStreak()
		}
	}
	
	func calculateStreak() -> Int {
		guard !days.isEmpty else { return 0 }
		
		let nonFutureDays = days.filter { $0.date.dayInt <= Date().dayInt }
		var streakCount = 0
		
		for day in nonFutureDays.reversed() {
			if day.didStudy {
				streakCount += 1
			} else {
				// Dont break streak until end of current day
				if day.date.dayInt != Date().dayInt {
					break
				}
			}
		}
		
		return streakCount
	}
}

#Preview {
	StreakView()
}
