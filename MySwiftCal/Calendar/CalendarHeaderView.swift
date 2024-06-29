//
//  CalendarHeaderView.swift
//  MySwiftCal
//
//  Created by Mark Perryman on 6/28/24.
//

import SwiftUI

struct CalendarHeaderView: View {
	
	let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
	var font: Font = .body
	
	var body: some View {
		HStack {
			ForEach(daysOfWeek, id: \.self) { dayOfWeek in
				Text(dayOfWeek)
					.font(font)
					.fontWeight(.black)
					.foregroundStyle(.orange)
					.frame(maxWidth: .infinity)
			}
		}
	}
}

#Preview {
	CalendarHeaderView()
}
