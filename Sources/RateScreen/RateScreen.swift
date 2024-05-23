import SwiftUI

struct RateScreen: View {
    
    private let columns = [GridItem(.flexible())]
    @State private var selectedDateStart = Date()
    @State private var selectedDateEnd = Date()
    
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
                
                ScrollView {
                    GeometryReader { geometry in
                        VStack {
                            
                            Spacer(minLength: 30)
                            
                            HStack{
                                DatePicker(
                                    "",
                                    selection: $selectedDateStart,
                                    displayedComponents: [.date]
                                )
                                .background(Color.white)
                                .padding()
                                .cornerRadius(5)
                                
                                DatePicker(
                                    "",
                                    selection: $selectedDateEnd,
                                    displayedComponents: [.date]
                                )
                                .background(Color.white)
                                .padding()
                                .cornerRadius(5)
                            }
                            
                            Spacer(minLength: 40)
                            
                            LazyHGrid(rows: columns, spacing: 5) {
                                ForEach(0..<4) { index in
                                    Text("Item \(index)")
                                        .frame(width: geometry.size.width / 4 - 8, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                }
                            }
                            .padding()
                            
                            HStack(spacing: 10) {
                                LazyVGrid(columns: columns, spacing: 1) {
                                    ForEach(0..<12) { index in
                                        Text("Item \(index)")
                                            .frame(width: geometry.size.width / 4 - 20, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                    }
                                }
                                LazyVGrid(columns: columns, spacing: 1) {
                                    ForEach(0..<12) { index in
                                        Text("Item \(index)")
                                            .frame(width: geometry.size.width / 4 - 20, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                    }
                                }
                                LazyVGrid(columns: columns, spacing: 1) {
                                    ForEach(0..<12) { index in
                                        Text("Item \(index)")
                                            .frame(width: geometry.size.width / 4 - 20, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                    }
                                }
                                LazyVGrid(columns: columns, spacing: 1) {
                                    ForEach(0..<12) { index in
                                        Text("Item \(index)")
                                            .frame(width: geometry.size.width / 4 - 20, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
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
