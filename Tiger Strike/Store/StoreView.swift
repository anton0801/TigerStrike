import SwiftUI

struct StoreView: View {
    
    @Environment(\.presentationMode) var backMode
    
    private var screenWidth = UIScreen.main.bounds.width
    private var screenHeight = UIScreen.main.bounds.height
    
    @EnvironmentObject var pointsData: PointsData
    @State var storeData = StoreData()
    
    @State var selectedStoreItem: StoreItem? = nil
    @State var selectedStoreItemIndex = 0 {
        didSet {
            selectedStoreItem = storeData.storeItems[selectedStoreItemIndex]
            if selectedStoreItem!.type == .chart {
                currentBack = selectedStoreItem!.item
            } else {
                currentBack = pointsData.chart
            }
        }
    }
    @State var currentBack: String = "chart_base"
    
    @State var showAlert: Bool = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        VStack {
            if let selectedStoreItem = selectedStoreItem {
                Text(selectedStoreItem.name)
                    .font(.custom("Kung-FuMaster3DItalic", size: 42))
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 1)
                    .background(
                        Image("name_bg")
                    )
                
                Spacer()
                
                HStack {
                    Button {
                        withAnimation {
                            selectedStoreItemIndex -= 1
                        }
                    } label: {
                        Image("prev_page_btn")
                            .resizable()
                            .frame(width: 90, height: 60)
                            .opacity(selectedStoreItemIndex == 0 ? 0.6 : 1)
                    }
                    .disabled(selectedStoreItemIndex == 0)
                    
                    Spacer()
                    if selectedStoreItem.type == .gameBooster {
                        Image(selectedStoreItem.item)
                    }
                    Spacer()
                    Button {
                        withAnimation {
                            selectedStoreItemIndex += 1
                        }
                    } label: {
                        Image("next_page_btn")
                            .resizable()
                            .frame(width: 90, height: 60)
                            .opacity(selectedStoreItemIndex == storeData.storeItems.count - 1 ? 0.6 : 1)
                    }
                    .disabled(selectedStoreItemIndex == storeData.storeItems.count - 1)
                }
                
                Spacer()
                
                if !selectedStoreItem.buyed {
                    HStack {
                        Text("\(selectedStoreItem.price)")
                            .font(.custom("Kung-FuMaster3DItalic", size: 42))
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 1)
                        Image("point")
                            .padding(.leading, 4)
                    }
                    .background(
                        Image("name_bg")
                            .resizable()
                            .frame(width: 180, height: 60)
                    )
                }
                
                VStack {
                    HStack {
                        Button {
                            backMode.wrappedValue.dismiss()
                        } label: {
                            Image("home_btn")
                                .resizable()
                                .frame(width: 60, height: 40)
                        }
                        .offset(y: 20)
                        .padding(.leading, 12)
                        
                        Spacer()
                        
                        if selectedStoreItem.buyed && pointsData.chart != selectedStoreItem.item {
                            Button {
                                if selectedStoreItem.type == .chart {
                                    pointsData.chart = selectedStoreItem.item
                                }
                            } label: {
                                Image("apply_changes_btn")
                            }
                            .offset(x: -30, y: 20)
                        } else if !selectedStoreItem.buyed {
                            Button {
                                let buyResult = storeData.buyStoreItem(pointsData: pointsData, storeItem: selectedStoreItem)
                                if buyResult {
                                    alertTitle = "Buy success!"
                                    alertMessage = "You bought a booster for the game!"
                                } else {
                                    alertTitle = "Warning!"
                                    alertMessage = "You do not have enough coins to purchase this item! Try a couple of levels to buy this item."
                                }
                                showAlert = !buyResult
                                if selectedStoreItem.type == .gameBooster && !showAlert {
                                    showAlert = true
                                }
                                if !showAlert && selectedStoreItem.type == .chart {
                                    withAnimation {
                                        selectedStoreItemIndex = selectedStoreItemIndex
                                    }
                                }
                            } label: {
                                Image("store_btn")
                            }
                            .offset(x: -30, y: 20)
                        }
                        
                        Spacer()
                    }
                }
                .frame(width: screenWidth, height: 150)
                .background(
                    Image("store_bottom")
                        .resizable()
                        .frame(width: screenWidth, height: 150)
                )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            Image(currentBack)
                .resizable()
                .frame(width: screenWidth, height: screenHeight)
                .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            selectedStoreItem = storeData.storeItems[0]
            currentBack = pointsData.chart
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .cancel(Text("OK!"))
            )
        }
    }
    
}

#Preview {
    StoreView()
        .environmentObject(PointsData())
}
