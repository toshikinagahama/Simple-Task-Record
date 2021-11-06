//
//  SettingView.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/11/03.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: MySetting.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MySetting.notification_time, ascending: true)],
        animation: .default)  private var settings: FetchedResults<MySetting>
    @State var timeVal: Int16 = 0
    
    init() {
    }

    var body: some View {
        VStack{
            Text("通知時間").font(.body)
            HStack{
                Picker(selection: $timeVal, label: Text("")) {
                    ForEach((0...999), id: \.self) { num in
                        Text("\(num)").tag(Int16(num)).font(.title)
                    }
                }
                Text("min")
            }
            Button(action: {
                do {
                    for s in settings {
                        s.setValue(self.timeVal, forKeyPath: "notification_time")
                    }
                    print("success to save setting")
                    try managedObjectContext.save()
                } catch {
                    print(error)
                    print("fail to save setting")
                }
            }, label:{
                Text("Save")
            })
        }.onAppear(perform: {
            if settings.count == 0{
                let s = MySetting(context: managedObjectContext)
                s.notification_time = 0
                do {
                    try managedObjectContext.save()
                    print("success to save setting")
                } catch {
                    print(error)
                    print("fail to save setting")
                }

            }else{
                print(settings)
            }
            self.timeVal = settings[0].notification_time
        })
        .navigationTitle("Setting")
    }
}
