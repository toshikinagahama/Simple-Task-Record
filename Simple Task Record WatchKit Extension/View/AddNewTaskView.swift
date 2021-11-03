//
//  AddNewTaskView.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/10/31.
//

import SwiftUI

struct AddNewTaskView: View {
    @State public var taskName = ""
    @State private var showingAlert = false
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: MyTask.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MyTask.name, ascending: true)],
        animation: .default)  private var tasks: FetchedResults<MyTask>

    var body: some View {
        VStack{
            TextField("Input Task Name", text: $taskName)
            Spacer()
            Button(action: {
                self.showingAlert = true
            }, label:{
                Text("Add")
            })
                .tint(.orange)
                .disabled(taskName == "")
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Add Task really?"),
                        //                        message: Text("The connection to the server was lost."),
                        primaryButton: .default(
                            Text("OK"),
                            action: {
                                let t = MyTask(context: managedObjectContext)
                                t.name = taskName
                                print(t)
                                print(managedObjectContext)
                                do {
                                    try managedObjectContext.save()
                                    print("success to save task")
                                    self.taskName = ""
                                } catch {
                                    print(error)
                                    print("fail to save task")
                                    self.taskName = ""
                                }
                            }
                        ),
                        secondaryButton: .destructive(
                            Text("Cancel"),
                            action: {}
                        )
                    )
                }
            
        }
        .navigationTitle("Add Task")
    }
}
