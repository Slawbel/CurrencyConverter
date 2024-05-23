import SwiftUI

struct RateScreen: View {
    
    private let columns = [GridItem(.flexible())]
    @State private var selectedDateStart = Date()
    @State private var selectedDateEnd = Date()
    
    private let titles = ["Date", "#1", "#2", "#3"]
    
    private var dateRange: [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var dateArray: [String] = []
        var currentDate = calendar.startOfDay(for: selectedDateStart)
        let endDate = calendar.startOfDay(for: selectedDateEnd)
        
        while currentDate <= endDate {
            dateArray.append(dateFormatter.string(from: currentDate))
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return dateArray
    }
    
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
                    VStack {
                        
                        HStack {
                            Spacer()
                            
                            DatePicker(
                                "",
                                selection: $selectedDateStart,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .background(Color.black)
                            .accentColor(.white)
                            .padding()
                            .environment(\.colorScheme, .dark)
                            .cornerRadius(5)
                            
                            Spacer(minLength: 100)
                            
                            DatePicker(
                                "",
                                selection: $selectedDateEnd,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .background(Color.black)
                            .accentColor(.white)  // Text color
                            .padding()
                            .environment(\.colorScheme, .dark)  // Force dark mode
                            .cornerRadius(5)
                            
                            Spacer()
                        }
                        
                        // Title row
                        LazyHGrid(rows: columns, spacing: 5) {
                            ForEach(titles, id: \.self) { title in
                                Text(title)
                                    .frame(width: 80, height: 40)
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .padding(4)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                        
                        // Data rows
                        HStack(spacing: 10) {
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(0..<12) { index in
                                    Text("Item \(index)")
                                        .frame(width: 80, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .foregroundColor(.black)
                                }
                            }
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(0..<12) { index in
                                    Text("Item \(index)")
                                        .frame(width: 80, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .foregroundColor(.black)
                                }
                            }
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(0..<12) { index in
                                    Text("Item \(index)")
                                        .frame(width: 80, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .foregroundColor(.black)
                                }
                            }
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(0..<12) { index in
                                    Text("Item \(index)")
                                        .frame(width: 80, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding()
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
