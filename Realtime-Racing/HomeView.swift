import SwiftUI

struct HomeView: View {
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: LiveTimingView()) {
                    HomeButton(title: "Live Timing", icon: "speedometer")
                }
                NavigationLink(destination: PastSessionsView()) {
                    HomeButton(title: "Past Sessions", icon: "clock.arrow.circlepath")
                }
                NavigationLink(destination: DriverListView()) {
                    HomeButton(title: "F1 Drivers Leaderboard", icon: "person.2.fill")
                }
                Spacer()
            }
            .padding()
            .navigationTitle("🏁 F1 Timing")
            .background(Color.f1Black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct HomeButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.f1Red)
            Text(title)
                .font(.headline)
                .foregroundColor(.f1White)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.f1Grey)
        }
        .padding()
        .background(Color.f1Grey)
        .cornerRadius(10)
    }
}

#Preview {
    HomeView()
}
