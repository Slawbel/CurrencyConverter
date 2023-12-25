import Foundation

// structure is needed to create data type that used for convertion 
struct ConvertResult: Codable {
    let date: String?
    let info: Dictionary<String, Double>
    let result: Double?
    let success: Bool?
    
}
