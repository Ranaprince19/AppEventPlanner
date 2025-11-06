//
//  OnboardingWelcomeViewController.swift
//  EventPlannerApp
//
//  Created by Prince Rana on 04/11/25.
//

import UIKit

class OnboardingWelcomeViewController: UIViewController {
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainStack: UIStackView!
    
    @IBAction func createEventTapped(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
