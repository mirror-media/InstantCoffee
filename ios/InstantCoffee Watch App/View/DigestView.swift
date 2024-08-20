
import SwiftUI

struct DigestView: View {
    
    let header: Header
    let story: RSSItem
    
    var body: some View {
                
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                Text(header.name)
                    .font(.headline)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .background(header.color)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                Text(story.title ?? "")
                    .font(.headline)
                Text(story.date)
                    .foregroundStyle(header.color)
                Text(story.digest)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 5)
        .background(
            
            AsyncImage(url: URL(string: story.imageUrl ?? "")) { phase in
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
                        .opacity(0.24)
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
        .navigationTitle(header.name)
    }
}

#Preview {
    DigestView(header: mockHeader, story: mockRSS)
}
