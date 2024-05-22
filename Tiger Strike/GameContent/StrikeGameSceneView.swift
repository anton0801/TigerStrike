import SwiftUI
import SpriteKit

struct StrikeGameSceneView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var pointsData: PointsData
    @EnvironmentObject var levelsData: LevelsRep
    
    var level: LevelModel
    
    @State var strikeGameScene: StrikeGameScene!
    
    @State var gamePaused = false
    @State var gameWin = false
    @State var gameLose = false
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            if strikeGameScene != nil {
                SpriteView(scene: strikeGameScene)
                    .ignoresSafeArea()
            }
            
            if gameWin {
                winGameView
            } else if gameLose {
                loseGameView
            } else if gamePaused {
                pauseGameView
            }
        }
        .onAppear {
            strikeGameScene = StrikeGameScene(size: CGSize(width: 750, height: 1335), level: level)
            strikeGameScene.level = level
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("restartGame"))) { _ in
            if strikeGameScene != nil {
                strikeGameScene = strikeGameScene.restartGame()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("pauseGame"))) { _ in
            withAnimation {
                gamePaused = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("WIN_GAME"))) { _ in
            pointsData.points = pointsData.points + 10
            levelsData.unlockNextLevel(level: level)
            withAnimation {
                gameWin = true
                
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LOSE_GAME"))) { _ in
            withAnimation {
                gameLose = true
            }
        }
    }
    
    private var winGameView: some View {
        VStack {
            Image("win_content")
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image("home_btn")
            }
            .offset(y: -25)
        }
        .background(
            Image("settings_bg")
              .resizable()
              .frame(width: screenWidth, height: screenHeight)
              .edgesIgnoringSafeArea(.all)
        )
    }
    
    private var loseGameView: some View {
        VStack {
            Image("lose_content")
            Button {
                withAnimation {
                    gameLose = false
                }
                strikeGameScene = strikeGameScene.restartGame()
            } label: {
                Image("restart_btn")
            }
            .offset(y: -25)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image("home_btn")
                    .resizable()
                    .frame(width: 120, height: 70)
            }
        }
        .background(
            Image("settings_bg")
              .resizable()
              .frame(width: screenWidth, height: screenHeight)
              .edgesIgnoringSafeArea(.all)
        )
    }
    
    private var pauseGameView: some View {
        VStack {
            Image("pause_content")
            Button {
                withAnimation {
                    gamePaused = false
                }
                strikeGameScene.continuePlay()
            } label: {
                Image("continue_play_btn")
            }
            .offset(y: -25)
            
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("home_btn")
                        .resizable()
                        .frame(width: 100, height: 60)
                }
                
                Button {
                    withAnimation {
                        gamePaused = false
                    }
                    strikeGameScene = strikeGameScene.restartGame()
                } label: {
                    Image("restart_btn")
                        .resizable()
                        .frame(width: 100, height: 60)
                }
            }
        }
        .background(
            Image("settings_bg")
              .resizable()
              .frame(width: screenWidth, height: screenHeight)
              .edgesIgnoringSafeArea(.all)
        )
    }
    
}

#Preview {
    StrikeGameSceneView(level: LevelModel(levelId: "lvl_1", num: 2, eachBallsChangeObjectiveBall: 3, ballsObjectiveCount: 20))
        .environmentObject(LevelsRep())
        .environmentObject(PointsData())
}
