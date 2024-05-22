import Foundation

class StoreData: ObservableObject {
    
    @Published var storeItems: [StoreItem] = []
    
    init() {
        initStoreItems()
    }
    
    private func initStoreItems() {
        let items = [
            StoreItem(id: "lives", item: "heart_bonus", name: "Heart", price: 15, type: .gameBooster, buyed: false),
            StoreItem(id: "timebonus", item: "time_bonus", name: "Time", price: 20, type: .gameBooster, buyed: false),
            StoreItem(id: "chart_1", item: "game_back_1", name: "CHART", price: 25, type: .chart, buyed: UserDefaults.standard.bool(forKey: "chart_1_buyed")),
            StoreItem(id: "chart_2", item: "game_back_2", name: "CHART", price: 25, type: .chart, buyed: UserDefaults.standard.bool(forKey: "chart_2_buyed")),
            StoreItem(id: "chart_3", item: "game_back_3", name: "CHART", price: 25, type: .chart, buyed: UserDefaults.standard.bool(forKey: "chart_3_buyed")),
            StoreItem(id: "chart_4", item: "game_back_4", name: "CHART", price: 25, type: .chart, buyed: UserDefaults.standard.bool(forKey: "chart_4_buyed")),
        ]
        storeItems = items
    }
    
    func buyStoreItem(pointsData: PointsData, storeItem: StoreItem) -> Bool {
        let price = storeItem.price
        if pointsData.points >= price {
            if storeItem.type == .gameBooster {
                let currentBoosterCount = UserDefaults.standard.integer(forKey: "\(storeItem.id)")
                UserDefaults.standard.set(currentBoosterCount + 1, forKey: "\(storeItem.id)")
            } else {
                UserDefaults.standard.set(true, forKey: "\(storeItem.id)_buyed")
                initStoreItems()
            }
            pointsData.points -= storeItem.price
            return true
        }
        return false
    }
    
}

struct StoreItem {
    let id: String
    let item: String
    let name: String
    let price: Int
    let type: StoreItemType
    let buyed: Bool
}

enum StoreItemType {
    case gameBooster, chart
}
