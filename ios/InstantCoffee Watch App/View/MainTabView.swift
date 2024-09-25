
import SwiftUI

struct MainTabView: View {
    @State var headers: [Header] = []
    @State private var stories: [RSSItem] = []
    @State private var storiesByCategory: [String: [RSSItem]] = [:]
    @State private var categoryToSectionMap: [String: String] = [:]
    @State private var errorMessage: String?
    let storyURL = URL(string: Bundle.main.infoDictionary!["storyURL"] as! String)

    func getRSSItems() async {
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
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
                else if headers.isEmpty {
                    ProgressView("正在載入分類...")
                } else if storiesByCategory.isEmpty {
                    ProgressView("正在載入新聞...")
                } else {
                    ForEach(headers) { header in
                        if let stories = storiesByCategory[header.name] {
                            HomePageView(header: header, stories: stories)
                        }
                    }
                }
            }
            .navigationTitle("鏡週刊")
        }
        .onAppear {
            Task {
                do {
                    let (fetchedHeaders, map) = try await fetchHeaders()
                    headers = Array(fetchedHeaders.dropFirst())
                    categoryToSectionMap = map
                    await getRSSItems()
                } catch {
                    errorMessage = "載入失敗: \n\(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}
