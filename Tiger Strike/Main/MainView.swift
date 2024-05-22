import SwiftUI

struct MainView: View {
    
    @State var pointsData = PointsData()
    
    private var screenWidth = UIScreen.main.bounds.width
    private var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: LevelsStrikeView()
                    .environmentObject(pointsData)
                    .navigationBarBackButtonHidden(true)) {
                    Image("play")
                }
                
                Spacer().frame(height: 50)
                
                NavigationLink(destination: SettingsStrikeGameView(isFromGame: .constant(false))
                    .navigationBarBackButtonHidden(true)) {
                    Image("settings")
                }
                Spacer().frame(height: 50)
                
                NavigationLink(destination: StoreView()
                    .environmentObject(pointsData)
                    .navigationBarBackButtonHidden(true)) {
                    Image("store_btn")
                }
                
            }
            .background(
                Image("menu_bg")
                    .resizable()
                    .frame(width: screenWidth, height: screenHeight)
                    .edgesIgnoringSafeArea(.all)
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MainView()
}
