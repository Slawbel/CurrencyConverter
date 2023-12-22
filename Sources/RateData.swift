import Foundation

// structure to collects dates with rate index
struct RateData: Codable {
    let rates: Dictionary<String,[String: Double]>
}
    
