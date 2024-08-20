
import SwiftUI

struct ListCellView: View {
    
    let story: RSSItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(story.title ?? "")
                .font(.headline)
            Text(story.date)
                .font(.footnote)
                .foregroundStyle(.gray)
        }
    }
}

#Preview {
    ListCellView(story: mockRSS)
}
