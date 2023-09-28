//
//  NewTaskItemView.swift
//  iNotes
//
//  Created by Aayam Adhikari on 20/09/2023.
//

import SwiftUI

struct NewTaskItemView: View {
    //MARK: - PROPERTY
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false  // false is choosen for initialization purpose only
    
    // get access to the managed object context from the app's environment
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var task: String = ""
    
    // to communicate with the content view and let it know if this view is showing up in the screen or not
    @Binding var isShowing: Bool
    
    // to check whether the TEXTFIELD is empty or not
    private var isButtonDisabled: Bool {
        task.isEmpty  // "true" when no character has been typed in the TEXTFIELD
    }
    
    //MARK: - FUNCTION
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            // ADD TASK ITEM WHEN USER PRESS SAVE
            newItem.task = self.task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()  // as this func is an extension for the View, it can be used here
            isShowing = false
        }
    }
    
    //MARK: - BODY
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                TextField("New Task", text: $task)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        isDarkMode ? Color(UIColor.tertiarySystemBackground) : Color(UIColor.secondarySystemBackground)
                    )
                    .cornerRadius(10)
                
                Button {
                    // ACTION
                    addItem()
                } label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                }
                .disabled(isButtonDisabled)
                .padding()  // vitra padding
//                .font(.headline)
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.blue : Color.pink)
//                    .padding()  // bahira padding
                .cornerRadius(10)

            } //: VSTACK
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                isDarkMode ? Color(UIColor.secondarySystemBackground) : Color.white
            )
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
            .frame(maxWidth: 640)
        } //: VSTACK
        .padding()
    }
}

//MARK: - PREVIEW
struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
}
