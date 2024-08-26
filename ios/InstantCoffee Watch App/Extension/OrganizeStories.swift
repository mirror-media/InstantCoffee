
import Foundation

func organizeStoriesByCategory(stories: [RSSItem], headers: [Header], categoryToSectionMap: [String: String]) -> [String: [RSSItem]] {
    var storiesByHeader: [String: [RSSItem]] = [:]
    
    for story in stories {
        if let category = story.category {
            if let sectionName = categoryToSectionMap[category] {
                if storiesByHeader[sectionName] != nil {
                    storiesByHeader[sectionName]!.append(story)
                } else {
                    storiesByHeader[sectionName] = [story]
                }
            }
        }
    }
    
    return storiesByHeader
}
