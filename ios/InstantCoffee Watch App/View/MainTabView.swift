
import SwiftUI


struct MainTabView: View {
    @State var headers: [Header] = []
    @State private var stories: [RSSItem] = []
    @State private var storiesByCategory: [String: [RSSItem]] = [:]
    
    let storyURL = URL(string: Bundle.main.infoDictionary!["storyURL"] as! String)
    
    func getRSSItems() {
        guard let url = storyURL else { return }
        let parser = RSSParser()
        parser.parse(from: url) { items in
            self.stories = items
            self.storiesByCategory = organizeStoriesByCategory(stories: items, headers: self.headers)
        }
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(headers.dropFirst()) { header in
                    
                    if let stories = storiesByCategory[header.name], !stories.isEmpty {
                        HomePageView(header: header, stories: stories)
                    }
                    
                }
            }
            .task {
                headers = (try? await fetchHeaders()) ?? []
                getRSSItems()
            }
            .navigationTitle("鏡週刊")
        }
    }
}

#Preview {
    MainTabView()
}
