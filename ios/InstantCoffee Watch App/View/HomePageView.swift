
import SwiftUI
import CachedImage

struct HomePageView: View {
    let header: Header
    let stories: [RSSItem]
    @State private var backgroundImage: Image? = nil

    var body: some View {
        ZStack {
            // background image
            CachedImage(
                url: URL(string: stories.first?.imageUrl ?? ""),
                content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .clipped()
                        .overlay() {
                            LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom)
                        }
                        .ignoresSafeArea()
                        .opacity(0.4)
                }, placeholder: {
                    ProgressView()
                }
            )

            // foreground
            VStack(alignment: .leading, spacing: 5) {
                Spacer()
                Text(header.name)
                    .font(.headline)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .background(header.color)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                Text(stories.first!.title ?? "")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                if let date = stories.first?.date {
                    Text(date)
                        .foregroundStyle(header.color)
                }
                NavigationLink {
                    ListView(header: header, stories: stories)
                        .navigationTitle(header.name)
                } label: {
                    Text("更多" + header.name)
                }
                .controlSize(.small)
                .buttonStyle(BorderedProminentButtonStyle())
                .buttonBorderShape(.roundedRectangle(radius: 13.0))
                .tint(header.color)
            }
            .padding(4)
        }
    }
}

#Preview {
    TabView {
        HomePageView(header: mockHeader, stories: [mockRSS])
    }
    .navigationTitle("鏡週刊")
}
