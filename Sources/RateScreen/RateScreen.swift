import SwiftUI

struct RateScreen: View {
    
    private let columns = [GridItem(.flexible())]
    @State private var selectedDateStart = Date()
    @State private var selectedDateEnd = Date()
    @State private var reload = false
    
    @State private var conversion2Results: [ConvertResult] = []
    @State private var conversion3Results: [ConvertResult] = []
    @State private var conversion4Results: [ConvertResult] = []
    
    private let titles = ["Date", "#1", "#2", "#3"]
    
    private var currencyApi = CurrencyApi()
    
    private var dateRange: [String] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        
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
                            .onChange(of: selectedDateStart) { _ in
                                reload.toggle()
                                triggerConversions()
                            }
                            
                            Spacer(minLength: 80)
                            
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
                            .onChange(of: selectedDateEnd) { _ in
                                reload.toggle()
                                triggerConversions()
                            }
                            
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
                        
                        HStack(spacing: 10) {
                            // Date rows
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(dateRange.indices, id: \.self) { index in
                                    Text(dateRange[index])
                                        .frame(width: 80, height: 40)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        .foregroundColor(.black)
                                }
                            }
                            
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(dateRange.indices, id: \.self) { index in
                                    if index < conversion2Results.count {
                                        Text("\(conversion2Results[index].result)")
                                            .frame(width: 80, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .foregroundColor(.black)
                                    } else {
                                        Text("")
                                            .frame(width: 80, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(dateRange.indices, id: \.self) { index in
                                    if index < conversion3Results.count {
                                        Text("\(conversion3Results[index].result)")
                                            .frame(width: 80, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .foregroundColor(.black)
                                    } else {
                                        Text("")
                                            .frame(width: 80, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                            
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(dateRange.indices, id: \.self) { index in
                                    if index < conversion4Results.count {
                                        Text("\(conversion4Results[index].result)")
                                            .frame(width: 80, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .foregroundColor(.black)
                                    } else {
                                        Text("")
                                            .frame(width: 80, height: 40)
                                            .background(Color.white)
                                            .cornerRadius(5)
                                            .foregroundColor(.black)
                                    }
                                }
                            }
                        }
                        .padding(15)
                        
                    }
                }
            }
            .navigationBarTitle("Rate History", displayMode: .inline)
        }
    }
    
    private func triggerConversions() {
        CurrencyApiWrapper(
            currencyApi: currencyApi,
            onConversion2Completed: { results in
                
                self.conversion2Results = results
            },
            onConversion3Completed: { results in
                self.conversion3Results = results
            },
            onConversion4Completed: { results in
                self.conversion4Results = results
            }
        ).performConversions(for: dateRange)
    }
}

struct RateScreen_Previews: PreviewProvider {
    static var previews: some View {
        RateScreen()
    }
}
