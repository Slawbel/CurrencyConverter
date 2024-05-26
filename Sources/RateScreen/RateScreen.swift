import SwiftUI

struct RateScreen: View {
    
    private let columns = [GridItem(.flexible())]
    @State private var selectedDateStart = Date()
    @State private var selectedDateEnd = Date()
    @State private var reload = false
    
    var chosenCurShortName: String
    var chosenCurShortName1: String
    var chosenCurShortName2: String?
    var chosenCurShortName3: String?
    var apiInputTF: String
    
    @State private var conversion2Results: [String] = []
    @State private var conversion3Results: [String] = []
    @State private var conversion4Results: [String] = []
    
    let currencyApi = CurrencyApi()
    
    private let titles = ["Date", "#1", "#2", "#3"]
    
    private var converterScreen = ConverterScreen()
    
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
    
    init(chosenCurShortName: String, chosenCurShortName1: String, chosenCurShortName2: String?, chosenCurShortName3: String?, apiInputTF: String) {
        self.chosenCurShortName = chosenCurShortName
        self.chosenCurShortName1 = chosenCurShortName1
        self.chosenCurShortName2 = chosenCurShortName2
        self.chosenCurShortName3 = chosenCurShortName3
        self.apiInputTF = apiInputTF
        
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
                                ForEach(conversion2Results.indices, id: \.self) { index in
                                    if index < conversion2Results.count {
                                        Text(conversion2Results[index])
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
                                ForEach(conversion3Results.indices, id: \.self) { index in
                                    if index < conversion3Results.count {
                                        Text(conversion3Results[index])
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
                                ForEach(conversion4Results.indices, id: \.self) { index in
                                    if index < conversion4Results.count {
                                        Text(conversion4Results[index])
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
            .onAppear {
                triggerConversions()
            }
        }
    }
    
    private func triggerConversions() {
        currencyApi.apiChosenCurShortName1 = self.chosenCurShortName
        currencyApi.apiChosenCurShortName2 = self.chosenCurShortName1
        currencyApi.apiChosenCurShortName3 = self.chosenCurShortName2
        currencyApi.apiChosenCurShortName4 = self.chosenCurShortName3
        currencyApi.apiInputTF = self.apiInputTF
        
        for currentDate in dateRange {
            currencyApi.apiChosenDate = currentDate
            
            currencyApi.conversion2 { convertResult in
                DispatchQueue.main.async { [self] in
                    if let result = convertResult?.result {
                        conversion2Results.append(String(result))
                    }
                }
            }
            
            currencyApi.conversion3 { convertResult in
                DispatchQueue.main.async { [self] in
                    if let result = convertResult?.result {
                        conversion3Results.append(String(result))
                    }
                }
            }
            
            currencyApi.conversion4 { convertResult in
                DispatchQueue.main.async { [self] in
                    if let result = convertResult?.result {
                        conversion4Results.append(String(result))
                    }
                }
            }
        }
    }
}

struct RateScreen_Previews: PreviewProvider {
    static var previews: some View {
        RateScreen(chosenCurShortName: "", chosenCurShortName1: "", chosenCurShortName2: nil, chosenCurShortName3: nil, apiInputTF: "")
    }
}
