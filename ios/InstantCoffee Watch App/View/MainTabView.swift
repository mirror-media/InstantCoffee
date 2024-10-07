
import SwiftUI

struct MainTabView: View {
    @State var headers: [Header] = []
    @State private var stories: [RSSItem] = []
    @State private var storiesByCategory: [String: [RSSItem]] = [:]
    @State private var categoryToSectionMap: [String: String] = [:]
    @State private var errorMessage: String?
    @State private var retryTask = false
    let storyURL = URL(string: Bundle.main.infoDictionary!["storyURL"] as! String)
    let mafURL = URL(string: Bundle.main.infoDictionary!["mafURL"] as! String)

    func getRSSItems() async {
        let rssParser = RSSParser()
        let mafParser = MafRSSParser()

        guard let storyURL = storyURL else { return }
        rssParser.parse(from: storyURL) { items in
            self.stories = items
            self.storiesByCategory = organizeStoriesByCategory(stories: items, headers: self.headers, categoryToSectionMap: self.categoryToSectionMap)

            guard let mafURL = mafURL else { return }
            mafParser.parse(from: mafURL) { mafItems in
                self.storiesByCategory["瑪法達"] = mafItems
            }
        }
    }

    var body: some View {
        NavigationStack {
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
                Button("Retry") {
                    retryTask.toggle()
                }
                .controlSize(.small)
                .buttonStyle(.borderedProminent)
                .padding()
            }
            else if headers.isEmpty {
                ProgressView("正在載入分類...")
            } else if storiesByCategory.isEmpty {
                ProgressView("正在載入新聞...")
            } else {
                TabView {
                    ForEach(headers) { header in
                        if let stories = storiesByCategory[header.name] {
                            HomePageView(header: header, stories: stories)
                        }
                    }
                }
                .navigationTitle("鏡週刊")
            }
        }
        .task(id: retryTask) {
            do {
                let (fetchedHeaders, map) = try await fetchHeaders()
                headers = Array(fetchedHeaders.dropFirst())
                categoryToSectionMap = map
                await getRSSItems()
            } catch {
                errorMessage = "載入失敗: \n\(error)"
            }
        }
    }
}

#Preview {
    MainTabView()
}
