import WidgetKit
import SwiftUI

struct PrayerTimesEntry: TimelineEntry {
    let date: Date
    let prayerTimings: [String: String]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PrayerTimesEntry {
        PrayerTimesEntry(date: Date(), prayerTimings: ["fajr": "", "dhuhr": "", "asr": "", "maghrib": "", "isha": ""])
    }

    func getSnapshot(in context: Context, completion: @escaping (PrayerTimesEntry) -> ()) {
        let entry = PrayerTimesEntry(date: Date(), prayerTimings: fetchPrayerTimings())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [PrayerTimesEntry] = []
        let currentDate = Date()
        let entry = PrayerTimesEntry(date: currentDate, prayerTimings: fetchPrayerTimings())
        entries.append(entry)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    func fetchPrayerTimings() -> [String: String] {
        let userDefaults = UserDefaults(suiteName: "group.com.yourcompany.prayertimings")
        return [
            "fajr": userDefaults?.string(forKey: "fajr") ?? "",
            "dhuhr": userDefaults?.string(forKey: "dhuhr") ?? "",
            "asr": userDefaults?.string(forKey: "asr") ?? "",
            "maghrib": userDefaults?.string(forKey: "maghrib") ?? "",
            "isha": userDefaults?.string(forKey: "isha") ?? "",
        ]
    }
}

struct PrayerTimesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("Prayer Times")
                .font(.headline)
            ForEach(entry.prayerTimings.keys.sorted(), id: \.self) { key in
                Text("\(key.capitalized): \(entry.prayerTimings[key]!)")
            }
        }
        .padding()
    }
}

@main
struct PrayerTimesWidget: Widget {
    let kind: String = "PrayerTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PrayerTimesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Prayer Times")
        .description("Displays the prayer times.")
    }
}
