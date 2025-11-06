//
//  ConfirmationViewController.swift
//  EventPlannerApp
//
//  Created by Varun on 05/11/25.
//

import UIKit

final class ConfirmationViewController: UIViewController {
    // Properties receiving data
    var eventTitle: String = ""
    var eventDate: Date = Date()
    var eventLocation: String = ""

    // Outlets to summary labels
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Confirmation"

        titleLabel.text = eventTitle.isEmpty ? "—" : eventTitle
        dateLabel.text = dateFormatter.string(from: eventDate)
        locationLabel.text = eventLocation.isEmpty ? "—" : eventLocation
    }
}

