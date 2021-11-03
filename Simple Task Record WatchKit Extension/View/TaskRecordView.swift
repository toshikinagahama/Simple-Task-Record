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
    @State var showingSaveResultAlert = false //保存時アラート表示フラグ
    @State var alertTitle = "" //保存時アラートタイトル
    @State var alertMessage = "" //保存時アラートメッセージ
    let taskName: String //アクティブタスク
    
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
                if vm.state == 1{
                    Button(action: {
                        vm.pause()
                    }){
                        Text("一時停止")
                            .padding()
                    }
                }else if vm.state == 2{
                    Button(action: {
                        vm.resume()
                    }){
                        Text("再開")
                            .padding()
                    }
                }
                
            }
            if vm.state == 0{
                Button(action: {
                    vm.pause()
                }){
                    Button(action: {
                        vm.start(_taskName: taskName)
                    }){
                        Text("開始")
                            .padding()
                    }
                }
            }else{
                Button(action: {
                    vm.stop()
                    let record = MyTaskRecord(context: managedObjectContext)
                    record.endTime = vm.endTime
                    record.startTime = vm.startTime
                    record.elapsedTime = Int16(vm.totalElapsedTime)
                    record.taskName = taskName
                    do {
                        try managedObjectContext.save()
                        print("success to save record")
                        self.alertTitle = "success to save"
                        self.alertMessage = String(format: "Time is %02d:%02d", (vm.totalElapsedTime) / 60, (vm.totalElapsedTime) % 60)
                        self.showingSaveResultAlert = true
                    } catch {
                        print(error)
                        self.alertTitle = "fail to save"
                        self.alertMessage = ""
                        self.showingSaveResultAlert = true
                        print("fail to save record")
                    }
                    
                }){
                    Text("終了")
                        .padding()
                }
            }
       }
      .alert(isPresented: $showingSaveResultAlert) {
           Alert(
               title: Text(alertTitle),
               message: Text(alertMessage)
           )
       }
        .navigationBarTitle(Text(taskName))
        
    }
}
