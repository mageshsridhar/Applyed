//
//  WarmColors.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/18/21.
//

import SwiftUI
import SpriteKit
import GlassMorphismic
struct WarmColors: View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var scene = WarmColorsLevel()
    @Binding var levelCompleted : Bool
    @State private var showHelp = false
    var warmColorsLevel : SKScene{
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
                HStack{
                    Spacer()
                    Text("Photo by Birger Strahl on Unsplash").font(.caption)
                }.padding(.horizontal,25)
                SpriteView(scene: warmColorsLevel)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.5)
            
                HStack{
                    Text("Warm Colors").bold().font(.title).padding(.leading,20)
                    Spacer()
                }
                HStack{
                    Image("Warmhalf").resizable().aspectRatio(contentMode: .fit)
                    VStack(alignment: .leading)
                    {
                    Text("Warm colors are generally associated with energy, brightness, and action. Draw line through the center of the color wheel and you'll seperate the warm colors.").font(.callout).padding(.horizontal).foregroundColor(.black)
                        Text("Photo from 99designs.com").font(.caption2).foregroundColor(.black).padding(.horizontal).padding(.top,5)
                    }
                }.background(Color.white)
        
                Spacer()
            }
            if scene.levelEnded{
                GlassMorphismic(blurIntensity: 20, cornerRadius: 0, shadowRadius: 0, blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("Level Completed!").font(.largeTitle).bold()
                    HStack{
                        Circle().fill(Color.orange).frame(width: 40, height:40)
                        Circle().fill(Color.red).frame(width: 40, height:40)
                    }
                    Text("Recap").font(.title).padding()
                    Text("Warm colors are used for bright and energetic designs.")
                    Divider().frame(width: 300)
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                        levelCompleted = true
                    }){
                        Text("Goto Next Level").padding()
                    }
                }.padding().padding(.top).background(RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.black))
            }
            if self.showHelp{
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

struct WarmColors_Previews: PreviewProvider {
    @State static var temp = false
    static var previews: some View {
        WarmColors(levelCompleted: $temp)
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
        
    }
}

class WarmColorsLevel : SKScene, ObservableObject{
    @Published var levelEnded = false
    var selectedNode : SKNode?
    var initialPoint = CGPoint(x:0,y:0)
    var swapNode : SKNode?
    let randomColors = ["#f35932", "#f87a31", "#fc9837","#fa8933","#f66a31","#fda63c","#fdb444"]
    var finalColors = ["#f35932": 0,"#f66a31": 1,"#f87a31" : 2, "#fa8933" : 3, "#fc9837" : 4,"#fda63c" : 5,"#fdb444" : 6]
    var winCheck = [CGFloat:Int]()
    var xpos = UIScreen.main.bounds.midX
    var ypos = UIScreen.main.bounds.midY + 150
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
        let image = UIImage(named: "warmcolors")
        let texture = SKTexture(image: image!)
        let colorImage = SKSpriteNode(texture: texture, size: CGSize(width: widthofBlock*7, height: UIScreen.main.bounds.height/3.5))
        colorImage.position = CGPoint(x: self.xpos, y: self.ypos)
        colorImage.name = "image"
        self.addChild(colorImage)
        xpos = UIScreen.main.bounds.midX - widthofBlock*4
        ypos = UIScreen.main.bounds.midY
        while i<=self.randomColors.count-1{
            xpos = xpos.rounded()
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.randomColors[i]), size: CGSize(width: self.widthofBlock.rounded(), height: self.widthofBlock.rounded() + 20))
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
        
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
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
