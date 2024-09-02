
import SwiftUI

struct MainTabView: View {
    @State var headers: [Header] = []
    @State private var stories: [RSSItem] = []
    @State private var storiesByCategory: [String: [RSSItem]] = [:]
    @State private var categoryToSectionMap: [String: String] = [:]
    
    let storyURL = URL(string: Bundle.main.infoDictionary!["storyURL"] as! String)
    
    func getRSSItems() {
        guard let url = storyURL else { return }
        let parser = RSSParser()
        parser.parse(from: url) { items in
            self.stories = items
            self.storiesByCategory = organizeStoriesByCategory(stories: items, headers: self.headers, categoryToSectionMap: categoryToSectionMap)
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(headers) { header in
                    if let stories = storiesByCategory[header.name] {
                        HomePageView(header: header, stories: stories)
                    }
                }
            }
            .task {
                do {
                    let (fetchedHeaders, map) = try await fetchHeaders()
                    headers = Array(fetchedHeaders.dropFirst())
                    categoryToSectionMap = map
                    getRSSItems()
                } catch {}
            }
            .navigationTitle("鏡週刊")
        }
    }
}

#Preview {
    MainTabView()
}
