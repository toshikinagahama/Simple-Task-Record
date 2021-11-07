//
//  TaskRecordView.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/10/31.
//

import SwiftUI


struct TaskRecordView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var vm: ViewModel
    public let task: MyTask //タスク
    
    var body: some View {
        VStack(){
            Group{
                if vm.state == 0{
                    Text("not recording")
                        .foregroundColor(.gray)
                }else if vm.state == 1{
                    Text("recording")
                        .foregroundColor(.red)
                }else if vm.state == 2{
                    Text("pause")
                        .foregroundColor(.yellow)
                }
            }
            HStack(){
                Text(String(format: "%02d:%02d", (vm.totalElapsedTime_last + vm.elapsedTime) / 60, (vm.totalElapsedTime_last + vm.elapsedTime) % 60))
                    .padding()
                //                if vm.state == 1{
                //                    Button(action: {
                //                        vm.pause()
                //                    }){
                //                        Text("一時停止")
                //                            .padding()
                //                    }
                //                }else if vm.state == 2{
                //                    Button(action: {
                //                        vm.resume()
                //                    }){
                //                        Text("再開")
                //                            .padding()
                //                    }
                //                }
            }
            Group{
                if vm.state == 0{
                    NavigationLink(
                        destination: TimePickerView(task: task)
                            .environmentObject(vm))
                    {
                        Text("開始")
                            .padding()
                    }
                }else{
                    NavigationLink(
                        destination: TimePickerView(task: task)
                            .environmentObject(vm).environment(\.managedObjectContext, self.managedObjectContext))
                    {
                        Text("終了")
                            .padding()
                    }
                }
            }
        }
        .navigationBarTitle(Text(task.name ?? ""))
        
    }
}
