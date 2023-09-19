//
//  HideKeyboardExtension.swift
//  iNotes
//
//  Created by Aayam Adhikari on 19/09/2023.
//

import SwiftUI

// THE CODE INSIDE THIS CONDITION WILL ONLY RUN WHEN WE CAN IMPORT THE UIKit FRAMEWORK

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
