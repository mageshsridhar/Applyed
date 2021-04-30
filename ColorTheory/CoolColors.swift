//
//  CoolColors.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/20/21.
//

import SwiftUI
import GlassMorphismic
import SpriteKit

struct CoolColors: View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var scene = CoolColorsLevel()
    @Binding var levelCompleted : Bool
    @State private var showHelp = false
    let orange = Color(hexStringToUIColor(hex: "#fe8134"))
    let purple = Color(hexStringToUIColor(hex: "#8a1c7c"))
    let green = Color(hexStringToUIColor(hex: "#178138"))
    var coolColorsLevel : SKScene{
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
                    Button(action:{
                        withAnimation(.spring()){
                            showHelp.toggle()
                        }
                    }){
                    Text("How to Play").padding()
                    }
                }.padding(.horizontal)
                
                SpriteView(scene: coolColorsLevel)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.3)
                HStack{
                    Spacer()
                    Text("Photo by David Becker on Unsplash").font(.caption).padding(.bottom)
                }.padding(.horizontal,25)
                HStack{
                    Text("Cool Colors").bold().font(.title).padding(.leading,20)
                    Spacer()
                }
                HStack{
                    Image("Coolhalf").resizable().aspectRatio(contentMode: .fit)
                    VStack(alignment: .leading)
                    {
                        Text("Another half of the color wheel represents the cool colors. They are associated with calmness, serenity, and peace. The temperature of colors in your design plays a vital role in your message.").font(.callout).padding(.horizontal).padding(.top).foregroundColor(.black)
                        Text("Photo from 99designs.com").font(.caption2).foregroundColor(.black).padding(.horizontal).padding(.vertical,10)
                    }
                }.background(Color.white)
        
                Spacer()
            }
            if scene.levelEnded{
                GlassMorphismic(blurIntensity: 20, cornerRadius: 0, shadowRadius: 0, blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("Level Completed!").font(.largeTitle).bold()
                    HStack{
                        Circle().fill(Color.blue).frame(width: 40, height:40)
                        Circle().fill(Color.purple).frame(width: 40, height:40)
                    }
                    Text("Recap").font(.title).padding()
                    Text("Cool colors are used for calm and soothing designs.")
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

struct CoolColors_Previews: PreviewProvider {
    @State static var temp = false
    static var previews: some View {
        CoolColors(levelCompleted: $temp).preferredColorScheme(.dark)
    }
}

public class CoolColorsLevel : SKScene, ObservableObject{
    @Published var levelEnded = false
    var selectedNode : SKNode?
    var initialPoint = CGPoint(x:0,y:0)
    var swapNode : SKNode?
    let randomColors = ["#8a1c7c", "#7657ac", "#5d80c9","#686dbd","#823e97","#5992d0","#5ea3d4"]
    var finalColors = ["#8a1c7c": 0,"#823e97": 1,"#7657ac" : 2, "#686dbd" : 3, "#5d80c9" : 4,"#5992d0" : 5,"#5ea3d4" : 6]
    var winCheck = [CGFloat:Int]()
    var xpos = UIScreen.main.bounds.midX
    var ypos = UIScreen.main.bounds.midY
    var order = [Int]()
    var positions = [CGFloat]()
    let widthofBlock = UIScreen.main.bounds.width/8
    var touchCount = 0
    let firstClick = SKAction.playSoundFileNamed("click_002.wav",waitForCompletion: false)
    let secondClick = SKAction.playSoundFileNamed("click_003.wav",waitForCompletion: false)
    let levelEndedSound = SKAction.playSoundFileNamed("impactMining_002.wav",waitForCompletion: false)
    public override func didMove(to view: SKView) {
        self.backgroundColor = .black
        var i = 0
        xpos = UIScreen.main.bounds.midX - widthofBlock*4
        ypos = UIScreen.main.bounds.midY + UIScreen.main.bounds.height/4.4 
        while i<=self.randomColors.count-1{
            xpos = xpos.rounded()
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.randomColors[i]), size: CGSize(width: self.widthofBlock.rounded(), height: self.widthofBlock.rounded()+20))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.xpos = self.xpos + self.widthofBlock.rounded()
            self.positions.append(self.xpos)
            self.order.append(self.finalColors[self.randomColors[i]]!)
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            if i == 0 || i==randomColors.count-1{
                block.name = "locked"
                self.addChild(lock)
            }
            i = i+1
        }
        xpos = UIScreen.main.bounds.midX
        ypos = UIScreen.main.bounds.midY - 10
        let image = UIImage(named: "coolcolors")
        let texture = SKTexture(image: image!)
        let colorImage = SKSpriteNode(texture: texture, size: CGSize(width: widthofBlock*7, height: UIScreen.main.bounds.height/2.5))
        colorImage.position = CGPoint(x: self.xpos, y: self.ypos)
        colorImage.name = "image"
        self.addChild(colorImage)
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        print(point)
        let nodesFound = nodes(at: point)
        guard let node = nodesFound.last else { return }
        var temp = CGPoint(x:0,y:0)
        if node.name != "locked" && node.name != "image"{
            touchCount = touchCount+1
            node.yScale = 1.06
        }
        if nodesFound.count != 0 {
                if touchCount == 1{
                    if nodesFound.last!.name != "locked" && nodesFound.last!.name != "image"{
                        run(firstClick)
                    self.selectedNode = nodesFound.last
                    print(self.selectedNode!.position)
                    }
                }
                else if touchCount == 2{
                    guard let node = self.selectedNode else { return }
                    self.swapNode = nodesFound.last
                    guard let endnode = swapNode else { return }
                    if node.name != "locked" && endnode.name != "locked" && node.name != "image" && endnode.name != "image"
                    {
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
