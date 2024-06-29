//
//  WidgetFamilyViews.swift
//  MySwiftCalWidgetExtension
//
//  Created by Mark Perryman on 6/28/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

// MARK: - UI Component for Medium Size Family
struct MediumCalendarView: View {
	// MARK: - Properties
	var entry: CalenderEntry
	var streakValue: Int
	
	// MARK: - Fixed Property
	let columns = Array(repeating: GridItem(.flexible()), count: 7)
	
	// MARK: - Computed Properties
	// Need this for AppIntents
	var today: Day {
		entry.days.filter { Calendar.current.isDate($0.date, inSameDayAs: .now)}.first ?? .init(date: .distantPast, didStudy: false)
	}
	
	var body: some View {
		HStack {
			VStack {
				Link(destination: URL(string: "streak")!) {
					VStack {
						Text("\(streakValue)")
							.font(.system(size: 70, design: .rounded))
							.bold()
							.foregroundStyle(.orange)
							.contentTransition(.numericText())
						
						Text("day streak")
							.font(.caption)
							.foregroundStyle(.secondary)
					}
				}
				
				Button(
					today.didStudy ? "Studied" :"Study",
					systemImage: today.didStudy ? "checkmark.circle" : "book",
					intent: ToggleStudyIntent(
						date: today.date
					)
				)
				.font(.caption)
				.tint(today.didStudy ? .mint : .orange)
				.controlSize(.small)
			}
			.frame(width: 90)
			
			Link(destination: URL(string: "calendar")!) {
				VStack {
					CalendarHeaderView(font: .caption)
					LazyVGrid(columns: columns, spacing: 7) {
						ForEach(entry.days) { day in
							if day.date.monthInt != Date().monthInt {
								// Make this text view blank to hide the prefix days
								Text(" ")
							} else {
								Text(day.date.formatted(.dateTime.day()))
									.font(.caption2)
									.bold()
									.frame(maxWidth: .infinity)
									.foregroundStyle(day.didStudy ? .orange : .secondary)
									.background(
										Circle()
											.foregroundStyle(.orange.opacity(day.didStudy ? 0.3 : 0.0))
											.scaleEffect(1.5)
									)
							}
						}
					}
				}
			}
			.padding(.leading, 6)
		}
	}
	
}

struct LockScreenCircularView: View {
	// MARK: - Properties
	var entry: CalenderEntry
	
	// MARK: - Computed Properties
	var currentCalendarDays: Int {
		entry.days.filter { $0.date.monthInt == Date().monthInt }.count
	}
	
	var daysStudied: Int {
		entry.days.filter { $0.date.monthInt == Date().monthInt }
			.filter { $0.didStudy }.count
	}
	
	var body: some View {
		Gauge(
			value: Double(daysStudied),
			in: 0...Double(currentCalendarDays),
			label: { Image(systemName: "swift") },
			currentValueLabel: { Text("\(daysStudied)") }
		)
		.gaugeStyle(.accessoryCircular)
	}
}

struct LockScreenRectangularView: View {
	// MARK: - Properties
	var entry: CalenderEntry
	
	// MARK: - Fixed Property
	let columns = Array(repeating: GridItem(.flexible()), count: 7)
	
	// MARK: - Computed Properties
	// Need this for AppIntents
	var today: Day {
		entry.days.filter { Calendar.current.isDate($0.date, inSameDayAs: .now)}.first ?? .init(date: .distantPast, didStudy: false)
	}
	
	var body: some View {
		LazyVGrid(columns: columns, spacing: 4) {
			ForEach(entry.days) { day in
				if day.date.monthInt != Date().monthInt {
					// Make this text view blank to hide the prefix days
					Text(" ")
						.font(.system(size: 7))
				} else {
					if day.didStudy {
						Image(systemName: "swift")
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: 7, height: 7)
					} else {
						Text(day.date.formatted(.dateTime.day()))
							.font(.system(size: 7))
							.frame(maxWidth: .infinity)
					}
				}
			}
		}
	}
}


