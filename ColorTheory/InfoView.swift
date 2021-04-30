//
//  InfoView.swift
//  ColorTheory
//
//  Created by Magesh Sridhar on 4/20/21.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Text("About the game").font(.title).bold()
                Spacer()
                Button(action:{presentationMode.wrappedValue.dismiss()}){
                    Image(systemName: "xmark.circle.fill").font(.title).foregroundColor(.white)
                }
            }.padding()
            Image("colorsbackground").resizable().aspectRatio(contentMode: .fit)
            Text("Photo from UnSplash").font(.caption).padding(.horizontal)
            Text("Hello there! Today we are going to learn color theory in a fun and interactive way. But why do you need to know the color theory? It explains the way you perceive colors and how colors form harmony when they mix or match together. Color Theory shows how colors communicate with each other, and it mainly helps in branding. The following lessons will teach you the concepts in Color Theory, and you will be a master of the perception of colors in no time. So, let's get started.").padding()
            Spacer()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView().preferredColorScheme(.dark)
    }
}
