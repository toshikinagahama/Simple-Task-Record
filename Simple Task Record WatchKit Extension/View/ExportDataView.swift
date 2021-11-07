//
//  ExportDataView.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/11/07.
//

import SwiftUI

struct ExportDataView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        entity: MyTaskRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \MyTaskRecord.startTime, ascending: true)],
        animation: .default)  private var records: FetchedResults<MyTaskRecord> //タスクレコードの取得

    var body: some View {
        Button(action: {
            guard let url = URL(string: "https://script.google.com/macros/s/AKfycbyddkKOmnL5IbcPmlgOAk0u3h8UJPmcErR_ih_3K0oWcH6lkZhV/exec") else { return }
            
            var recordDicArray = Array<Dictionary<String, Any>>()
            for record in records {
                var tmp = Dictionary<String, Any>()
                tmp["taskName"] = record.mytask?.name ?? ""
                tmp["difficultyLevel"] = record.difficultyLevel
                tmp["zoneLevel"] = record.zoneLevel
                tmp["memo"] = record.memo
                tmp["elapsedTime"] = record.elapsedTime
                tmp["startTime"] = record.startTime?.timeIntervalSince1970
                tmp["endTime"] = record.endTime?.timeIntervalSince1970
                tmp["record_id"] = record.record_id?.uuidString
                recordDicArray.append(tmp)
            }
            
            var jsonDic = Dictionary<String, Any>()
            jsonDic["id11"] = "test_id"
            jsonDic["pw11"] = "2j439agjof"
            jsonDic["data"] = recordDicArray
            //print(jsonDic)
            do {
                // DictionaryをJSONデータに変換
                guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonDic, options: []) else { return }
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = httpBody
                URLSession.shared.dataTask(with: request) {(data, response, error) in
                    do {
                        print("No data")
                    } catch {
                        print("Error", error)
                    }
                }.resume()

            } catch (let e) {
                print(e)
            }
        }){
            Text("Export")
        }
    }
}

struct ExportDataView_Previews: PreviewProvider {
    static var previews: some View {
        ExportDataView()
    }
}
