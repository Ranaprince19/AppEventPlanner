//
//  PaymentsViewController.swift
//  EventPlannerApp
//
//  Created by Prince Rana on 03/11/25.
//

import UIKit

final class PaymentsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!        // "Payments"
    @IBOutlet weak var sectionLabel: UILabel!      // "Payment History"
    @IBOutlet weak var imageCard: UIView!
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var emptyTitleLabel: UILabel!   // "No Transactions Yet"
    @IBOutlet weak var emptyBodyLabel: UILabel!    // "Once you start managing..."

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }

    // MARK: - UI Styling
    private func style() {
        view.backgroundColor = .systemBackground

        // --- Stack Configuration ---
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0                        // No base spacing
        stack.isLayoutMarginsRelativeArrangement = false
        stack.isBaselineRelativeArrangement = false
        stack.layoutMargins = .zero
        if #available(iOS 11.0, *) {
            stack.directionalLayoutMargins = .zero
        }

        // Custom fine spacing
        stack.setCustomSpacing(4, after: titleLabel)       // Payments → Payment History
        stack.setCustomSpacing(12, after: sectionLabel)    // Payment History → Card
        stack.setCustomSpacing(16, after: imageCard)       // Card → No Transactions Yet
        stack.setCustomSpacing(6, after: emptyTitleLabel)  // No Transactions Yet → Description

        // --- Typography ---
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        sectionLabel.font = .systemFont(ofSize: 22, weight: .bold)
        emptyTitleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        emptyBodyLabel.font = .systemFont(ofSize: 15, weight: .regular)
        emptyBodyLabel.textColor = .secondaryLabel
        emptyBodyLabel.numberOfLines = 0
        emptyBodyLabel.textAlignment = .center

        // --- Image Card Styling ---
        imageCard.backgroundColor = .secondarySystemBackground
        imageCard.layer.cornerRadius = 16
        imageCard.layer.masksToBounds = false
        imageCard.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        imageCard.layer.shadowOpacity = 1
        imageCard.layer.shadowRadius = 12
        imageCard.layer.shadowOffset = CGSize(width: 0, height: 6)

        heroImageView.layer.cornerRadius = 16
        heroImageView.clipsToBounds = true
        heroImageView.contentMode = .scaleAspectFill
    }
}
