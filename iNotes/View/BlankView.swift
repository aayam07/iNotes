//
//  BlankView.swift
//  iNotes
//
//  Created by Aayam Adhikari on 20/09/2023.
//

import SwiftUI

// TO ADD AS A SEMI-TRANSPARENT LAYER VIEW BETWEEN THE MAIN VIEW AND THE NEW TASK ITEM VIEW
struct BlankView: View {
    var body: some View {
        VStack {
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.black)
        .opacity(0.5)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView()
    }
}
