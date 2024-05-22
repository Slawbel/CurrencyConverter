import SwiftUI

struct RateScreen: View {
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea(.all)
                
                List {
                    Text("Hello")
                    Text("Bye")
                }
                .listStyle(PlainListStyle())
                .padding()
            }
            .navigationBarTitle("Rate History", displayMode: .inline)
        }
    }
}

struct RateScreen_Previews: PreviewProvider {
    static var previews: some View {
        RateScreen()
    }
}
