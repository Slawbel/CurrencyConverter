import Foundation

// this structure defines constant for using in currency list api request
struct CurData: Codable {
    let symbols: Dictionary<String, String>
}
