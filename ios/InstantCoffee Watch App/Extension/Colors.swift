
import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

var headersColor = [
  "member": 0x000000,
  "news": 0x61B8C6,
  "entertainment": 0xD43E96,
  "businessmoney": 0x07B53B,
  "people": 0xE8C15E,
  "videohub": 0xB9B9B9,
  "international": 0x911F56,
  "foodtravel": 0xFF9598,
  "mafalda": 0x8F39CE,
  "culture": 0xA8CF68,
  "carandwatch": 0x1877F2,
  "external": 0x2ECDA7,
  "mirrorcolumn": 0xB79479,
  "life": 0x2ECDA7,
]
