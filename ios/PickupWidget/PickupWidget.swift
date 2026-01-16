import SwiftUI
import WidgetKit

private let widgetGroupId = "group.com.example.pickupCodeFront"

struct PickupItem: Identifiable {
  let id = UUID()
  let codeDisplay: String
  let station: String
  let expire: String
  let rawCode: String
}

struct PickupEntry: TimelineEntry {
  let date: Date
  let pendingCount: Int
  let items: [PickupItem]
}

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> PickupEntry {
    PickupEntry(
      date: Date(),
      pendingCount: 0,
      items: []
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (PickupEntry) -> Void) {
    completion(loadEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PickupEntry>) -> Void) {
    let entry = loadEntry()
    completion(Timeline(entries: [entry], policy: .atEnd))
  }

  private func loadEntry() -> PickupEntry {
    let data = UserDefaults(suiteName: widgetGroupId)
    let pendingCount = data?.integer(forKey: "widget_pending_count") ?? 0
    var items: [PickupItem] = []
    for index in 0..<3 {
      let codeDisplay = data?.string(forKey: "widget_item_\(index)_code_display") ?? ""
      if codeDisplay.isEmpty {
        continue
      }
      let station = data?.string(forKey: "widget_item_\(index)_station") ?? ""
      let expire = data?.string(forKey: "widget_item_\(index)_expire") ?? ""
      let rawCode = data?.string(forKey: "widget_item_\(index)_code_raw") ?? ""
      items.append(
        PickupItem(
          codeDisplay: codeDisplay,
          station: station,
          expire: expire,
          rawCode: rawCode
        )
      )
    }
    return PickupEntry(date: Date(), pendingCount: pendingCount, items: items)
  }
}

struct PickupWidgetEntryView: View {
  let entry: Provider.Entry

  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text("待取件")
        .font(.headline)
      Text("\(entry.pendingCount) 件待取")
        .font(.caption)
        .foregroundColor(.secondary)

      if entry.items.isEmpty {
        Text("暂无待取")
          .font(.caption)
          .foregroundColor(.secondary)
          .padding(.top, 6)
      } else {
        ForEach(entry.items.prefix(3)) { item in
          Link(destination: detailUrl(code: item.rawCode)) {
            VStack(alignment: .leading, spacing: 2) {
              Text(item.codeDisplay)
                .font(.subheadline)
                .bold()
              Text(metaText(station: item.station, expire: item.expire))
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
      }
      Spacer(minLength: 0)
    }
    .padding()
    .widgetURL(URL(string: "pickup://list"))
  }

  private func metaText(station: String, expire: String) -> String {
    if !station.isEmpty && !expire.isEmpty {
      return "\(station) · \(expire)"
    }
    return station.isEmpty ? expire : station
  }

  private func detailUrl(code: String) -> URL {
    if code.isEmpty {
      return URL(string: "pickup://list")!
    }
    let encoded = code.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? code
    return URL(string: "pickup://detail?code=\(encoded)")!
  }
}

@main
struct PickupWidget: Widget {
  let kind: String = "PickupWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      PickupWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("待取件")
    .description("展示 1~3 条待取摘要")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}

struct PickupWidget_Previews: PreviewProvider {
  static var previews: some View {
    PickupWidgetEntryView(
      entry: PickupEntry(
        date: Date(),
        pendingCount: 2,
        items: [
          PickupItem(codeDisplay: "****1234", station: "驿站A", expire: "01-16 18:00", rawCode: "1234"),
          PickupItem(codeDisplay: "****5678", station: "驿站B", expire: "01-17 12:00", rawCode: "5678")
        ]
      )
    )
    .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
