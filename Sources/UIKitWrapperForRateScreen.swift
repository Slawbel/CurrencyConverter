import SwiftUI

struct CurrencyApiWrapper {
    let currencyApi: CurrencyApi
    let onConversion2Completed: ([ConvertResult]) -> Void
    let onConversion3Completed: ([ConvertResult]) -> Void
    let onConversion4Completed: ([ConvertResult]) -> Void
    
    func performConversions(for dates: [String]) {
        var results2: [ConvertResult] = []
        var results3: [ConvertResult] = []
        var results4: [ConvertResult] = []
        let group = DispatchGroup()
        
        for date in dates {
            currencyApi.apiChosenDate = date
            
            group.enter()
            currencyApi.conversion2 { result in
                if let result = result {
                    results2.append(result)
                }
                group.leave()
            }
            
            group.enter()
            currencyApi.conversion3 { result in
                if let result = result {
                    results3.append(result)
                }
                group.leave()
            }
            
            group.enter()
            currencyApi.conversion4 { result in
                if let result = result {
                    results4.append(result)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.onConversion2Completed(results2)
            self.onConversion3Completed(results3)
            self.onConversion4Completed(results4)
        }
    }
}
