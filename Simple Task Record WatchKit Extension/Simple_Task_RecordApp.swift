//
//  Simple_Task_RecordApp.swift
//  Simple Task Record WatchKit Extension
//
//  Created by Toshiki Nagahama on 2021/10/27.
//

import SwiftUI

@main
struct Simple_Task_RecordApp: App {
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
        .onChange(of: scenePhase){
            _ in
                persistenceController.save()
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
