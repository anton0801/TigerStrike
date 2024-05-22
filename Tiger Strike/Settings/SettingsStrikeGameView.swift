import SwiftUI

struct SettingsStrikeGameView: View {
    
    @Binding var isFromGame: Bool
    
    @Environment(\.presentationMode) var backMode
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    @State var soundsEnabledInApp = UserDefaults.standard.bool(forKey: "soundsEnabledInApp")
    
    var body: some View {
        VStack {
            Button {
                if isFromGame {
                    withAnimation {
                        isFromGame = false
                    }
                } else {
                    backMode.wrappedValue.dismiss()
                }
            } label: {
                Image("home_btn")
            }
            
            Spacer()
            
            ZStack {
                Image("settings_item_bg")
                HStack {
                    Image("ic_sounds")
                    Button {
                        soundsEnabledInApp = !soundsEnabledInApp
                    } label: {
                        if soundsEnabledInApp {
                            Image("settings_value_full")
                        } else {
                            Image("settings_value_empty")
                        }
                    }
                }
            }
            
            Button {
                UserDefaults.standard.set(soundsEnabledInApp, forKey: "soundsEnabledInApp")
                if isFromGame {
                    withAnimation {
                        isFromGame = false
                    }
                } else {
                    backMode.wrappedValue.dismiss()
                }
            } label: {
                Image("apply_changes_btn")
            }
            .offset(y: -20)
            
            Spacer()
        }
        .onAppear {
            soundsEnabledInApp = UserDefaults.standard.bool(forKey: "soundsEnabledInApp")
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
    SettingsStrikeGameView(isFromGame: .constant(false))
}
