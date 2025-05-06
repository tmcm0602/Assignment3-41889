import Foundation
import SwiftUI

struct LiveTimingRow: View {
    let position: Int
    let driverCode: String
    let teamColor: Color
    let lapTime: String?
    let gap: String?
    let interval: String?
    let tyreImage: Image
    let isPlaceholder: Bool

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
                .foregroundColor(isPlaceholder ? .gray : .green)
                .frame(width: 70, alignment: .trailing)

            Text(gap ?? "--")
                .foregroundColor(isPlaceholder ? .gray : .white)
                .frame(width: 60, alignment: .trailing)

            Text(interval ?? "--")
                .foregroundColor(isPlaceholder ? .gray : .green)
                .frame(width: 60, alignment: .trailing)

            tyreImage
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.leading, 5)
        }
        .padding(.vertical, 4)
        .background(Color.f1Black)
    }
}

