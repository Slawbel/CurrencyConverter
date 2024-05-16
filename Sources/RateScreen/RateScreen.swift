import SwiftUI

struct RateScreen: View {
    var body: some View {
        NavigationView {
            List {
                Text("Hello")
            }
            .navigationBarTitle(Text("Rate History").font(.system(size: 24)))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RateScreen_Previews: PreviewProvider {
    static var previews: some View {
        RateScreen()
    }
}
