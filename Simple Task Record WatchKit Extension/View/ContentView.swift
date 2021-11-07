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
        animation: .default)  private var tasks: FetchedResults<MyTask> //タスクの取得
    @State private var showingDeleteAlert = false //タスク削除アラート表示フラグ
    @State private var selectedTask = MyTask() //選択したタスク
    
    
    var body: some View {
        VStack{
            // CoreDataの中身を表示している，
            ScrollView {
                ForEach(tasks, id: \.self) { task in
                    //                    NavigationLink(destination: TaskRecordView(taskName: task.name ?? "")) {
                    NavigationLink(destination: TaskRecordView(task: task).environmentObject(vm).environment(\.managedObjectContext, self.managedObjectContext)) {
                        HStack{
                            Text(task.name ?? "")
                                .padding()
                                .padding(.vertical, 5)
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
                            self.showingDeleteAlert = true
                            self.selectedTask = task
                            print("trash")
                        }){
                            Image(systemName: "trash")
                        }
                        .tint(.red)
                    }
                }
                Spacer().frame(height: 30)
                NavigationLink(
                    destination: ExportDataView()
                        .environment(\.managedObjectContext, self.managedObjectContext))
                {
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .frame(width: 20, height: 20, alignment: .center)
                    Spacer()
                }
                .background(.blue)
                .cornerRadius(5)
                NavigationLink(
                    destination: AddNewTaskView()
                        .environment(\.managedObjectContext, self.managedObjectContext))
                {
                    Spacer()
                    Image(systemName: "plus")
                        .frame(width: 20, height: 20, alignment: .center)
                    Spacer()
                }
                .background(.red)
                .cornerRadius(5)

                NavigationLink(
                    destination: SettingView()
                        .environment(\.managedObjectContext, self.managedObjectContext))
                {
                    Spacer()
                    Image(systemName: "gear").frame(width: 20, height: 20, alignment: .center)
                    Spacer()
                }
                .background(.gray)
                .cornerRadius(5)
            }
        }
        .alert(isPresented: $showingDeleteAlert) {
            //タスク削除アラートダイアログ
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
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}
