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
    let taskName: String
    
    var body: some View {
        VStack(){
            HStack(){
                Text(String(format: "%02d:%02d", (vm.totalElapsedTime_last + vm.elapsedTime) / 60, (vm.totalElapsedTime_last + vm.elapsedTime) % 60))
                    .padding()
                Button(action: {
                    vm.stop()
                    vm.totalElapsedTime_last += vm.elapsedTime
                    vm.elapsedTime = 0
                    print(vm.totalElapsedTime_last)
                }){
                    Text("一時停止")
                        .padding()
                }
            }
            HStack(){
                Button(action: {
                        vm.activeTaskName = taskName
                        vm.start()
                }){
                    Text("開始")
                        .padding()
                }
                Button(action: {
                    vm.activeTaskName = ""
                    vm.endTime = Date()
                    vm.stop()
                    vm.totalElapsedTime = vm.totalElapsedTime_last + vm.elapsedTime
                    vm.totalElapsedTime_last = 0
                    let record = MyTaskRecord(context: managedObjectContext)
                    record.endTime = vm.endTime
                    record.startTime = vm.startTime
                    record.elapsedTime = Int16(vm.totalElapsedTime)
                    record.taskName = taskName
                    do {
                        try managedObjectContext.save()
                        print("success to save record")
                    } catch {
                        print(error)
                        print("fail to save record")
                    }

                }){
                    Text("終了")
                        .padding()
                }
            }
        }
        .navigationBarTitle(Text(taskName))
        
    }
}
