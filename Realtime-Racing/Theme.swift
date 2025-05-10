import SwiftUI

extension Color {
    static let f1Red = Color(red: 1.0, green: 0.0, blue: 0.0)
    static let f1Black = Color(red: 0.05, green: 0.05, blue: 0.05)
    static let f1White = Color.white
    static let f1Grey = Color.gray.opacity(0.2)
    static let f1LightGrey = Color(red: 0.85, green: 0.85, blue: 0.85)

        init?(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0
            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

            let red = Double((rgb & 0xFF0000) >> 16) / 255
            let green = Double((rgb & 0x00FF00) >> 8) / 255
            let blue = Double(rgb & 0x0000FF) / 255

            self.init(red: red, green: green, blue: blue)
        }

}
