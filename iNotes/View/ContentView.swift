//
//  ContentView.swift
//  iNotes
//
//  Created by Aayam Adhikari on 14/09/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    // MARK: - PROPERTY
    
    @State var task: String = ""  // to hold the value that user enter in the text field
    
    // to check whether the TEXTFIELD is empty or not
    private var isButtonDisabled: Bool {
        task.isEmpty  // "true" when no character has been typed in the TEXTFIELD
    }
    
    // FETCHING DATA
    // MANAGED OBJECT CONTEXT: An environment where we can manipulate Core Data objects entirely in RAM
    @Environment(\.managedObjectContext) private var viewContext // viewContext is a SCRATCHPAD to retrieve, update, and store objects

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    // to hold all items from the FetchRequest query result
    private var items: FetchedResults<Item>
    
    
    //MARK: - FUNCTIONS
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            // ADD TASK ITEM WHEN USER PRESS SAVE
            newItem.task = task
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
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    VStack(spacing: 16) {
                        TextField("New Task", text: $task)
                            .padding()
                            .background(
                                Color(UIColor.systemGray6)
                            )
                            .cornerRadius(10)
                        
                        Button {
                            // ACTION
                            addItem()
                        } label: {
                            Spacer()
                            Text("SAVE")
                            Spacer()
                        }
                        .disabled(isButtonDisabled)
                        .padding()  // vitra padding
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(isButtonDisabled ? Color.gray : Color.pink)
    //                    .padding()  // bahira padding
                        .cornerRadius(10)

                    } //: VSTACK
                    .padding()
                    
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")

                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)

                                    Text(item.timestamp!, formatter: itemFormatter)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }  //: LIST ITEM
                            }
                        }
                        .onDelete(perform: deleteItems)
                        
                    }  //: LIST
//                    .listStyle(PlainListStyle())
//                    .cornerRadius(12)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)  // remove default vertical padding and maximize the list on iPad devices
//                    .padding()
                   
                } //: VSTACK
                
            } //: ZSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
        } //: TOOLBAR
        .background(
            BackgroundImageView()
        )
        .background(
            backgroundGradient.ignoresSafeArea(.all)
        )
            
            
        } //: NAVIGATION
//        .navigationViewStyle(StackNavigationViewStyle())  // to support iPad devices if NavigationView is used
        
    } //: BODY
        

    
}


//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
