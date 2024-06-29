//
//  Date+Ext.swift
//  MySwiftCal
//
//  Created by Mark Perryman on 6/28/24.
//

import Foundation

extension Date {
	var startOfMonth: Date {
		Calendar.current.dateInterval(of: .month, for: self)!.start
	}
	
	var endOfMonth: Date {
		Calendar.current.dateInterval(of: .month, for: self)!.end
	}
	
	var endOfDay: Date {
		Calendar.current.dateInterval(of: .day, for: self)!.end
	}
	
	var startOfPreviousMonth: Date {
		let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
		return dayInPreviousMonth.startOfMonth
	}
	
	var startOfNextMonth: Date {
		let dayInNextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self)!
		return dayInNextMonth.startOfMonth
	}
	
	var numberOfDaysInMonth: Int {
		// endOfMonth returns the 1st of next month at midnight.
		// An adjustment of -1 is necessary to get last day of current month
		let endDateAdjustment = Calendar.current.date(byAdding: .day, value: -1, to: self.endOfMonth)!
		return Calendar.current.component(.day, from: endDateAdjustment)
	}
	
	var dayInt: Int {
		Calendar.current.component(.day, from: self)
	}
	
	var monthInt: Int {
		Calendar.current.component(.month, from: self)
	}
	
	var monthFullName: String {
		self.formatted(.dateTime.month(.wide))
	}
	
	// This will return the number of prefix days from the the previous month
	// allowing our calendar to push the first day of current month onto the
	// correct starting day.
	var startOfCalendarWithPrefixDays: Date {
		let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
		let numberOfPrefixDays = startOfMonthWeekday - 1
		let startDate = Calendar.current.date(byAdding: .day, value: -numberOfPrefixDays, to: startOfMonth)!
		return startDate
	}
}

