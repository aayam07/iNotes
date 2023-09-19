//
//  BackgroundImageView.swift
//  iNotes
//
//  Created by Aayam Adhikari on 19/09/2023.
//

import SwiftUI

struct BackgroundImageView: View {
    var body: some View {
        Image("rocket")
            .antialiased(true) // Antialiasing is a technique that smooths out the edges of images, making them look less jagged when it is scaled up or down
            .resizable()
            .scaledToFill()  // fills its parent view
            .ignoresSafeArea(.all)
    }
}

struct BackgroundImageView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundImageView()
    }
}
