
import SwiftUI

struct HomePageView: View {
    
    let header: Header
    let stories: [RSSItem]
    @State private var backgroundImage: Image? = nil
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            Spacer()
            Text(header.name)
                .font(.headline)
                .padding(.vertical, 2)
                .padding(.horizontal, 4)
                .background(header.color)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            Text(stories.first!.title ?? "")
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
            Text(stories.first!.date ?? "")
                .foregroundStyle(header.color)
            
            NavigationLink {
                ListView(header: header, stories: stories)
                    .navigationTitle(header.name)
            } label: {
                Text("更多" + header.name)
            }
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .tint(header.color)
            .buttonStyle(BorderedProminentButtonStyle())
            .controlSize(.mini)
        }
        .padding(4)
        .background(
            AsyncImage(url: URL(string: stories.first?.imageUrl ?? "")) { phase in
                switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .clipped()
                            .overlay() {
                                LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom)
                            }
                            .opacity(0.4)
                            .edgesIgnoringSafeArea(.all)
                    case .failure(_):
                        ProgressView()
                    case .empty:
                        ProgressView()
                    default:
                        ProgressView()
                }
            }
        )
    }
}

#Preview {
    TabView {
        HomePageView(header: mockHeader, stories: [mockRSS])
    }
    .navigationTitle("鏡週刊")
}
