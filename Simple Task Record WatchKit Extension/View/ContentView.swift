//
//  ContentView.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/10/27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var vm: ViewModel
    @FetchRequest(
        entity: MyTask.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MyTask.name, ascending: true)],
        animation: .default)  private var tasks: FetchedResults<MyTask>
    @State private var showingAlert = false
    @State private var selectedTask = MyTask()
    
    
    var body: some View {
        //ScrollView{
        VStack{
            // CoreDataの中身を表示している，
            List {
                //Text("\(vm.elapsedTime)")
                ForEach(tasks, id: \.self) { task in
                    //                    NavigationLink(destination: TaskRecordView(taskName: task.name ?? "")) {
                    NavigationLink(destination: TaskRecordView(taskName: task.name ?? "").environmentObject(vm).environment(\.managedObjectContext, self.managedObjectContext)) {
                        HStack{
                            Text(task.name ?? "")
                                .padding()
                                .padding(.vertical, 10)
                            // 円形の描画
                            if vm.activeTaskName == task.name{
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 5, height: 5)
                            }else{
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                    .swipeActions{
                        Button(action: {
                            self.showingAlert = true
                            self.selectedTask = task
                            print("trash")
                        }){
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                        
                    }
                }
                NavigationLink(
                    destination: AddNewTaskView()
                        .environment(\.managedObjectContext, self.managedObjectContext),
                    label: {
                        Spacer()
                        Image(systemName: "plus")
                        Spacer()
                    }
                )
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Delete Task really?"),
                primaryButton: .default(
                    Text("OK"),
                    action: {
                        do {
                            managedObjectContext.delete(self.selectedTask)
                            try managedObjectContext.save()
                            print("delete task")
                        } catch let error as NSError {
                            print("\(error)")
                        }
                        
                    }
                ),
                secondaryButton: .destructive(
                    Text("Cancel"),
                    action: {}
                )
            )
        }
        
        //}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
