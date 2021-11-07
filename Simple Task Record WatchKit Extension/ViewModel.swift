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
    //すべてのビューで参照できるクラス。Simple_Task_RecordAppでインスタンスを生成している。
    @Published var state = 0 //0 -> 未記録, 1 -> 記録, 2 -> 一時停止 ※一時停止は使わないことにした。
    @Published var activeTaskName = "" //アクティブなタスク
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var elapsedTime: Int = 0
    @Published var totalElapsedTime_last: Int = 0 //累積
    @Published var totalElapsedTime: Int = 0 //累積
    private var timer: AnyCancellable!
    
    // タイマーの開始
    func start(_taskName: String, _startTime: Date){
        print("start Timer")
        self.activeTaskName = _taskName
        // TimerPublisherが存在しているときは念の為処理をキャンセル
        if let _timer = timer{
            _timer.cancel()
        }
        self.state = 1
        self.startTime = _startTime
        
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: ({_ in
                self.elapsedTime = Int(Date().timeIntervalSince(self.startTime))
                print(self.elapsedTime)
                
            }))
        
    }
    // タイマーの停止
    func stop(_endTime: Date){
        self.state = 0
        self.activeTaskName = ""
        self.endTime = _endTime
        self.elapsedTime = Int(self.endTime.timeIntervalSince(self.startTime))
        self.totalElapsedTime = self.totalElapsedTime_last + self.elapsedTime
        self.totalElapsedTime_last = 0
        print("stop Timer")
        timer?.cancel()
        timer = nil
    }
    
//    // タイマーの一時停止
//    func pause(){
//        self.state = 2
//        self.totalElapsedTime_last += self.elapsedTime
//        self.elapsedTime = 0
//        print("pause Timer")
//        timer?.cancel()
//        timer = nil
//    }
//
//    // タイマーの再開
//    func resume(){
//        print("resume Timer")
//        //start(_taskName: self.activeTaskName)
//    }

}
