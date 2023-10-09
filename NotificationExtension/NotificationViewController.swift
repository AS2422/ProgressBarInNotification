//
//  NotificationViewController.swift
//  NotificationExtension
//
//  Created by Albert on 06.10.2023.
//

import UIKit
import UserNotifications
import UserNotificationsUI

public class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var progressBar: UIProgressView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    public func didReceive(_ notification: UNNotification) {
        if let progress = notification.request.content.userInfo["progress"] as? Float {
            progressBar.setProgress(progress, animated: true)
        }
    }

}
