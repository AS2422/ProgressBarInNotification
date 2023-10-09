//
//  ViewController.swift
//  ProgressBarTest
//
//  Created by Albert on 06.10.2023.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        notificationCenter.delegate = self
        self.sendNotificationWithProgress(progress: 0.1)        
    }
    
    
    

    // Метод вызывается, когда уведомление доставлено и приложение находится в фоне
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Проверка, что это нужное уведомление
        if notification.request.identifier == "myNotificationCategory" {
            // Создание нового содержимого уведомления
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self.updateNotificationWithProgress(progress: 0.8)
            })
        }
    }
    
    
    private func sendNotificationWithProgress(progress: Float) {
        let content = UNMutableNotificationContent()
        content.title = "Подписание документов"
        content.body = "Выполняется подписание"
        content.categoryIdentifier = "myNotificationCategory"
        content.userInfo = ["progress": progress]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let request = UNNotificationRequest(identifier: "myNotificationCategory", content: content, trigger: trigger)

        notificationCenter.setNotificationCategories([UNNotificationCategory(identifier: "myNotificationCategory", actions: [], intentIdentifiers: [])])
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Ошибка при добавлении запроса на отправку уведомления: \(error)")
            } else {
                print("Запрос на отправку уведомления успешно добавлен")
            }
        })
    }
    
    private func updateNotificationWithProgress(progress: Float) {
        
        notificationCenter.getDeliveredNotifications { (notifications) in
            guard let notification = notifications.first(where: { $0.request.identifier == "myNotificationCategory" }) else {
                return
            }
            
            // Modify the progress value
            var userInfo = notification.request.content.userInfo
            userInfo["progress"] = progress
            
            // Create a new notification content with the updated userInfo
            let updatedContent = UNMutableNotificationContent()
            updatedContent.title = notification.request.content.title + "\(progress)"
            updatedContent.body = notification.request.content.body
            updatedContent.userInfo = userInfo
            
            // Create a new notification request with the updated content
            let updatedRequest = UNNotificationRequest(identifier: notification.request.identifier, content: updatedContent, trigger: notification.request.trigger)
            
            // Update the existing notification with the new request
            UNUserNotificationCenter.current().add(updatedRequest) { (error) in
                if let error = error {
                    print("Error updating notification: \(error.localizedDescription)")
                }
            }
        }


    }
}
