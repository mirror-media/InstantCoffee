
import SwiftUI

@main
struct InstantCoffee_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            HomePageView(header: mockHeader, stories: [mockRSS])
        }
    }
}
