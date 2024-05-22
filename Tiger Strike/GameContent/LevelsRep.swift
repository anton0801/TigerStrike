import Foundation


class LevelsRep: ObservableObject {
    
    @Published var gameLevels: [LevelModel] = []
    @Published var splitedGameLevels: [[LevelModel]] = []
    @Published var availableLevels: [LevelModel] = []
    
    let ballsCountObjectives = [
        1: 20,
        4: 30,
        8: 40
    ]
    
    init() {
        generateGameLevels()
        spliteGameLevels()
        checkAvailableLevels()
    }
    
    private func generateGameLevels() {
        for gameLevel in 1...24 {
            if gameLevel >= 1 && gameLevel <= 3 {
                let gameLevel = LevelModel(levelId: "lvl_\(gameLevel)", num: gameLevel, eachBallsChangeObjectiveBall: 3, ballsObjectiveCount: 20)
                gameLevels.append(gameLevel)
            } else if gameLevel >= 4 && gameLevel < 8 {
                let gameLevel = LevelModel(levelId: "lvl_\(gameLevel)", num: gameLevel, eachBallsChangeObjectiveBall: 2, ballsObjectiveCount: 30)
                gameLevels.append(gameLevel)
            } else if gameLevel >= 8 && gameLevel < 13 {
                let gameLevel = LevelModel(levelId: "lvl_\(gameLevel)", num: gameLevel, eachBallsChangeObjectiveBall: 1, ballsObjectiveCount: 40)
                gameLevels.append(gameLevel)
            } else {
                let gameLevel = LevelModel(levelId: "lvl_\(gameLevel)", num: gameLevel, eachBallsChangeObjectiveBall: 1, ballsObjectiveCount: 50)
                gameLevels.append(gameLevel)
            }
        }
    }
    
    private func spliteGameLevels() {
        var temp = [LevelModel]()
        for (index, item) in gameLevels.enumerated() {
            temp.append(item)
            if (index + 1) % 12 == 0 {
                splitedGameLevels.append(temp)
                temp = []
            }
        }
    }
    
    func unlockNextLevel(level: LevelModel) {
        let defaults = UserDefaults.standard
        let nextLevelItems = gameLevels.filter { $0.num == level.num + 1 }
        if !nextLevelItems.isEmpty {
            let nextLevelItem = nextLevelItems[0]
            availableLevels.append(nextLevelItem)
            defaults.set(availableLevels.map { $0.levelId }.joined(separator: "*"), forKey: "saved_lvls")
        }
    }
    
    private func checkAvailableLevels() {
        let defaults = UserDefaults.standard
        let savedLevelsList = defaults.string(forKey: "saved_lvls")?.components(separatedBy: "*") ?? []
        if !savedLevelsList.isEmpty {
            for savedLevelId in savedLevelsList {
                availableLevels.append(gameLevels.filter({ $0.levelId == savedLevelId })[0])
            }
        } else {
            availableLevels.append(gameLevels[0])
            defaults.set(availableLevels.map { $0.levelId }.joined(separator: "*"), forKey: "saved_lvls")
        }
    }
    
}
