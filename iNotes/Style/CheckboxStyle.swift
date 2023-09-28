//
//  CheckboxStyle.swift
//  iNotes
//
//  Created by Aayam Adhikari on 28/09/2023.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    
    // function which will create a body for the toggle element
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            
            configuration.label
        } //: HSTACK
    }
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("Placeholder label", isOn: .constant(true))
            .toggleStyle(CheckboxStyle())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
