
import SwiftUI

struct ListView: View {
    
    let header: Header
    let stories: [RSSItem]
    
    var body: some View {
        
        List {
            Section(header: Text(header.name)
                .font(.headline)
                .padding(.vertical, 2)
                .padding(.horizontal, 4)
                .background(header.color)
                .clipShape(RoundedRectangle(cornerRadius: 4))) {
                    
                ForEach(stories) { story in
                    NavigationLink(destination: DigestView(header: header, story: story)) {
                        ListCellView(story: story)
                    }
                }
            }
        }
        
    }
}

#Preview {
    ListView(header: mockHeader, stories: [mockRSS, mockRSS, mockRSS])
}
