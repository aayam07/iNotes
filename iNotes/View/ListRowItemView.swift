//
//  ListRowItemView.swift
//  iNotes
//
//  Created by Aayam Adhikari on 28/09/2023.
//

import SwiftUI

struct ListRowItemView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    // to observe and save all checkbox changes. everytime we toggle the checkbox or vice-versa,
    // this object will invalidate the view and its value
    @ObservedObject var item: Item
    
    var body: some View {
        Toggle(isOn: $item.completion) {
            Text(item.task ?? "")
                .font(.system(.title2, design: .rounded))
                .fontWeight(.heavy)
                .foregroundColor(item.completion ? Color.pink : Color.primary)
                .padding(.vertical, 12)
                .animation(.default, value: item.completion) // toggle ma press garda label ma animation provide garne
        }  //: TOGGLE
        .toggleStyle(CheckboxStyle())
        // to achieve UPDATE functionality in the data store
        .onReceive(item.objectWillChange, perform: { _ in
            if self.viewContext.hasChanges {
                try? self.viewContext.save()
            }
        })
    }
}


