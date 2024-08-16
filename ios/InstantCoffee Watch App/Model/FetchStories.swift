
import Foundation

struct RSSItem: Decodable, Identifiable {
    let id: String
    let title: String
    let description: String
    let category: String
    let pubDate: String
    let imageUrl: String
    
    var date: String {
        return formatDate(dateString: pubDate)
    }
    var digest: String {
        let pattern = "<[^>]+>(.*?)</[^>]+>"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: description.utf16.count)
        let descriptionWithoutPTags = regex.stringByReplacingMatches(in: description, options: [], range: range, withTemplate: "$1")
        return descriptionWithoutPTags
    }
}


class RSSParser: NSObject, XMLParserDelegate {
    
    var items: [RSSItem] = []
    var currentElement: String?
    var currentData: String = ""
    var currentID: String = ""
    var currentTitle: String = ""
    var currentDescription: String = ""
    var currentCategory: String = ""
    var currentPubDate: String = ""
    var currentImageUrl: String = ""
    
    var isInsideContentEncoded: Bool = false
    
    func parse(from url: URL, completion: @escaping ([RSSItem]) -> Void) {
        guard let parser = XMLParser(contentsOf: url) else {
            completion([])
            return
        }
        parser.delegate = self
        parser.parse()
        completion(items)
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentID = ""
            currentTitle = ""
            currentDescription = ""
            currentCategory = ""
            currentPubDate = ""
            currentImageUrl = ""
        }
        
        if elementName == "content:encoded" {
            isInsideContentEncoded = true
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "category": currentCategory += string
        case "pubDate": currentPubDate += string
        default: break
        }
        
        if isInsideContentEncoded {
            currentImageUrl += extractImageUrl(from: string) ?? ""
            isInsideContentEncoded = false
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            self.items.append(RSSItem(id: currentTitle, title: currentTitle, description: currentDescription, category: currentCategory, pubDate: currentPubDate, imageUrl: currentImageUrl))
        }
        
    }
    
    func extractImageUrl(from content: String) -> String? {
        // Use regular expression or string manipulation to extract image URL
        // Example using regular expression:
        let pattern = "<img src=\"(.*?)\""
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: content.utf16.count)
        let matches = regex.matches(in: content, options: [], range: range)
        if let match = matches.first {
            let imageUrlRange = Range(match.range(at: 1), in: content)!
            return String(content[imageUrlRange])
        }
        return nil
    }
    
}
