import Foundation

class PointsData: ObservableObject {
    
    @Published var points = UserDefaults.standard.integer(forKey: "points") {
        didSet {
            UserDefaults.standard.set(points, forKey: "points")
        }
    }
    
    @Published var chart = UserDefaults.standard.string(forKey: "chart") ?? "chart_base" {
        didSet {
            UserDefaults.standard.set(chart, forKey: "chart")
        }
    }
    
    init() {
        if !UserDefaults.standard.bool(forKey: "settted") {
            setUpFirstSettings()
            UserDefaults.standard.set(true, forKey: "settted")
        }
    }
    
    func setUpFirstSettings() {
        chart = "chart_base"
    }
    
}
