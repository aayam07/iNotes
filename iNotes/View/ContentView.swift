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
    
    // to store the appearance state permanently in the SwiftUI's user defaults
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false // default appearance is light
    
    @State var task: String = ""  // to hold the value that user enter in the text field
    @State private var showNewTaskItem: Bool = false // to store the actual state of new task item view
    
    
    // FETCHING DATA
    // MANAGED OBJECT CONTEXT: An environment where we can manipulate Core Data objects entirely in RAM
    @Environment(\.managedObjectContext) private var viewContext // viewContext is a SCRATCHPAD to retrieve, update, and store objects

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    
    // to hold all items from the FetchRequest query result
    private var items: FetchedResults<Item>
    
    
    //MARK: - FUNCTIONS
    
    

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
                //MARK: - MAIN VIEW
                VStack {
                    //MARK: - HEADER
                    
                    HStack(spacing: 10) {
                        // TITLE
                        Text("iNotes")
                            .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                            .padding(.leading, 4)
                        
                        Spacer()
                        
                        // EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(
                                Capsule()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                        // APPEARANCE BUTTON
                        
                        Button {
                            // TOGGLE APPEARANCE
                            isDarkModeEnabled.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            hepticFeedback.notificationOccurred(.success)
                        } label: {
                            Image(systemName: isDarkModeEnabled ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }

                    } //: HSTACK
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    
                    //MARK: - NEW TASK BUTTON
                    Button {
                        showNewTaskItem = true
                        playSound(sound: "sound-ding", type: "mp3")
                        hepticFeedback.notificationOccurred(.success)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.pink, Color.blue]), startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                            
                    )
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 8, x: 0.0, y: 4.0)

                    
                    //MARK: - TASKS
                    List {
                        ForEach(items) { item in
//                            NavigationLink {
//                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//
//                            } label: {
//                                VStack(alignment: .leading, spacing: 10) {
//                                    Text(item.task ?? "")
//                                        .font(.headline)
//                                        .fontWeight(.bold)
//
//                                    Text(item.timestamp!, formatter: itemFormatter)
//                                        .font(.footnote)
//                                        .foregroundColor(.gray)
//                                }  //: LIST ITEM
//                            }
                            
                            ListRowItemView(item: item)
                           
                        }
                        .onDelete(perform: deleteItems)
                        
                    }  //: LIST
                    .listStyle(PlainListStyle())
                    .cornerRadius(12)
//                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)  // remove default vertical padding and maximize the list on iPad devices
                    .padding()
                   
                } //: VSTACK
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(Animation.easeInOut(duration: 0.3), value: showNewTaskItem)  // showNewTaskItem ko value change huda animation apply garne jun jun thau ma yo property use vayeko cha
                
                //MARK: - NEW TASK ITEM VIEW
                if showNewTaskItem {
                    BlankView(
                        backgroundColor: isDarkModeEnabled ? Color.black : Color.gray,
                        backgroundOpacity: isDarkModeEnabled ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation() {
                                showNewTaskItem = false
                            }
                        }
                    NewTaskItemView(isShowing: $showNewTaskItem) // creating a binding between showNewTaskItem in this view and isShowing porperty in NewTaskItemView
                }
                
            } //: ZSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationTitle("Daily Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(.hidden) // to hide the navigation bar
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
////                ToolbarItem {
////                    Button(action: addItem) {
////                        Label("Add Item", systemImage: "plus")
////                    }
////                }
//        } //: TOOLBAR
        .background(
            BackgroundImageView()
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .transition(.move(edge: .bottom))
                .animation(Animation.easeInOut(duration: 0.3), value: showNewTaskItem)  // showNewTaskItem ko value change huda animation apply garne jun jun thau ma yo property use vayeko cha
            
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
