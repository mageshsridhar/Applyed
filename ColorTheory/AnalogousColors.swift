//
//  AnalogousColors.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/20/21.
//

import SwiftUI
import SpriteKit
import GlassMorphismic

struct AnalogousColors: View{
    @Environment(\.presentationMode) var presentationMode
    @StateObject var scene = AnalogousColorsLevel()
    @Binding var levelCompleted : Bool
    @State private var showHelp = false
    let bluegreen = Color(hexStringToUIColor(hex: "#007b8a"))
    var analogousLevel : SKScene{
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
                SpriteView(scene: analogousLevel)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3.7)
            
                HStack{
                    Text("Analogous Colors").bold().font(.title).padding(.leading).padding(.leading)
                    Spacer()
                }
                HStack{
                    Text("Analogous colors are colors adjacent to one another on the color wheel—for example, red, orange, and yellow. When creating an analogous color scheme, one color will dominate, one will support, and another will accent.").padding(.horizontal).padding(.vertical,5).padding(.horizontal)
                    Spacer()
                }
                Image("analogous").resizable().aspectRatio(contentMode: .fill).frame(width: UIScreen.main.bounds.width-40).clipShape(RoundedRectangle(cornerRadius: 20.0))
                Text("Photo from 99designs.com").font(.caption).padding(.vertical,8)
                Spacer()
            }
            }
            if scene.levelEnded{
                GlassMorphismic(blurIntensity: 20, cornerRadius: 0, shadowRadius: 0, blurStyle: .systemChromeMaterialDark).ignoresSafeArea()
                VStack{
                    Text("Level Completed!").font(.largeTitle).bold()
                    HStack{
                        Circle().fill(Color.blue).frame(width: 40, height: 40)
                        Circle().fill(bluegreen).frame(width: 50, height: 50)
                        Circle().fill(Color.green).frame(width: 40, height: 40)
                    }
                    Text("Recap").font(.title).padding()
                    Text("Analogous colors are adjacent colors in the color wheel.")
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
                    Text("Arrange the colors in such a way that they transition smoothly from left to right in each row.")
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
struct AnalagousColors_Previews: PreviewProvider {
    @State static var temp = false
    static var previews: some View {
        AnalogousColors(levelCompleted: $temp)
            .preferredColorScheme(.dark)
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
    }
}

public class AnalogousColorsLevel : SKScene, ObservableObject{
    @Published var levelEnded : Bool = false
    var selectedNode : SKNode?
    var initialPoint = CGPoint(x:0,y:0)
    var swapNode : SKNode?
    let firstRow = ["#f8e16c","#008a6f","#5a400e","#1f536f"]
    let secondRow = ["#8eb348","#52600e","#4ca05e","#005666","#008b8e","#233d4d"]
    let thirdRow = ["#178138","#007072","#6abf7d","#4c2719"]
    var finalColors = ["#f8e16c":0, "#6abf7d":1,"#008b8e":2,"#1f536f":3,"#8eb348":4, "#4ca05e":5,"#008a6f":6,"#007072":7,"#005666":8,"#233d4d":9,"#178138":10, "#52600e":11,"#5a400e":12,"#4c2719":13]
    var winCheck = [CGFloat:Int]()
    var xpos = UIScreen.main.bounds.midX
    var ypos = UIScreen.main.bounds.midY
    var order = [Int]()
    var positions = [CGPoint]()
    let widthofBlock = UIScreen.main.bounds.width/7
    var touchCount = 0
    let firstClick = SKAction.playSoundFileNamed("click_002.wav",waitForCompletion: false)
    let secondClick = SKAction.playSoundFileNamed("click_003.wav",waitForCompletion: false)
    let levelEndedSound = SKAction.playSoundFileNamed("impactMining_002.wav",waitForCompletion: false)
    public override func didMove(to view: SKView) {
        self.backgroundColor = .black
        var i = 0
        xpos = xpos - widthofBlock*2.5
        ypos = ypos + widthofBlock + 20
        while i<=self.firstRow.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.firstRow[i]), size: CGSize(width: self.widthofBlock, height: self.widthofBlock + 20))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.xpos = self.xpos + self.widthofBlock
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.firstRow[i]]!)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            if i == 0 || i==firstRow.count-1{
                block.name = "locked"
                lock.name = "locked"
                self.addChild(lock)
            }
            i = i+1
        }
        xpos = UIScreen.main.bounds.midX - widthofBlock*3.5
        ypos = ypos - widthofBlock - 20
        i=0
        while i<=self.secondRow.count-1{
            let block = SKSpriteNode(color: hexStringToUIColor(hex: self.secondRow[i]), size: CGSize(width: self.widthofBlock, height: self.widthofBlock + 20))
            let lock = SKSpriteNode(texture: SKTexture(image: UIImage.init(systemName: "lock.fill")!),size: CGSize(width: 8, height: 10))
            self.xpos = self.xpos + self.widthofBlock
            block.position = CGPoint(x: self.xpos, y: self.ypos)
            self.addChild(block)
            self.positions.append(block.position)
            self.order.append(self.finalColors[self.secondRow[i]]!)
            lock.position = CGPoint(x: self.xpos, y: self.ypos)
            block.name = "block"
            if i == 0 || i==secondRow.count-1{
                block.name = "locked"
                self.addChild(lock)
            }
            i = i+1
        }
        xpos = UIScreen.main.bounds.midX - widthofBlock*2.5
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
            if i == 0 || i==thirdRow.count-1{
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
                            run(self.firstClick)
                            self.selectedNode = nodesFound.last
                            print(self.selectedNode!.position)
                    }
                }
                else if touchCount == 2{
                    run(self.secondClick)
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
                            run(self.levelEndedSound)
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
