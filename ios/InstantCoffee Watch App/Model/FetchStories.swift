
import Foundation

struct RSSItem: Decodable, Identifiable {
    var id: String?
    var title: String?
    var description: String?
    var category: String?
    var pubDate: String?
    var imageUrl: String?
    
    var date: String {
        return formatDate(dateString: pubDate ?? "")
    }
    var digest: String {
        let pattern = "<[^>]+>(.*?)</[^>]+>"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: description!.utf16.count)
        let descriptionWithoutPTags = regex.stringByReplacingMatches(in: description!, options: [], range: range, withTemplate: "$1")
        return descriptionWithoutPTags
    }
}


class RSSParser: NSObject, XMLParserDelegate {
    
    var items: [RSSItem] = []
    var currentItem: RSSItem?
    var currentElement: String?
    
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
            currentItem = RSSItem(id: "", title: "", description: "", category: "", pubDate: "", imageUrl: "")
        }
        
        if elementName == "content:encoded" {
            isInsideContentEncoded = true
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title": currentItem?.title! += string
        case "description": currentItem?.description! += string
        case "category": currentItem?.category! += string
        case "pubDate": currentItem?.pubDate! += string
        default: break
        }
        
        if isInsideContentEncoded {
            currentItem?.imageUrl! += (extractImageUrl(from: string) ?? "")
            isInsideContentEncoded = false
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item", let currentItem = currentItem {
            self.items.append(RSSItem(id: nil, title: currentItem.title, description: currentItem.description, category: currentItem.category, pubDate: currentItem.pubDate, imageUrl: currentItem.imageUrl))
        }
        
    }
    
    func extractImageUrl(from content: String) -> String? {
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
