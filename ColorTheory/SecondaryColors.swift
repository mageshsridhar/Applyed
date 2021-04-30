//
//  SecondaryColors.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/18/21.
//

import SpriteKit
import SwiftUI
import GlassMorphismic

struct SecondaryColors: View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var scene = SecondaryLevel()
    @Binding var levelCompleted : Bool
    let orange = Color(hexStringToUIColor(hex: "#fe8134"))
    let purple = Color(hexStringToUIColor(hex: "#8a1c7c"))
    let green = Color(hexStringToUIColor(hex: "#178138"))
    @State private var showHelp = false
    var secondaryLevel : SKScene{
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*1.25)
        scene.scaleMode = .aspectFill
        return scene
    }
    var body : some View{
        ZStack{
            VStack{
                HStack{
                    Button(action:{self.presentationMode.wrappedValue.dismiss()}){
                        Text("Back to Levels").padding()
                    }
                    Spacer()
                    Button(action:{withAnimation(.spring())
                    {
                        showHelp.toggle()
                    }}){
                    Text("How to Play").padding()
                    }
                }.padding(.horizontal)
                SpriteView(scene: secondaryLevel)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            
                HStack{
                    Text("Secondary Colors").bold().font(.title).padding(.leading).padding(.leading)
                    Spacer()
                }
                HStack{
                    Text("Secondary colors are obtained by mixing two of the primary colors.\n \n ❤️ Red + 💛 Yellow = 🧡 Orange \n \n 💛 Yellow + 💙 Blue = 💚 Green \n \n ❤️ Red + 💙 Blue = 💜 Purple").padding(.horizontal).padding(.vertical,5).padding(.horizontal)
                    Spacer()
                }
                Spacer()
            }
            if scene.levelEnded{
                GlassMorphismic(blurIntensity: 20, cornerRadius: 0, shadowRadius: 0, blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("Level Completed!").font(.largeTitle).bold()
                    HStack{
                        Circle().fill(orange).frame(width: 40, height:40)
                        Circle().fill(purple).frame(width: 50, height:50)
                        Circle().fill(green).frame(width: 40, height:40)
                    }
                    Text("Recap").font(.title).padding()
                    Text("Secondary Colors are orange, purple and green")
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
                    Text("Arrange the colors in such a way that they transition smoothly from left to right.")
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
struct SecondaryColors_Previews: PreviewProvider {
    @State static var temp = false
    static var previews: some View {
        SecondaryColors(levelCompleted: $temp)
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}

class SecondaryLevel : SKScene,ObservableObject{
    @Published var levelEnded : Bool = false
    var selectedNode : SKNode?
    var initialPoint = CGPoint(x:0,y:0)
    var swapNode : SKNode?
    let randomColors = ["#8a1c7c","#938d00","#5d891a", "#dd3560", "#fe8134","#f4594b","#b91d71","#c98a00","#178138"]
    var finalColors = ["#8a1c7c": 0,"#b91d71": 1,"#dd3560" : 2, "#f4594b" : 3, "#fe8134" : 4,"#c98a00" : 5,"#938d00" : 6,"#5d891a" : 7, "#178138": 8]
    var winCheck = [CGFloat:Int]()
    var xpos = UIScreen.main.bounds.midX
    var ypos = UIScreen.main.bounds.midY + 100
    var order = [Int]()
    var positions = [CGFloat]()
    let widthofBlock = UIScreen.main.bounds.width/9
    var touchCount = 0
    let firstClick = SKAction.playSoundFileNamed("click_002.wav",waitForCompletion: false)
    let secondClick = SKAction.playSoundFileNamed("click_003.wav",waitForCompletion: false)
    let levelEndedSound = SKAction.playSoundFileNamed("impactMining_002.wav",waitForCompletion: false)
    public override func didMove(to view: SKView) {
        self.backgroundColor = .black
        var i = 0
        xpos = xpos - widthofBlock*4
        xpos = xpos.rounded()
        while i<=self.randomColors.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.randomColors[i]), size: CGSize(width: self.widthofBlock.rounded(), height: UIScreen.main.bounds.height/2.5))
            self.positions.append(self.xpos)
            self.order.append(self.finalColors[self.randomColors[i]]!)
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 12, height: 16))
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            if i % 4 == 0{
                block.name = "locked"
                self.addChild(lock)
            }
            self.xpos = self.xpos + self.widthofBlock.rounded()
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
            node.yScale = 1.06
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
                        let swapTemp = order[positions.firstIndex(of: node.position.x)!]
                        order[positions.firstIndex(of: node.position.x)!] = order[positions.firstIndex(of: endnode.position.x)!]
                        let nodemoveAnimation = SKAction.moveTo(x: endnode.position.x, duration: 0.15)
                        node.run(nodemoveAnimation)
                        order[positions.firstIndex(of: endnode.position.x)!] = swapTemp
                        let endnodemoveAnimation = SKAction.moveTo(x: temp.x, duration: 0.15)
                        endnode.run(endnodemoveAnimation)
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
