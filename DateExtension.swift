import UIKit
extension Date{
    static  func convertTime(time:TimeInterval) -> String {
        let minute = Int(time.truncatingRemainder(dividingBy: 3600) / 60)
        let second = Int(time.truncatingRemainder(dividingBy: 60))
        return String(format:"%02d",minute) + ":" + String(format:"%02d",second)
    }
}
