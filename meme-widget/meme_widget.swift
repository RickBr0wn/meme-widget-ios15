//
//  meme_widget.swift
//  meme-widget
//
//  Created by Rick Brown on 02/10/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), memeData: Data())
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    Task {
      let meme = try await MemeService.shared.getMeme()
      let (data, _ ) = try await URLSession.shared.data(from: meme.url)
      
      let entry = SimpleEntry(date: .now, memeData: data)
      completion(entry)
    }
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    Task {
      do {
        let meme = try await MemeService.shared.getMeme()
        let (data, _ ) = try await URLSession.shared.data(from: meme.url)
        
        let entry = SimpleEntry(date: .now, memeData: data)
        
        let timeline = Timeline(entries: [entry], policy: .after(.now.advanced(by: 15 * 60)))
        completion(timeline)
      } catch {
        
      }
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let memeData: Data
}

struct meme_widgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    if let image = UIImage(data: entry.memeData) {
      Image(uiImage: image)
        .resizable()
        .scaledToFit()
    }
  }
}

@main
struct meme_widget: Widget {
  let kind: String = "meme_widget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      meme_widgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
    .supportedFamilies([.systemLarge])
  }
}

struct meme_widget_Previews: PreviewProvider {
  static var previews: some View {
    meme_widgetEntryView(entry: SimpleEntry(date: Date(), memeData: Data()))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
