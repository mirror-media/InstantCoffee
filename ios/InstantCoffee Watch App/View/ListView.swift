
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
                        VStack(alignment: .leading) {
                            Text(story.title)
                                .font(.headline)
                            Text(story.date)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        
                        
                    }
                }
        }
    }
}

#Preview {
    ListView(header: mockHeader, stories: [mockRSS, mockRSS, mockRSS])
}
