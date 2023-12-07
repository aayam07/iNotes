//
//  iNotesWidget.swift
//  iNotesWidget
//
//  Created by Aayam Adhikari on 07/12/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    // to provide timeline entry representing a placeholder version of the widget
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "🧡")
    }

    // to represent current time and state of the widget
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "🧡")
        completion(entry)
    }

    // to provide an array of timeline entries for current time or any future times to update a widget
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "🧡")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct iNotesWidgetEntryView : View {
    var entry: Provider.Entry
    
    // to get the actual size (small, medium or large) of any widget instance and to understand the current widget configuration size and present different views
    @Environment(\.widgetFamily) var widgetFamily
    
    // computed property
    var fontStyle: Font {
        if widgetFamily == .systemSmall {
            return .system(.footnote, design: .rounded)
        } else {
            return .system(.headline, design: .rounded)
        }
    }

    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Emoji:")
//            Text(entry.emoji)
//        }
        
        GeometryReader { geometry in
            ZStack {
                
                backgroundGradient  // from constant file
                
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                
                Image("logo")
                    .resizable()
                    .frame(
                        width: widgetFamily != .systemSmall ? 56 : 36,
                        height: widgetFamily != .systemSmall ? 56 : 36
                    )
                    .offset(
                        x: (geometry.size.width / 2) - 20,
                        y: (geometry.size.height / -2) + 20
                    )  // to place the logo in the top right corner
                    .padding(.top, widgetFamily != .systemSmall ? 32 : 12)
                    .padding(.trailing, widgetFamily != .systemSmall ? 32 : 12)
                
                HStack {
                    Text("Go For It 💪")
                        .foregroundStyle(Color.white)  // foreground color
                        .font(fontStyle)
                        .fontWeight(.bold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4) // first padding then background
                        .background(
                            Color(red: 0, green: 0, blue: 0, opacity: 0.5)
                                .blendMode(.overlay)
                        )
                    .clipShape(Capsule())
                    
                    if widgetFamily != .systemSmall {
                        Spacer()
                    }
                    
                } //: HSTACK
                .padding()
                .offset(y: (geometry.size.height / 2) - 24)
            } //: ZSTACK
        } //: GEOMETRY READER
    }
}

// entry point of the widget
struct iNotesWidget: Widget {
    
    // StaticConfiguration has three parameters
    
    let kind: String = "iNotesWidget" // describes the type of widget since an app can have multiple widgets

    // provider conforms to the Timeline provider protocol and is used by the system to fetch widget's data
    
    // And, the view builder closure describes the SwiftUI view for displaying widget's data
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                iNotesWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                iNotesWidgetEntryView(entry: entry)
                    .padding()
                    .background()
                    
            }
        }
        .contentMarginsDisabled()
        .configurationDisplayName("iNotes Launcher")
        .description("This is a widget for the personal task manager iNotes app.")
    }
}

#Preview(as: .systemSmall) {
    iNotesWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "🧡")
    SimpleEntry(date: .now, emoji: "💪")
}

#Preview(as: .systemMedium) {
    iNotesWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "🧡")
    SimpleEntry(date: .now, emoji: "💪")
}



