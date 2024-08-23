import Foundation
import SwiftUI

struct Response: Decodable {
    let headers: [Header]
}

struct Header: Decodable, Identifiable {
    let order: Int
    var id: Int { order }
    let type: String
    let slug: String
    let name: String
    let categories: [Category]?
    let sections: [String]?
    
    var sectionSlug: String {
        return type == "section" ? slug : sections![0]
    }
    
    var color: Color {
        return Color(hex: headersColor[sectionSlug]!)
    }
    
}

struct Category: Decodable {
    var id: String
    let slug: String
    let name: String
}

func fetchHeaders() async throws -> ([Header], [String: String]) {
    let url = URL(string: Bundle.main.infoDictionary!["headerURL"] as! String)
    let (data, _) = try await URLSession.shared.data(from: url!)
    let response = try JSONDecoder().decode(Response.self, from: data)
    
    var categoryToSectionMap: [String: String] = [:] // [category: section]
    
    for header in response.headers {
        if header.type == "section" {
            if let categories = header.categories, !categories.isEmpty {
                for category in categories {
                    categoryToSectionMap[category.name] = header.name
                }
            } else { // when category is empty
                categoryToSectionMap[header.name] = header.name
            }
        } else if header.type == "category" { // when header is category
            categoryToSectionMap[header.name] = header.name
        }
    }
    
    return (response.headers, categoryToSectionMap)
}

