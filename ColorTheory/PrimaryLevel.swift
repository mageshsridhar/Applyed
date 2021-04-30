//
//  PrimaryLevel.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/13/21.
//

import SpriteKit
import SwiftUI
import GlassMorphismic
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
struct PrimaryLevelView : View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var scene = PrimaryLevel()
    @Binding var levelCompleted : Bool
    @State private var showHelp = false
    let red = Color(hexStringToUIColor(hex: "#e42535"))
    let yellow = Color(hexStringToUIColor(hex: "#f8e16c"))
    let blue = Color(hexStringToUIColor(hex: "#336699"))
    var primaryLevel : SKScene{
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*1.25)
        scene.scaleMode = .aspectFill
        return scene
    }
    var body : some View{
        ZStack{
            ScrollView(showsIndicators:false){
            VStack{
                HStack{
                    Button(action:{self.presentationMode.wrappedValue.dismiss()}){
                        Text("Back to Levels").padding()
                    }
                    Spacer()
                    Button(action:{
                        withAnimation(.spring())
                        {
                            showHelp.toggle()
                        }
                        
                    }){
                    Text("How to Play").padding()
                    }
                }.padding(.horizontal)
                SpriteView(scene: primaryLevel)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.45)
            
                HStack{
                    Text("Primary Colors").bold().font(.title).padding(.leading).padding(.leading)
                    Spacer()
                }
                Text("Primary colors are a set of colors which can be used to make a range of colors.").padding(.horizontal).padding(.horizontal).padding(.vertical,5).fixedSize(horizontal: false, vertical: true)
                Text("They are ❤️ Red, 💛 Yellow and 💙 Blue.").fixedSize(horizontal: false, vertical: true).padding(.horizontal).padding(.vertical,5)
                Spacer()
            }
            }
            if scene.levelEnded{
                GlassMorphismic(blurIntensity: 20, cornerRadius: 0, shadowRadius: 0, blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("Level Completed!").font(.largeTitle).bold()
                    HStack{
                        Circle().fill(red).frame(width: 40, height:40)
                        Circle().fill(yellow).frame(width: 50, height:50)
                        Circle().fill(blue).frame(width: 40, height:40)
                    }
                    Text("Recap").font(.title).padding()
                    Text("Primary Colors are Red, Yellow and Blue")
                    Divider().frame(width: 300)
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                        levelCompleted = true
                    }){
                        Text("Goto Next Level").padding()
                    }
                }.padding().padding(.top).background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.black))
            }
            if showHelp{
                GlassMorphismic(blurIntensity: 20, cornerRadius: 0, shadowRadius: 0, blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("How to Play").font(.title2).bold().padding()
                    Text("Tap on one unlocked color and tap on another to swap their positions.")
                    Text("Objective").font(.title2).bold().padding()
                    Text("Arrange the colors in such a way that they transition smoothly from top to bottom.")
                    Divider().frame(width: 300)
                    Button(action:{
                        withAnimation(.spring())
                        {
                            showHelp.toggle()
                        }
                    }){
                        Text("Close").padding()
                    }
                }.padding().padding(.top).background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.black))
            }
        }
    }
}
struct PrimaryLevelView_Previews: PreviewProvider {
    @State static var temp = false
    static var previews: some View {
        PrimaryLevelView(levelCompleted: $temp)
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}


class PrimaryLevel : SKScene, ObservableObject{
    @Published var levelEnded : Bool = false
    var selectedNode : SKNode?
    var initialPoint = CGPoint(x:0,y:0)
    var swapNode : SKNode?
    let randomColors = ["#e42535","#85d27e","#f69133", "#0090b1", "#f8e16c","#f8ba49","#00b5a2","#f0632e","#336699"]
    var finalColors = ["#e42535": 0,"#f0632e": 1,"#f69133" : 2, "#f8ba49" : 3, "#f8e16c" : 4,"#85d27e" : 5,"#00b5a2" : 6,"#0090b1" : 7, "#336699": 8]
    var winCheck = [CGFloat:Int]()
    var xpos = UIScreen.main.bounds.midX
    var ypos = UIScreen.main.bounds.maxY + 10
    var order = [Int]()
    var positions = [CGFloat]()
    let heightofBlock = UIScreen.main.bounds.height/13
    var touchCount = 0
    let firstClick = SKAction.playSoundFileNamed("click_002.wav",waitForCompletion: false)
    let secondClick = SKAction.playSoundFileNamed("click_003.wav",waitForCompletion: false)
    let levelEndedSound = SKAction.playSoundFileNamed("impactMining_002.wav",waitForCompletion: false)
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        var i = 0
            while i<=self.randomColors.count-1{
                    let block = SKSpriteNode(color: hexStringToUIColor(hex: self.randomColors[i]), size: CGSize(width: UIScreen.main.bounds.width-60, height: self.heightofBlock.rounded()))
                    let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 10, height: 14))
                    self.ypos = self.ypos - self.heightofBlock.rounded()
                    self.positions.append(self.ypos)
                    self.order.append(self.finalColors[self.randomColors[i]]!)
                    block.position = CGPoint(x: self.xpos, y: self.ypos)
                    self.addChild(block)
                    lock.position = CGPoint(x: self.xpos, y: self.ypos)
                    block.name = "block"
                    if i % 4 == 0{
                        block.name = "locked"
                        self.addChild(lock)
                        }
                    i = i+1
            }
        
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        print(point)
        let nodesFound = nodes(at: point)
        guard let node = nodesFound.last else { return }
        var temp = CGPoint(x:0,y:0)
        if node.name != "locked"{
            touchCount = touchCount+1
            node.xScale = 1.06
        }
        if nodesFound.count != 0 {
                if touchCount == 1{
                    if nodesFound.last!.name != "locked" {
                    run(self.firstClick)
                    self.selectedNode = nodesFound.last
                    }
                }
                else if touchCount == 2{
                    run(self.secondClick)
                    guard let node = self.selectedNode else { return }
                    self.swapNode = nodesFound.last
                    guard let endnode = swapNode else { return }
                    print(node.position)
                    print(endnode.position)
                    if node.name != "locked" && endnode.name != "locked"{
                        temp = node.position
                        let swapTemp = order[positions.firstIndex(of: node.position.y)!]
                        order[positions.firstIndex(of: node.position.y)!] = order[positions.firstIndex(of: endnode.position.y)!]
                        let nodemoveAnimation = SKAction.moveTo(y: endnode.position.y, duration: 0.15)
                        node.run(nodemoveAnimation)
                        order[positions.firstIndex(of: endnode.position.y)!] = swapTemp
                        let endnodemoveAnimation = SKAction.moveTo(y: temp.y, duration: 0.15)
                        endnode.run(endnodemoveAnimation)
                        node.xScale = 1
                        endnode.xScale = 1
                        if order == order.sorted(){
                            self.run(self.levelEndedSound)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                                withAnimation(.easeIn(duration:0.6))
                                                {
                                                    self.levelEnded = true
                                                }
                                            })
                        }
                        touchCount = 0
                    }
                }
        }
    }
}
