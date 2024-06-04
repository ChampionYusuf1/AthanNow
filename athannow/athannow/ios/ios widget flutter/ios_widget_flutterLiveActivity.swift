//
//  ios_widget_flutterLiveActivity.swift
//  ios widget flutter
//
//  Created by Yusuf Ghani on 6/3/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ios_widget_flutterAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ios_widget_flutterLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ios_widget_flutterAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ios_widget_flutterAttributes {
    fileprivate static var preview: ios_widget_flutterAttributes {
        ios_widget_flutterAttributes(name: "World")
    }
}

extension ios_widget_flutterAttributes.ContentState {
    fileprivate static var smiley: ios_widget_flutterAttributes.ContentState {
        ios_widget_flutterAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ios_widget_flutterAttributes.ContentState {
         ios_widget_flutterAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ios_widget_flutterAttributes.preview) {
   ios_widget_flutterLiveActivity()
} contentStates: {
    ios_widget_flutterAttributes.ContentState.smiley
    ios_widget_flutterAttributes.ContentState.starEyes
}
