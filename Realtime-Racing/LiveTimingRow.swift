import Foundation
import SwiftUI

struct LiveTimingRow: View {
    let position: Int
    let driverCode: String
    let teamColor: Color
    let lapTime: String?
    let gap: String?
    let interval: String?
    let intervalColor: Color?
    let tyreImage: Image
    let isEvenRow: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Text("\(position)")
                .foregroundColor(.white)
                .frame(width: 30, alignment: .leading)

            Rectangle()
                .fill(teamColor)
                .frame(width: 4, height: 20)

            Text(driverCode)
                .bold()
                .foregroundColor(.white)
                .frame(width: 50, alignment: .leading)

            Text(lapTime ?? "--.---")
                .foregroundColor(.white)
                .frame(width: 70, alignment: .trailing)

            Text(gap ?? "")
                .foregroundColor(.white)
                .frame(width: 60, alignment: .trailing)

            Text(interval ?? "")
                .foregroundColor(intervalColor ?? .white)
                .frame(width: 60, alignment: .trailing)

            tyreImage
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.leading, 5)
        }
        .padding(.vertical, 4)
        .background(isEvenRow ? Color.f1Black : Color(red: 0.1, green: 0.1, blue: 0.1))
        .contentShape(Rectangle())
    }
}

struct LiveTimingRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            LiveTimingRow(
                position: 1,
                driverCode: "VER",
                teamColor: Color(hex: "#0600EF") ?? .blue,
                lapTime: "1:36.123",
                gap: "",
                interval: "",
                intervalColor: .white,
                tyreImage: Image("softTyre"),
                isEvenRow: true
            )
            
            LiveTimingRow(
                position: 2,
                driverCode: "HAM",
                teamColor: Color(hex: "#00D2BE") ?? .green,
                lapTime: "1:36.456",
                gap: "+0.333",
                interval: "+0.333",
                intervalColor: .red,
                tyreImage: Image("mediumTyre"),
                isEvenRow: false
            )
        }
        .background(Color.f1Black)
        .previewLayout(.sizeThatFits)
    }
}
