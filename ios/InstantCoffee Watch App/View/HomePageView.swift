
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
            
            Text(stories.first!.date)
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
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                case .empty:
                    ProgressView()
                default:
                    ProgressView()
                }
            }
        )
    }
}

var mockHeader = Header(order: 2, type: "category", slug: "news", name: "焦點", categories: [], sections: ["news"])
var mockRSS = RSSItem(id: "2", title: "【巴黎奧運】開幕在即澳洲金牌選手裝備遭竊　車窗被砸破！小偷還吃光巧克力棒", description: "太誇張！巴黎奧運26日就要正式開幕，竟然有選手比賽裝備被偷！上屆奧運冠軍得主，澳洲的極限單車明星馬丁（Logan Martin）團隊的座車在比利時驚傳遭竊，不僅自行車包包被偷，歹徒甚至還吃光了他的巧克力棒只留下垃圾，所幸最重要的單車沒有失竊。", category: "國際要聞", pubDate: "Thu, 25 Jul 2024 16:34:00 +0800", imageUrl: "https://v3-statics.mirrormedia.mg/images/c85c87f1-ffd2-4c17-98c6-c141ceef1532-w1600.png")

#Preview {
    
    TabView {
        HomePageView(header: mockHeader, stories: [mockRSS])
    }
    .navigationTitle("鏡週刊")
}
