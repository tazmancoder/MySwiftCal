//
//  MySwiftCalWidget.swift
//  MySwiftCalWidget
//
//  Created by Mark Perryman on 6/28/24.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
	func placeholder(in context: Context) -> CalenderEntry {
		CalenderEntry(date: Date(), days: [])
	}
	
	@MainActor func getSnapshot(in context: Context, completion: @escaping (CalenderEntry) -> ()) {
		// Call fetchRequest
		let entry = CalenderEntry(date: Date(), days: fetchDays())
		completion(entry)
	}
	
	@MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
		// Generate a timeline consisting of five entries an hour apart, starting from the current date.
		let entry = CalenderEntry(date: Date(), days: fetchDays())
		let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
		completion(timeline)
	}
	
	@MainActor func fetchDays() -> [Day] {
		let startDate = Date().startOfCalendarWithPrefixDays
		let endDate = Date().endOfMonth
		let predicate = #Predicate<Day> { $0.date >= startDate && $0.date < endDate }
		let desciptor = FetchDescriptor<Day>(predicate: predicate, sortBy: [.init(\.date)])
		
		let context = ModelContext(Persistence.container)
		return try! context.fetch(desciptor)
	}
}

struct CalenderEntry: TimelineEntry {
    let date: Date
    let days: [Day]
}

struct MySwiftCalWidgetEntryView : View {
	@Environment(\.widgetFamily) var family
	var entry: CalenderEntry
	
	var body: some View {
		switch family {
		case .systemMedium:
			MediumCalendarView(entry: entry, streakValue: calculateStreak())
		case .accessoryCircular:
			LockScreenCircularView(entry: entry)
		case .accessoryRectangular:
			LockScreenRectangularView(entry: entry)
		case .accessoryInline:
			Label("Streak: \(calculateStreak()) days", systemImage: "swift")
				.widgetURL(URL(string: "streak"))
		case .systemSmall, .systemLarge, .systemExtraLarge:
			EmptyView()
		@unknown default:
			EmptyView()
		}
	}
	
	func calculateStreak() -> Int {
		guard !entry.days.isEmpty else { return 0 }
		
		let nonFutureDays = entry.days.filter { $0.date.dayInt <= Date().dayInt }
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

struct MySwiftCalWidget: Widget {
	let kind: String = "MySwiftCalWidget"
	
	var body: some WidgetConfiguration {
		StaticConfiguration(kind: kind, provider: Provider()) { entry in
			if #available(iOS 17.0, *) {
				MySwiftCalWidgetEntryView(entry: entry)
					.containerBackground(.fill.tertiary, for: .widget)
			} else {
				MySwiftCalWidgetEntryView(entry: entry)
					.padding()
					.background()
			}
		}
		.configurationDisplayName("Swift Study Calendar")
		.description("Track days you study Swift with a streak.")
		.supportedFamilies([
			.systemMedium,
			.accessoryInline,
			.accessoryCircular,
			.accessoryRectangular
		])
	}
}

#Preview(as: .systemSmall) {
    MySwiftCalWidget()
} timeline: {
	CalenderEntry(date: .now, days: [])
}
