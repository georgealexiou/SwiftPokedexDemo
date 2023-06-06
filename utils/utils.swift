import Foundation

func formatNumber(id: Int) -> String {
    if id < 10 {
        return "00\(id)"
    } else if id < 100 {
        return "0\(id)"
    }
    return "\(id)"
}
