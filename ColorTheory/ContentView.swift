//
//  ContentView.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/13/21.
//

import SwiftUI
import SpriteKit
import GlassMorphismic
struct ContentView: View {
    @State private var primaryCompleted = false
    @State private var secondaryCompleted = false
    @State private var tertiaryCompleted = false
    @State private var warmCompleted = false
    @State private var coolCompleted = false
    @State private var complementaryCompleted = false
    @State private var analogousCompleted = false
    @State private var triadicCompleted = false
    @State private var primaryLevel = false
    @State private var secondaryLevel = false
    @State private var tertiaryLevel = false
    @State private var warmLevel = false
    @State private var coolLevel = false
    @State private var complementaryLevel = false
    @State private var analogousLevel = false
    @State private var triadicLevel = false
    @State private var infoSheet = false
    let red = Color(hexStringToUIColor(hex: "#e42535"))
    let yellow = Color(hexStringToUIColor(hex: "#f8e16c"))
    let blue = Color(hexStringToUIColor(hex: "#336699"))
    let redpurple = Color(hexStringToUIColor(hex: "#c40061"))
    let bluepurple = Color(hexStringToUIColor(hex: "#594e94"))
    let bluegreen = Color(hexStringToUIColor(hex: "#007b8a"))
    let yellowgreen = Color(hexStringToUIColor(hex: "#8eb348"))
    let yelloworange = Color(hexStringToUIColor(hex: "#fdb444"))
    let redorange = Color(hexStringToUIColor(hex: "#f35932"))
    let levelBackground = Color(hexStringToUIColor(hex: "#212121"))
    var primaryColorsLevel : some View{
        HStack(spacing: 20){
            VStack{
                Circle().fill(red).frame(width: 10, height: 10)
                HStack{
                    Circle().fill(yellow).frame(width: 10, height: 10)
                    Circle().fill(blue).frame(width: 10, height: 10)
                }
            }.padding().background(Circle().fill(Color(hexStringToUIColor(hex: "#111111"))))
                Text("Primary Colors").bold().font(.subheadline)
            Spacer()
            if primaryCompleted{
                Image(systemName: "checkmark.circle.fill").font(.system(size: 23,weight: .bold)).padding()
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width-30,height: UIScreen.main.bounds.height/8)
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(levelBackground))
        .onTapGesture {
            primaryLevel.toggle()
        }
        .fullScreenCover(isPresented: $primaryLevel){
                PrimaryLevelView(levelCompleted: $primaryCompleted).preferredColorScheme(.dark)
        }
    }
    var secondaryColorsLevel : some View{
        HStack(spacing: 20){
            VStack{
                HStack{
                    Circle().fill(Color.orange).frame(width: 10, height: 10)
                    Circle().fill(Color.purple).frame(width: 10, height: 10)
                }
                Circle().fill(Color.green).frame(width: 10, height: 10)
            }.padding().background(Circle().fill(Color(hexStringToUIColor(hex: "#111111"))))
            Text("Secondary Colors").bold().font(.subheadline)
            Spacer()
            if secondaryCompleted{
                Image(systemName: "checkmark.circle.fill").font(.system(size: 23,weight: .bold)).padding()
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width-30,height: UIScreen.main.bounds.height/8)
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(levelBackground))
        .onTapGesture {
            secondaryLevel.toggle()
        }
        .fullScreenCover(isPresented: $secondaryLevel){
                SecondaryColors(levelCompleted: $secondaryCompleted).preferredColorScheme(.dark)
        }
    }
    var tertiaryColorsLevel : some View{
        HStack(spacing: 20){
            VStack{
                HStack{
                    Circle().fill(redpurple).frame(width: 6, height: 6)
                    Circle().fill(bluepurple).frame(width: 6, height: 6)
                }
                HStack{
                    Circle().fill(bluegreen).frame(width: 6, height: 6)
                    Circle().fill(Color(hexStringToUIColor(hex: "#111111"))).frame(width: 6, height: 6)
                    Circle().fill(yellowgreen).frame(width: 6, height: 6)
                }
                HStack{
                    Circle().fill(yelloworange).frame(width: 6, height: 6)
                    Circle().fill(redorange).frame(width: 6, height: 6)
                }
            }.padding().background(Circle().fill(Color(hexStringToUIColor(hex: "#111111"))))
            Text("Tertiary Colors").bold().font(.subheadline)
            Spacer()
            if tertiaryCompleted{
                Image(systemName: "checkmark.circle.fill").font(.system(size: 23,weight: .bold)).padding()
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width-30,height: UIScreen.main.bounds.height/8 )
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(levelBackground))
        .onTapGesture {
            tertiaryLevel.toggle()
        }
        .fullScreenCover(isPresented: $tertiaryLevel){
                TertiaryColors(levelCompleted: $tertiaryCompleted).preferredColorScheme(.dark)
        }
    }
    var warmColorsLevel : some View{
        HStack(spacing: 20){
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.orange,Color.red]), startPoint: .bottom, endPoint: .top))
                .frame(width: 30,height: 30)
                .padding()
                .background(Circle().fill(Color(hexStringToUIColor(hex: "#111111"))))
            Text("Warm Colors").bold().font(.subheadline)
            Spacer()
            if warmCompleted{
                Image(systemName: "checkmark.circle.fill").font(.system(size: 23,weight: .bold)).padding()
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width-30,height: UIScreen.main.bounds.height/8 )
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(levelBackground))
        .onTapGesture {
            warmLevel.toggle()
        }
        .fullScreenCover(isPresented: $warmLevel){
                WarmColors(levelCompleted: $warmCompleted).preferredColorScheme(.dark)
        }
    }
    var coolColorsLevel : some View{
        HStack(spacing: 20){
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.purple,Color.blue]), startPoint: .bottom, endPoint: .top))
                .frame(width: 30,height: 30)
                .padding()
                .background(Circle().fill(Color(hexStringToUIColor(hex: "#111111"))))
            Text("Cool Colors").bold().font(.subheadline)
            Spacer()
            if coolCompleted{
                Image(systemName: "checkmark.circle.fill").font(.system(size: 23,weight: .bold)).padding()
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width-30,height: UIScreen.main.bounds.height/8 )
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(levelBackground))
        .onTapGesture {
            coolLevel.toggle()
        }
        .fullScreenCover(isPresented: $coolLevel){
                CoolColors(levelCompleted: $coolCompleted).preferredColorScheme(.dark)
        }
    }
    var complementaryColorsLevel : some View{
        HStack(spacing: 20){
            HStack{
                Circle().fill(Color.orange).frame(width: 10, height: 10)
                Circle().fill(Color.blue).frame(width: 10, height: 10)
            }
                .padding()
                .background(Circle().fill(Color(hexStringToUIColor(hex: "#111111"))).frame(width: 60, height: 60))
            Text("Complementary Colors").bold().font(.subheadline)
            Spacer()
            if complementaryCompleted{
                Image(systemName: "checkmark.circle.fill").font(.system(size: 23,weight: .bold)).padding()
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width-30,height: UIScreen.main.bounds.height/8 )
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(levelBackground))
        .onTapGesture {
            complementaryLevel.toggle()
        }
        .fullScreenCover(isPresented: $complementaryLevel){
                ComplementaryColors(levelCompleted: $complementaryCompleted).preferredColorScheme(.dark)
        }
    }
    var analogousColorsLevel : some View{
        HStack(spacing: 20){
            HStack{
                Circle().fill(Color.blue).frame(width: 6, height: 6)
                Circle().fill(bluegreen).frame(width: 6, height: 6)
                Circle().fill(Color.green).frame(width: 6, height: 6)
            }.padding().background(Circle().fill(Color(hexStringToUIColor(hex: "#111111"))).frame(width: 60, height: 60))
            Text("Analogous Colors").bold().font(.subheadline)
            Spacer()
            if analogousCompleted{
                Image(systemName: "checkmark.circle.fill").font(.system(size: 23,weight: .bold)).padding()
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width-30,height: UIScreen.main.bounds.height/8 )
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(levelBackground))
        .onTapGesture {
            analogousLevel.toggle()
        }
        .fullScreenCover(isPresented: $analogousLevel){
                AnalogousColors(levelCompleted: $analogousCompleted).preferredColorScheme(.dark)
        }
    }
    var triadicColorsLevel : some View{
        HStack(spacing: 20){
            VStack{
                Circle().fill(red).frame(width: 10, height: 10)
                HStack{
                    Circle().fill(yellow).frame(width: 10, height: 10)
                    Circle().fill(blue).frame(width: 10, height: 10)
                }
            }.padding().background(Circle().fill(Color(hexStringToUIColor(hex: "#111111"))))
            Text("Triadic Colors").bold().font(.subheadline)
            Spacer()
            if triadicCompleted{
                Image(systemName: "checkmark.circle.fill").font(.system(size: 23,weight: .bold)).padding()
            }
        }.padding()
        .frame(width: UIScreen.main.bounds.width-30,height: UIScreen.main.bounds.height/8 )
        .background(RoundedRectangle(cornerRadius: 15, style: .continuous).fill(levelBackground))
        .onTapGesture {
            triadicLevel.toggle()
        }
        .fullScreenCover(isPresented: $triadicLevel){
                TriadicColors(levelCompleted: $triadicCompleted).preferredColorScheme(.dark)
        }
    }
    var body: some View {
        ZStack{
        ScrollView(showsIndicators: false){
            VStack{
                HStack{
                Text("Color Theory").bold().font(.largeTitle).padding()
                    Spacer()
                    Button(action:{infoSheet.toggle()}){
                        Image(systemName: "info.circle").font(.title).foregroundColor(.white).padding()
                    }.sheet(isPresented: $infoSheet){
                        InfoView().preferredColorScheme(.dark)
                    }
                }
                Group{
                    HStack{
                        Text("Color Wheel").bold().font(.title).padding(.horizontal)
                        Spacer()
                    }
                    primaryColorsLevel
                    secondaryColorsLevel
                    tertiaryColorsLevel
                    warmColorsLevel
                    coolColorsLevel
                }
                Group{
                    HStack{
                        Text("Color Schemes").bold().font(.title).padding([.horizontal,.top])
                        Spacer()
                    }
                    complementaryColorsLevel
                    analogousColorsLevel
                    triadicColorsLevel
                }
                Spacer()
                }
            }
            if primaryCompleted && secondaryCompleted && tertiaryCompleted && warmCompleted && coolCompleted && complementaryCompleted && analogousCompleted && triadicCompleted{
                GlassMorphismic(blurIntensity: 80, cornerRadius: 0, shadowRadius: 0,blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("Congratulations!").font(.title2).bold().padding()
                    Text("You've successfully completed this game! Thanks for playing and hope you learned something new. Tap the button below if you want to play again.").padding()
                    Divider().frame(width: 300)
                    Button(action:{
                        withAnimation(.spring())
                        {
                            primaryCompleted.toggle()
                            secondaryCompleted.toggle()
                            tertiaryCompleted.toggle()
                            warmCompleted.toggle()
                            coolCompleted.toggle()
                            complementaryCompleted.toggle()
                            analogousCompleted.toggle()
                            triadicCompleted.toggle()
                        }
                    }){
                        Text("Play Again.").padding()
                    }
                }.padding().padding(.top).background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.black).frame(width: UIScreen.main.bounds.width - 30))
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
