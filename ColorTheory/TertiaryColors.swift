//
//  TertiaryColors.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/18/21.
//

import SwiftUI
import SpriteKit
import GlassMorphismic

struct TertiaryColors : View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var scene = TertiaryLevel()
    @Binding var levelCompleted : Bool
    @State private var showHelp = false
    let red = Color(hexStringToUIColor(hex: "#e42535"))
    let yellow = Color(hexStringToUIColor(hex: "#f8e16c"))
    let blue = Color(hexStringToUIColor(hex: "#336699"))
    var primaryLevel : SKScene{
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        return scene
    }
    var body : some View{
        ZStack{
            ScrollView(showsIndicators: false){
            VStack{
                HStack{
                    Button(action:{self.presentationMode.wrappedValue.dismiss()}){
                        Text("Back to Levels").padding()
                    }
                    Spacer()
                    Button(action:{
                        withAnimation(.spring()){
                            showHelp.toggle()
                        }
                    }){
                    Text("How to Play").padding()
                    }
                }.padding(.horizontal)
                SpriteView(scene: primaryLevel)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.35)
            
                HStack{
                    Text("Tertiary Colors").bold().font(.title).padding(.leading).padding(.leading)
                    Spacer()
                }
                HStack{
                    Text("Tertiary Colors were made by mixing one primary and one secondary color that are adjacent to each other.\n\n💜 Purple + ❤️ Red = Red-Purple\n\n💙 Blue + 💜 Purple = Blue-Purple\n\n💚 Green + 💙 Blue = Blue-Green\n\n💛 Yellow + 💚 Green = Yellow-Green\n\n🧡 Orange + 💛 Yellow = Yellow-Orange\n\n❤️ Red + 🧡 Orange = Red-Orange").padding(.horizontal).padding(.vertical,5).padding(.horizontal)
                    Spacer()
                }
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
                    Text("Arrange the colors in such a way that the middle color is a mix of the colors on the right and left.")
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
struct TertiaryColors_Previews: PreviewProvider {
    @State static var temp = false
    static var previews: some View {
        TertiaryColors(levelCompleted: $temp)
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}


class TertiaryLevel : SKScene, ObservableObject{
    @Published var levelEnded : Bool = false
    var selectedNode : SKNode?
    var initialPoint = CGPoint(x:0,y:0)
    var swapNode : SKNode?
    var finalColors = ["#c40061": 0,"#594e9a": 1,"#007b8a": 2, "#8eb348": 3, "#fdb444": 4,"#f35932": 5]
    let randomColors = ["#007b8a","#c40061","#f35932","#fdb444","#594e9a", "#8eb348"]
    var firstColumn = ["#e42535", "#8a1c7c", "#336699","#178138", "#f8e16c", "#fe8134"] //red, purple, blue, green, yellow, orange
    var secondColumn = ["#8a1c7c", "#336699","#178138", "#f8e16c", "#fe8134", "#e42535"]
    var winCheck = [CGFloat:Int]()
    var ypos = UIScreen.main.bounds.maxY - 50
    var order = [Int]()
    var positions = [CGFloat]()
    let heightofBlock = UIScreen.main.bounds.height/8
    var xpos = UIScreen.main.bounds.midX
    var touchCount = 0
    let firstClick = SKAction.playSoundFileNamed("click_002.wav",waitForCompletion: false)
    let secondClick = SKAction.playSoundFileNamed("click_003.wav",waitForCompletion: false)
    let levelEndedSound = SKAction.playSoundFileNamed("impactMining_002.wav",waitForCompletion: false)
    public override func didMove(to view: SKView) {
        self.backgroundColor = .black
        xpos = xpos - heightofBlock.rounded()
        for i in 0...firstColumn.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.firstColumn[i]), size: CGSize(width: self.heightofBlock.rounded(), height: self.heightofBlock.rounded()))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 12, height: 16))
            self.ypos = self.ypos - self.heightofBlock.rounded()
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            block.name = "locked"
            self.addChild(lock)
        }
        xpos = xpos + heightofBlock.rounded()
        ypos = UIScreen.main.bounds.maxY - 50
        for i in 0...randomColors.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.randomColors[i]), size: CGSize(width: self.heightofBlock.rounded(), height: self.heightofBlock.rounded()))
            self.ypos = self.ypos - self.heightofBlock.rounded()
            self.positions.append(self.ypos)
            self.order.append(self.finalColors[self.randomColors[i]]!)
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            self.addChild(block)
        }
        xpos = xpos + heightofBlock.rounded()
        ypos = UIScreen.main.bounds.maxY - 50
        for i in 0...secondColumn.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.secondColumn[i]), size: CGSize(width: self.heightofBlock.rounded(), height: self.heightofBlock.rounded()))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 12, height: 16))
            self.ypos = self.ypos - self.heightofBlock.rounded()
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            block.name = "locked"
            self.addChild(lock)
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
            node.yScale = 1.06
            node.zPosition = 1
        }
        if nodesFound.count != 0 {
                if touchCount == 1{
                    if nodesFound.last!.name != "locked" {
                        run(firstClick)
                    self.selectedNode = nodesFound.last
                    print(self.selectedNode!.position)
                    }
                }
                else if touchCount == 2{
                    guard let node = self.selectedNode else { return }
                    self.swapNode = nodesFound.last
                    guard let endnode = swapNode else { return }
                    print(node.position)
                    print(endnode.position)
                    if node.name != "locked" && endnode.name != "locked"{
                        run(secondClick)
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
                        node.yScale = 1
                        endnode.yScale = 1
                        if order == order.sorted(){
                            run(levelEndedSound)
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
