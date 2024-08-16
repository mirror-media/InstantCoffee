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

func fetchHeaders() async throws -> [Header] {
    let url = URL(string: Bundle.main.infoDictionary!["headerURL"] as! String)
    let (data, _) = try await URLSession.shared.data(from: url!)
    let response = try JSONDecoder().decode(Response.self, from: data)

    return response.headers
}

