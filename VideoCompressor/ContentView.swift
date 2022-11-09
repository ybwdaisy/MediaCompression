//
//  ContentView.swift
//  VideoCompressor
//
//  Created by ybw-macbook-pro on 2022/11/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("It's been a long day without you, my friend")
                    Divider()
                    Text("And I'll tell you all about it when I see you again")
                    Divider()
                    Text("We've come a long way from where we began")
                    Divider()
                    Text("Oh, I'll tell you all about it when I see you again")
                    Divider()
                    Text("When I see you again")
                    Divider()
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("Damn, who knew?")
                    Divider()
                    Text("All the planes we flew, good things we been through")
                    Divider()
                    Text("That I'd be standing right here talking to you")
                    Divider()
                    Text("'Bout another path, I know we loved to hit the road and laugh")
                    Divider()
                    Text("But something told me that it wouldn't last")
                    Divider()
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("Had to switch up, look at things different, see the bigger picture")
                    Divider()
                    Text("Those were the days, hard work forever pays")
                    Divider()
                    Text("Now I see you in a better place (see you in a better place)")
                    Divider()
                    Text("Uh")
                    Divider()
                    Text("How can we not talk about family when family's all that we got?")
                    Divider()
                }
                .padding()
                VStack(alignment: .leading) {
                    
                    Text("Everything I went through, you were standing there by my side")
                    Divider()
                    Text("And now you gon' be with me for the last ride")
                    Divider()
                    Text("It's been a long day without you, my friend")
                    Divider()
                    Text("And I'll tell you all about it when I see you again (I'll see you again)")
                    Divider()
                    Text("We've come a long way (yeah, we came a long way)")
                    Divider()
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("From where we began (you know we started)")
                    Divider()
                    Text("Oh, I'll tell you all about it when I see you again (I'll tell you)")
                    Divider()
                    Text("When I see you again")
                    Divider()
                    Text("First, you both go out your way and the vibe is feeling strong")
                    Divider()
                    Text("And what's small turned to a friendship, a friendship turned to a bond")
                    Divider()
                    
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("And that bond will never be broken, the love will never get lost")
                    Divider()
                    Text("(The love will never get lost)")
                    Divider()
                    Text("And when brotherhood come first, then the line will never be crossed")
                      Divider()
                    Text("Established it on our own when that line had to be drawn")
                    Divider()
                    Text("And that line is what we reached, so remember me when I'm gone")
                    Divider()
                    
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("(Remember me when I'm gone)")
                    Divider()
                    Text("How can we not talk about family when family's all that we got?")
                    Divider()
                    Text("Everything I went through you were standing there by my side")
                    Divider()
                    Text("And now you gon' be with me for the last ride")
                    Divider()
                    Text("So let the light guide your way, yeah")
                    Divider()
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("Hold every memory as you go")
                    Divider()
                    Text("And every road you take")
                    Divider()
                    Text("Will always lead you home, home")
                    Divider()
                    Text("It's been a long day without you, my friend")
                    Divider()
                    Text("And I'll tell you all about it when I see you again")
                    Divider()
                    
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("We've come a long way from where we began")
                    Divider()
                    Text("Oh, I'll tell you all about it when I see you again")
                    Divider()
                    Text("When I see you again")
                    Divider()
                    Text("When I see you again (yeah, uh)")
                    Divider()
                    Text("See you again (yeah, yeah, yeah)")
                    Divider()
                }
                .padding()
            }
            .navigationTitle("导航")
            .navigationBarItems(
                trailing:
                    NavigationLink {
                        
                    } label: {
                        Image(systemName: "gear")
                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
