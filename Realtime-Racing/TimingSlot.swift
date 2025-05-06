import SwiftUI

struct TimingSlot: View {
    let label: String
    let time: Double?

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.f1Red)
            Text(time != nil ? String(format: "%.3f", time!) : "--.--")
                .font(.subheadline)
                .foregroundColor(.f1White)
        }
        .frame(width: 60)
    }
}


