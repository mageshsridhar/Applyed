//
//  ComplementaryColors.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/20/21.
//

import SwiftUI
import SpriteKit
import GlassMorphismic

struct ComplementaryColors : View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var scene = ComplementaryColorsLevel()
    @Binding var levelCompleted : Bool
    @State private var showHelp = false
    var complementaryLevel : SKScene{
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
                SpriteView(scene: complementaryLevel)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            
                HStack{
                    Text("Complementary Colors").bold().font(.title).padding(.leading).padding(.leading)
                    Spacer()
                }
                    Text("Complementary colors are opposites on the color wheel—red and green, for example. There’s a sharp contrast between the two colors so they can make imagery pop, but overusing them can get tiresome.").padding(.horizontal).padding(.vertical,5).padding(.horizontal)
                Image("complementary").resizable().aspectRatio(contentMode: .fit).frame(width: UIScreen.main.bounds.width-40).clipShape(RoundedRectangle(cornerRadius: 20.0))
                Text("Photo from 99designs.com").font(.caption).padding(.vertical,8)
                Spacer()
                }
            }
            if scene.levelEnded{
                GlassMorphismic(blurIntensity: 20, cornerRadius: 0, shadowRadius: 0, blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("Level Completed!").font(.largeTitle).bold()
                    HStack{
                        Circle().fill(Color.orange).frame(width: 40, height:40)
                        Circle().fill(Color.blue).frame(width: 40, height:40)
                    }
                    Text("Recap").font(.title).padding()
                    Text("Complementary colors are opposite to each other in the color wheel.")
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
                    Text("Arrange the colors in the diagonal such a way that the colors in each row transition from left to right.")
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

struct ComplementaryColors_Previews: PreviewProvider {
    @State static var temp = false
    static var previews: some View {
        ComplementaryColors(levelCompleted: $temp).preferredColorScheme(.dark)
    }
}

public class ComplementaryColorsLevel : SKScene, ObservableObject{
    @Published var levelEnded : Bool = false
    var selectedNode : SKNode?
    var initialPoint = CGPoint(x:0,y:0)
    var swapNode : SKNode?
    let firstColumn = ["#4e2b76", "#e95a28", "#f28923","#f7b92d","#e6433e" ] //red, purple, blue, green, yellow, orange
    let secondColumn = ["#bd0b48","#1f93a2","#e64452","#81b630","#a7cf69"]
    let thirdColumn = ["#97095b", "#a2156a","#65267e", "#28a970", "#71bf88"]
    let fourthColumn = ["#6a1665","#ce1847", "#714a9a", "#c13b88", "#4bb6a8"]
    let fifthColumn = ["#44b8c7", "#26408c","#1364a7", "#1d88b5", "#f6ee66"]
    var finalColors = ["#e6433e":0, "#e95a28":1, "#f28923":2,"#f7b92d":3, "#f6ee66":4,"#bd0b48":5, "#ce1847":6, "#e64452":7,"#81b630":8, "#a7cf69":9,"#97095b":10, "#a2156a":11,"#c13b88":12, "#28a970":13, "#71bf88":14,"#6a1665":15, "#65267e":16,"#714a9a":17, "#1f93a2":18, "#4bb6a8":19,"#4e2b76":20, "#26408c":21,"#1364a7":22, "#1d88b5":23, "#44b8c7":24]
    var winCheck = [CGFloat:Int]()
    var ypos = UIScreen.main.bounds.midY
    var order = [Int]()
    var positions = [CGPoint]()
    let heightofBlock = UIScreen.main.bounds.height/11
    var xpos = UIScreen.main.bounds.midX - UIScreen.main.bounds.height/5.5
    var touchCount = 0
    let firstClick = SKAction.playSoundFileNamed("click_002.wav",waitForCompletion: false)
    let secondClick = SKAction.playSoundFileNamed("click_003.wav",waitForCompletion: false)
    let levelEndedSound = SKAction.playSoundFileNamed("impactMining_002.wav",waitForCompletion: false)
    public override func didMove(to view: SKView) {
        xpos = xpos.rounded()
        ypos = UIScreen.main.bounds.midY + heightofBlock.rounded()*3
        ypos = ypos.rounded()
        self.backgroundColor = .black
        for i in 0...firstColumn.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.firstColumn[i]), size: CGSize(width: self.heightofBlock.rounded(), height: self.heightofBlock.rounded()))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.ypos = self.ypos - self.heightofBlock.rounded()
            block.name = "block"
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.firstColumn[i]]!)
            if i != 0 && i != firstColumn.count-1{
                block.name = "locked"
                lock.position = CGPoint(x: self.xpos, y: self.ypos)
                self.addChild(lock)
            }
        }
        xpos = xpos + heightofBlock.rounded()
        ypos = UIScreen.main.bounds.midY + heightofBlock.rounded()*3
        ypos = ypos.rounded()
        for i in 0...secondColumn.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.secondColumn[i]), size: CGSize(width: self.heightofBlock.rounded(), height: self.heightofBlock.rounded()))
            self.ypos = self.ypos - self.heightofBlock.rounded()
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.secondColumn[i]]!)
            if i != 1 && i != secondColumn.count-2{
                block.name = "locked"
                self.addChild(lock)
            }
        }
        xpos = xpos + heightofBlock.rounded()
        ypos = UIScreen.main.bounds.midY + heightofBlock.rounded()*3
        ypos = ypos.rounded()
        for i in 0...thirdColumn.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.thirdColumn[i]), size: CGSize(width: self.heightofBlock.rounded(), height: self.heightofBlock.rounded()))
            self.ypos = self.ypos - self.heightofBlock.rounded()
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.thirdColumn[i]]!)
            if i != 2 {
                block.name = "locked"
                self.addChild(lock)
            }
        }
        xpos = xpos + heightofBlock.rounded()
        ypos = UIScreen.main.bounds.midY + heightofBlock.rounded()*3
        ypos = ypos.rounded()
        for i in 0...fourthColumn.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.fourthColumn[i]), size: CGSize(width: self.heightofBlock.rounded(), height: self.heightofBlock.rounded()))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.ypos = self.ypos - self.heightofBlock.rounded()
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.fourthColumn[i]]!)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            if i != 1 && i != fourthColumn.count-2{
                block.name = "locked"
                self.addChild(lock)
            }
        }
        xpos = xpos + heightofBlock.rounded()
        ypos = UIScreen.main.bounds.midY + heightofBlock.rounded()*3
        ypos = ypos.rounded()
        for i in 0...fifthColumn.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.fifthColumn[i]), size: CGSize(width: self.heightofBlock.rounded(), height: self.heightofBlock.rounded()))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.ypos = self.ypos - self.heightofBlock.rounded()
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.fifthColumn[i]]!)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            if i != 0 && i != fifthColumn.count-1{
                block.name = "locked"
                self.addChild(lock)
            }
        }
        
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
            node.xScale = 1.06
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
                    run(secondClick)
                    guard let node = self.selectedNode else { return }
                    self.swapNode = nodesFound.last
                    guard let endnode = swapNode else { return }
                    if node.name != "locked" && endnode.name != "locked" && node.name != "image" && endnode.name != "image"
                    {
                        temp = node.position
                        let swapTemp = order[positions.firstIndex(of: node.position)!]
                        order[positions.firstIndex(of: node.position)!] = order[positions.firstIndex(of: endnode.position)!]
                        let nodemoveAnimation = SKAction.move(to: endnode.position, duration: 0.15)
                        node.run(nodemoveAnimation)
                        order[positions.firstIndex(of: endnode.position)!] = swapTemp
                        let endnodemoveAnimation = SKAction.move(to: temp, duration: 0.15)
                        endnode.run(endnodemoveAnimation)
                        node.yScale = 1
                        endnode.yScale = 1
                        node.xScale = 1
                        endnode.xScale = 1
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
