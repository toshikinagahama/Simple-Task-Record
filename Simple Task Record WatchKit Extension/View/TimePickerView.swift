//
//  TimePickerView.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/11/07.
//

import SwiftUI

struct TimePickerView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var vm: ViewModel
    @State var showingSaveResultAlert = false //保存時アラート表示フラグ
    @State var alertTitle = "" //保存時アラートタイトル
    @State var alertMessage = "" //保存時アラートメッセージ
    @State var year: Int = 0 //選択年
    @State var month: Int = 0 //選択月
    @State var day: Int = 0 //選択日
    @State var hour: Int = 0 //選択時
    @State var minute: Int = 0 //選択分
    @State var second: Int = 0 //選択秒
    @State var zoneLevel: Int = 5 //集中度
    @State var difficultyLevel: Int = 5 //難易度
    @State var memo = "" //メモ
    @State var navTitle = ""
    @State var task: MyTask
    
    var body: some View {
        ScrollView{
            HStack{
                Picker(selection: $hour, label: Text("")) {
                    ForEach((0...23), id: \.self) { num in
                        Text(String(format: "%02d", num)).tag(Int16(num)).font(.title2)
                    }
                }
                Text(":")
                Picker(selection: $minute, label: Text("")) {
                    ForEach((0...59), id: \.self) { num in
                        Text(String(format: "%02d", num)).tag(Int16(num)).font(.title2)
                    }
                }
                
            }.frame(height: 70)
            Group{
                if vm.state == 1{
                    Spacer()
                        .frame(height: 60)
                    Text("your zone level")
                    Picker(selection: $zoneLevel, label: Text("")) {
                        ForEach((0...11), id: \.self) { num in
                            Text(String(format: "%d", num)).tag(Int16(num)).font(.title2)
                        }
                    }
                    .frame(height: 70)
                    Spacer()
                        .frame(height: 60)
                    Text("difficulty level for you")
                    Picker(selection: $difficultyLevel, label: Text("")) {
                        ForEach((0...11), id: \.self) { num in
                            Text(String(format: "%d", num)).tag(Int16(num)).font(.title2)
                        }
                    }
                    .frame(height: 70)
                    Spacer()
                        .frame(height: 60)
                    TextField("memo", text: $memo)
                        .padding()
                    Spacer()
                        .frame(height: 40)
                }
            }
            Button(action: {
                let dateFormatter = DateFormatter()
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.dateFormat = "yyyy/MM/dd hh:mm:ss"
                let dateValue = String(format: "%04d/%02d/%02d %02d:%02d:%02d", self.year, self.month, self.day, self.hour, self.minute, self.second)
                let time = dateFormatter.date(from: dateValue)
                let now = Date()
                
                if vm.state == 0 {
                    if Int(now.timeIntervalSince(time!)) < 0 {
                        //開始時刻選択時、もし、未来を選択していたらだめ。
                        print("not allowed to select future")
                        
                    }else{
                        print("selected time is valid")
                        vm.start(_taskName: self.task.name ?? "", _startTime: time ?? Date())
                    }
                }else if vm.state == 1 {
                    if Int(now.timeIntervalSince(time!)) < 0 {
                        //開始時刻選択時、もし、未来を選択していたらだめ。
                        print("not allowed to select future")
                    }else{
                        print("selected time is valid")
                        vm.stop(_endTime: time ?? Date())
                        //データ保存
                        let record = MyTaskRecord(context: managedObjectContext)
                        record.endTime = vm.endTime
                        record.startTime = vm.startTime
                        record.elapsedTime = Int16(vm.totalElapsedTime)
                        record.zoneLevel = Int16(self.zoneLevel)
                        record.difficultyLevel = Int16(self.difficultyLevel)
                        record.memo = self.memo
                        record.mytask = task
                        do {
                            try managedObjectContext.save()
                            print(record)
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
                    }
                }
                self.presentation.wrappedValue.dismiss()
            }, label: {
                Text("OK")
            })
        }
        .alert(isPresented: $showingSaveResultAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage)
            )
        }
        .navigationBarTitle(Text(navTitle))
        .onAppear{
            //現在時刻の設定
            let date = Date()
            print(date)
            
            let calendar = Calendar(identifier: .gregorian)
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            self.year = dateComponents.year ?? 0
            self.month = dateComponents.month ?? 0
            self.day = dateComponents.day ?? 0
            self.hour = dateComponents.hour ?? 0
            self.minute = dateComponents.minute ?? 0
            self.second = dateComponents.second ?? 0

            if vm.state == 0{
                //開始時間
                self.navTitle = "Start at"
            }else{
                //終了時間
                self.navTitle = "End at"
            }
        }
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView(task: MyTask())
    }
}
