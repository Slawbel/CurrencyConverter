import UIKit

// protocol is used as pattern for function "conversion"
protocol CurrencyApiProtocol {
    func conversion2(onCompletion: @escaping (ConvertResult) -> Void)
    func conversion3(onCompletion: @escaping (ConvertResult) -> Void)
    func conversion4(onCompletion: @escaping (ConvertResult) -> Void)
}


class CurrencyApi: CurrencyApiProtocol {
    
    // input data for conversion api request
    // amount to convert
    public var apiInputTF: String!
    // currencies to convert or to be converted
    public var apiChosenCurShortName1: String!
    public var apiChosenCurShortName2: String!
    public var apiChosenCurShortName3: String!
    public var apiChosenCurShortName4: String!
    public var apiChosenDate: String = ""

    // api to convert amount of money of currency to another one
    private func conversion(to: String!, onCompletion: @escaping (ConvertResult) -> Void) {
        let string = "https://api.apilayer.com/fixer/convert?to=" + (to ?? "") + "&from=" + (apiChosenCurShortName1 ?? "") + "&amount=" + (apiInputTF ?? "0") + "&date=" + apiChosenDate
        guard let url = URL(string: string) else {
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("mUGIIf6VCrvec8zDdJv2EofmA4euGt2z", forHTTPHeaderField: "apikey")
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                return
            }
            //print(String(data: data, encoding: .utf8)!)
            guard let convertResult = ConvertResult(from: data) else {
                return
            }
            DispatchQueue.main.async {
                onCompletion(convertResult)
            }
        }
        task.resume()
    }
    
    // those functions help to convert chosen currency from three below to currency "apiChosenCurShortName1"
    public func conversion2(onCompletion: @escaping (ConvertResult) -> Void) {
        conversion(to: apiChosenCurShortName2, onCompletion: onCompletion)
    }
    public func conversion3(onCompletion: @escaping (ConvertResult) -> Void) {
        conversion(to: apiChosenCurShortName3, onCompletion: onCompletion)
    }
    public func conversion4(onCompletion: @escaping (ConvertResult) -> Void) {
        conversion(to: apiChosenCurShortName4, onCompletion: onCompletion)
    }
    
    
}
