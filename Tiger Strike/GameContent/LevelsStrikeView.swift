import SwiftUI

struct LevelsStrikeView: View {
    
    @Environment(\.presentationMode) var backMode
    @EnvironmentObject var pointsData: PointsData
    
    @State var levelsRep = LevelsRep()
    
    private var screenWidth = UIScreen.main.bounds.width
    private var screenHeight = UIScreen.main.bounds.height
    
    @State var levelsPage = 0 {
        didSet {
            appearLevelsForPage()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(height: 15)
                
                Button {
                    backMode.wrappedValue.dismiss()
                } label: {
                    Image("home_btn")
                }
                
                Spacer()
                
                LazyVGrid(columns: [
                    GridItem(.fixed(100)),
                    GridItem(.fixed(100)),
                    GridItem(.fixed(100))
                ]) {
                    ForEach(levelsRep.splitedGameLevels[levelsPage], id: \.levelId) { levelModel in
                        if levelsRep.availableLevels.contains(where: { $0.levelId == levelModel.levelId }) {
                            NavigationLink(destination: StrikeGameSceneView(level: levelModel)
                                .environmentObject(pointsData)
                                .environmentObject(levelsRep)
                                .navigationBarBackButtonHidden(true)) {
                                ZStack {
                                    Image("level_list_item_bg")
                                    Text("\(levelModel.num)")
                                        .font(.custom("Kung-FuMaster3DItalic", size: 42))
                                        .foregroundColor(.white)
                                        .shadow(color: .white, radius: 1)
                                }
                            }
                        } else {
                            ZStack {
                                Image("level_list_item_bg")
                                Text("\(levelModel.num)")
                                    .font(.custom("Kung-FuMaster3DItalic", size: 42))
                                    .foregroundColor(.white)
                                    .shadow(color: .white, radius: 1)
                            }
                            .opacity(0.6)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    if levelsPage == 0 {
                        levelsPage += 1
                    } else if levelsPage == 1 {
                        levelsPage -= 1
                    }
                } label: {
                    if levelsPage == 0 {
                        Image("next_page_btn")
                    } else {
                        Image("prev_page_btn")
                    }
                }
            }
            .background(
                Image("levels_bg")
                    .resizable()
                    .frame(width: screenWidth, height: screenHeight)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func appearLevelsForPage() {
        
    }
    
}

#Preview {
    LevelsStrikeView()
        .environmentObject(PointsData())
}
