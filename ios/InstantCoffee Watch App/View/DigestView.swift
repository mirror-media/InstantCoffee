
import SwiftUI
import CachedImage

struct DigestView: View {
    
    let header: Header
    let story: RSSItem
    
    var body: some View {
        
        ZStack {
            // background image
            CachedImage(
                url: URL(string: story.imageUrl ?? ""),
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
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    Text(header.name)
                        .font(.headline)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 4)
                        .background(header.color)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    Text(story.title ?? "")
                        .font(.headline)
                    if let date = story.date {
                        Text(date)
                            .foregroundStyle(header.color)
                    }
                    Text(story.digest ?? "")
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 5)
            .navigationTitle(header.name)
        }
    }
}

#Preview {
    DigestView(header: mockHeader, story: mockRSS)
}
