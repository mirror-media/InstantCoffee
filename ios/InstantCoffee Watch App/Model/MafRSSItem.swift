import Foundation

class MafRSSParser: NSObject, XMLParserDelegate {

    var items: [RSSItem] = []
    var currentItem: RSSItem?
    var currentElement: String?
    var isInContents: Bool = false

    func parse(from url: URL, completion: @escaping ([RSSItem]) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion([])
                return
            }

            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            completion(self.items)
        }.resume()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName

        if currentElement == "article" {
            currentItem = RSSItem()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {

        switch currentElement {
            case "title":
                guard currentItem?.title != nil else {
                    currentItem?.title = string
                    return
                }

            case "url":
                guard currentItem?.imageUrl != nil else {
                    currentItem?.imageUrl = string
                    return
                }

            case "content":
                guard currentItem?.description != nil else {
                    currentItem?.description = extractFirstParagraph(from: string)
                    //                    print(currentItem?.description)
                    return
                }

            default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "text", let currentItem = currentItem {
            let uuid = UUID().uuidString
            self.items.append(RSSItem(id: uuid, title: currentItem.title, description: currentItem.description, category: "瑪法達", pubDate: currentItem.pubDate, imageUrl: currentItem.imageUrl))
            self.currentItem = nil

            isInContents = false
        }
    }

    func extractFirstParagraph(from content: String) -> String? {
        let pattern = "<p>(.*?)</p>"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: content.utf16.count)
        if let match = regex.firstMatch(in: content, options: [], range: range) {
            let paragraphRange = Range(match.range(at: 1), in: content)!
            return String(content[paragraphRange])
        }
        return nil
    }
}
