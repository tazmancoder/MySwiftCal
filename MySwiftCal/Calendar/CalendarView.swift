//
//  CalendarView.swift
//  MySwiftCal
//
//  Created by Mark Perryman on 6/28/24.
//

import SwiftUI
import WidgetKit
import SwiftData

struct CalendarView: View {
	// MARK: - Environment
	@Environment(\.modelContext) var mc
	
	// MARK: - Data Properites
	@Query(filter: #Predicate<Day> { $0.date >= startDate && $0.date < endDate }, sort: \Day.date)
	var days: [Day]
	
	static var startDate: Date { .now.startOfCalendarWithPrefixDays }
	static var endDate: Date { .now.endOfMonth }
	
	var body: some View {
		NavigationView {
			VStack {
				CalendarHeaderView()
				
				LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
					ForEach(days) { day in
						if day.date.monthInt != Date().monthInt {
							// Make this text view blank to hide the prefix days
							Text("")
						} else {
							Text(day.date.formatted(.dateTime.day(.defaultDigits)))
								.fontWeight(.bold)
								.foregroundStyle(day.didStudy ? .orange : .secondary)
								.frame(maxWidth: .infinity, minHeight: 40)
								.background(
									Circle()
										.foregroundStyle(.orange.opacity(day.didStudy ? 0.3 : 0.0))
								)
								.onTapGesture {
									if day.date.dayInt <= Date().dayInt {
										day.didStudy.toggle()
										// Update the widget everytime user taps a date
										WidgetCenter.shared.reloadTimelines(ofKind: "SwiftCalWidget")
									} else {
										print("⚠️ - You can't study in the future")
									}
								}
						}
					}
				}
				
				Spacer()
				
				
			}
			.navigationTitle(Date().formatted(.dateTime.month(.wide)))
			.padding()
			.onAppear {
				if days.isEmpty {
					createMonthDays(for: .now.startOfPreviousMonth)
					createMonthDays(for: .now)
				} else if days.count < 10 { // Is this ONLY the prefix days
					createMonthDays(for: .now)
				}
			}
		}
	}
	
	func createMonthDays(for date: Date) {
		for dayOffSet in 0..<date.numberOfDaysInMonth {
			let date = Calendar.current.date(byAdding: .day, value: dayOffSet, to: date.startOfMonth)!
			let newDay = Day(date: date, didStudy: false)
			mc.insert(newDay)
		}
	}
}

#Preview {
	CalendarView()
}

