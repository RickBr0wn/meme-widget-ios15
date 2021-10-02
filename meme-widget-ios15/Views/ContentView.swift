//
//  ContentView.swift
//  meme-widget-ios15
//
//  Created by Rick Brown on 02/10/2021.
//

import SwiftUI

struct ContentView: View {
  @State private var meme: Meme? = nil
  
  var body: some View {
    VStack {
      Text("Want a meme?")
        .font(.title)
      
      // Meme Image
      AsyncImage(url: meme?.url) { image in
        image
          .resizable()
          .scaledToFit()
          .frame(width: 400, height: 400)
      } placeholder: {
        VStack {
          ProgressView()

          Text("Cooking up a fresh meme..")
        }
      }
      
      Button("give me another meme!".uppercased()) {
        Task {
          do {
            self.meme = try await MemeService.shared.getMeme()
          } catch let error {
            print("There has been an error: \(error.localizedDescription)")
          }
        }
      }
    }
    .task {
      do {
        self.meme = try await MemeService.shared.getMeme()
      } catch let error {
        print("There has been an error: \(error.localizedDescription)")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
