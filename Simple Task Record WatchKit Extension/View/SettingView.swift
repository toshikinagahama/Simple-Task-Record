//
//  SettingView.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/11/03.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var vm: ViewModel

    var body: some View {
        VStack{
            Text("Setting")
        }
        .navigationTitle("Setting")
    }
}
