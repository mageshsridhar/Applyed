//
//  TriadicColors.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/20/21.
//

import SwiftUI
import SpriteKit
import GlassMorphismic

struct TriadicColors : View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var scene = TriadicColorsLevel()
    @State private var showHelp = false
    @Binding var levelCompleted : Bool
    var triadicLevel : SKScene{
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
                SpriteView(scene: triadicLevel)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
            
                HStack{
                    Text("Triadic Colors").bold().font(.title).padding(.leading).padding(.leading)
                    Spacer()
                }
                    Text("Triadic colors are evenly spaced around the color wheel and tend to be very bright and dynamic. Using a triadic color scheme in your design creates visual contrast and harmony simultaneously, making each item stand out while making the overall image pop.").padding(.horizontal).padding(.vertical,5).padding(.horizontal)
                Image("triadic").resizable().aspectRatio(contentMode: .fit).frame(width: UIScreen.main.bounds.width-40).clipShape(RoundedRectangle(cornerRadius: 20.0))
                Text("Photo from 99designs.com").font(.caption).padding(.vertical,8)
                Spacer()
                }
            }
            if scene.levelEnded{
                GlassMorphismic(blurIntensity: 20, cornerRadius: 0, shadowRadius: 0, blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("Level Completed!").font(.largeTitle).bold()
                    HStack{
                        Circle().fill(Color.red).frame(width: 40, height:40)
                        Circle().fill(Color.yellow).frame(width: 50, height:50)
                        Circle().fill(Color.blue).frame(width: 40, height:40)
                    }
                    Text("Recap").font(.title).padding()
                    Text("Triadic colors are equally spaced from one another in the color wheel.")
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
                    Text("Arrange the colors in the triangular border such a way that they transition smoothly from left to right in each row.")
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
struct TriadicColors_Previews: PreviewProvider {
    @State static var temp = false
    static var previews: some View {
        TriadicColors(levelCompleted: $temp).preferredColorScheme(.dark)
    }
}
public class TriadicColorsLevel : SKScene,ObservableObject{
    @Published var levelEnded = false
    var selectedNode : SKNode?
    var initialPoint = CGPoint(x:0,y:0)
    var swapNode : SKNode?
    let firstRow = ["#e32535"]
    let secondRow = ["#156fa0","#e6475c","#c63383"]
    let thirdRow = ["#f6ac3f","#ef805d","#e8627d","#be5898","#24a690"]
    let fourthRow = ["#f7e06b","#7e58a2","#5bb673","#ed7231","#9fcb5a","#1f8da3","#34669a"]
    var finalColors = ["#e32535":0,"#ed7231":1,"#e6475c":2,"#c63383":3,"#f6ac3f":4,"#ef805d":5,"#e8627d":6,"#be5898":7,"#7e58a2":8,"#f7e06b":9,"#9fcb5a":10,"#5bb673":11,"#24a690":12,"#1f8da3":13,"#156fa0":14,"#34669a":15]
    var winCheck = [CGFloat:Int]()
    var ypos = UIScreen.main.bounds.midY + 100
    var xpos = UIScreen.main.bounds.midX
    var order = [Int]()
    var positions = [CGPoint]()
    let widthofBlock = UIScreen.main.bounds.width/8
    var touchCount = 0
    let firstClick = SKAction.playSoundFileNamed("click_002.wav",waitForCompletion: false)
    let secondClick = SKAction.playSoundFileNamed("click_003.wav",waitForCompletion: false)
    let levelEndedSound = SKAction.playSoundFileNamed("impactMining_002.wav",waitForCompletion: false)
    public override func didMove(to view: SKView) {
        self.backgroundColor = .black
        var i = 0
        xpos = xpos - widthofBlock
        while i<=self.firstRow.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.firstRow[i]), size: CGSize(width: self.widthofBlock, height: self.widthofBlock+20))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.xpos = self.xpos + self.widthofBlock
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.firstRow[i]]!)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            addChild(lock)
            block.name = "locked"
            i = i+1
        }
        xpos = UIScreen.main.bounds.midX - widthofBlock*2
        ypos = ypos - widthofBlock - 20
        i=0
        while i<=self.secondRow.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.secondRow[i]), size: CGSize(width: self.widthofBlock, height: self.widthofBlock+20))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.xpos = self.xpos + self.widthofBlock
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.secondRow[i]]!)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            if i != 0 && i != secondRow.count-1{
                block.name = "locked"
                self.addChild(lock)
            }
            i = i+1
        }
        xpos = UIScreen.main.bounds.midX - widthofBlock*3
        ypos = ypos - widthofBlock - 20
        i=0
        while i<=self.thirdRow.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.thirdRow[i]), size: CGSize(width: self.widthofBlock, height: self.widthofBlock+20))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.xpos = self.xpos + self.widthofBlock
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.thirdRow[i]]!)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            if i != 0 && i != thirdRow.count-1{
                block.name = "locked"
                self.addChild(lock)
            }
            i = i+1
        }
        xpos = UIScreen.main.bounds.midX - widthofBlock*4
        ypos = ypos - widthofBlock - 20
        i=0
        while i<=self.fourthRow.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.fourthRow[i]), size: CGSize(width: self.widthofBlock, height: self.widthofBlock+20))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.xpos = self.xpos + self.widthofBlock
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.fourthRow[i]]!)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            if i == 0 || i == fourthRow.count-1{
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
                    guard let node = self.selectedNode else { return }
                    self.swapNode = nodesFound.last
                    guard let endnode = swapNode else { return }
                    if node.name != "locked" && endnode.name != "locked" && node.name != "image" && endnode.name != "image"
                    {
                        run(secondClick)
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
