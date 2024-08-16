
import Foundation

func organizeStoriesByCategory(stories: [RSSItem], headers: [Header]) -> [String: [RSSItem]] {
    var storiesByCategory: [String: [RSSItem]] = [:]
    for item in stories {
        if let headerName = findHeaderName(inputCategory: item.category, headers: headers) {
            storiesByCategory[headerName, default: []].append(item)
        }
    }
    return storiesByCategory
}

func findHeaderName(inputCategory: String, headers: [Header]) -> String? {
    // Check if input is a header or category
    let isHeader = headers.contains(where: { $0.name == inputCategory })
    
    if isHeader {
        return inputCategory // Return input if it's a header name
    } else {
        for header in headers {
            if let categories = header.categories {
                for category in categories {
                    if category.name == inputCategory {
                        return header.name // Return header name for matching category
                    }
                }
            }
        }
    }
    
    return nil
}
