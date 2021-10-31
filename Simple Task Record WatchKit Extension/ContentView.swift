//
//  ContentView.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/10/27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State public var taskName = ""
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: MyTask.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MyTask.name, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<MyTask>
    
    var body: some View {
        VStack{
            Button(action: {
                do {
                    for task in tasks {
                        managedObjectContext.delete(task)
                    }

                    try managedObjectContext.save()
                } catch let error as NSError {
                    print("\(error)")
                }
            },
                   label: {
                Text("Delete Task")
            })
            TextField("Add Task", text: $taskName)
            Button(action: {
                if(taskName == ""){
                    return
                }
                let t = MyTask(context: managedObjectContext)
                t.name = taskName
                do {
                    try managedObjectContext.save()
                    print("success to save")
                    self.taskName = ""
                } catch {
                    print("fail to save")
                    self.taskName = ""
                }
            },
                   label: {
                Text("Add Task")
            })
            List {
               // CoreDataの中身を表示している，
                ForEach(tasks, id: \.self) { task in
                    Text(task.name!)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
