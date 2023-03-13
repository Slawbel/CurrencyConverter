import Foundation

struct ConvertResult: Codable {
    let date: String?
    let info: Dictionary<String, Double>
    let result: Double?
    let success: Bool?
    
}
