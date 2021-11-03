//
//  ViewModel.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/10/31.
//


import os.log
import CloudKit
import Combine

final class ViewModel: ObservableObject {
    @Published var state = 0 //0 -> 未記録, 1 -> 記録, 2 -> 一時停止
    @Published var activeTaskName = "" //アクティブなタスク
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var elapsedTime: Int = 0
    @Published var totalElapsedTime_last: Int = 0 //累積
    @Published var totalElapsedTime: Int = 0 //累積
    private var timer: AnyCancellable!
    
    // タイマーの開始
    func start(_ interval: Double = 1.0){
        print("start Timer")

        // TimerPublisherが存在しているときは念の為処理をキャンセル
        if let _timer = timer{
            _timer.cancel()
        }
        
        self.startTime = Date()

        timer = Timer.publish(every: interval, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: ({_ in
                self.elapsedTime = Int(Date().timeIntervalSince(self.startTime))
                print(self.elapsedTime)
                
        }))

    }
    // タイマーの停止
    func stop(){
        print("stop Timer")
        timer?.cancel()
        timer = nil
    }
    
//    func addTaskRecord(taskCategoryName: String){
//        let taskRecord = CKRecord(recordType: "TaskRecord")
//        taskRecord["TaskCategoryName"]   = taskCategoryName as NSString
//        taskRecord["StartTime"]  = self.startTime                as NSDate
//        taskRecord["EndTime"]  = self.endTime                as NSDate
//        taskRecord["ElapsedTime"] = self.totalElapsedTime as NSInteger
//        database.save(taskRecord) {
//           (record, error) in
//           if let error = error {
//               print(error)
//               // Insert error handling
//               return
//           }
//           // Insert successfully saved record code
//           print("successfully saved record")
//        }
//    }

}
