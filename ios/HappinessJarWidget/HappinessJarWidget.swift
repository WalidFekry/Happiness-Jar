import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), message: "رسالتك من البرطمان اليوم ستظهر هنا")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.jar.happiness")
        let jsonString = userDefaults?.string(forKey: "message_list") ?? "[]"
        let messages = decodeMessages(from: jsonString)

        // Show the first message in snapshot/preview if available
        let displayMessage = messages.first ?? userDefaults?.string(forKey: "message_text") ?? "برطمان السعادة يتمنى لك يوماً سعيداً"

        let entry = SimpleEntry(date: Date(), message: displayMessage)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        // 1. Get the list of messages saved by Flutter
        let userDefaults = UserDefaults(suiteName: "group.com.jar.happiness")
        let jsonString = userDefaults?.string(forKey: "message_list") ?? "[]"
        let messages = decodeMessages(from: jsonString)

        if messages.isEmpty {
            // Fallback if no messages are available
            let entry = SimpleEntry(date: currentDate, message: userDefaults?.string(forKey: "message_text") ?? "برطمان السعادة يتمنى لك يوماً سعيداً")
            entries.append(entry)
        } else {
            // 2. Create a timeline entry for each hour using the provided messages
            for hourOffset in 0 ..< messages.count {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, message: messages[hourOffset])
                entries.append(entry)
            }
        }

        // 3. Schedule the next timeline refresh after the last message is used
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func decodeMessages(from json: String) -> [String] {
        guard let data = json.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let message: String
}

struct HappinessJarWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            // Background Color (Matches Android #1A2745)
            Color(hex: "1A2745")
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: 6) {
                // Logo (Matches Android 46dp)
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 46, height: 46)

                // Message (Matches Android 18sp / #F3F5FA)
                Text(entry.message)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(hex: "F3F5FA"))
                    .multilineTextAlignment(.center)
                    .lineLimit(6)
                    .minimumScaleFactor(0.7)
                    .frame(maxWidth: .infinity)
            }
            .padding(10)
        }
        .widgetURL(URL(string: "happinessjar://open"))
    }
}

@main
struct HappinessJarWidget: Widget {
    let kind: String = "HappinessJarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HappinessJarWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        Color(hex: "1A2745")
                    }
            } else {
                HappinessJarWidgetEntryView(entry: entry)
                    .background(Color(hex: "1A2745"))
            }
        }
        .configurationDisplayName("برطمان السعادة")
        .description("رسائل يومية متجددة من البرطمان.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
