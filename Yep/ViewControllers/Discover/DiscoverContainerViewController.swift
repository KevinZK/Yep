//
//  DiscoverContainerViewController.swift
//  Yep
//
//  Created by NIX on 16/5/26.
//  Copyright © 2016年 Catch Inc. All rights reserved.
//

import UIKit
import YepKit

class DiscoverContainerViewController: UIViewController {

    enum Option: Int {
        case MeetGenius
        case FindAll

        var title: String {
            switch self {
            case .MeetGenius:
                return NSLocalizedString("Meet Genius", comment: "")
            case .FindAll:
                return NSLocalizedString("Find All", comment: "")
            }
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.removeAllSegments()
            (0..<2).forEach({
                let option = Option(rawValue: $0)
                segmentedControl.insertSegmentWithTitle(option?.title, atIndex: $0, animated: false)
            })
        }
    }

    @IBOutlet weak var geniusesContainerView: UIView!
    @IBOutlet weak var discoveredUsersContainerView: UIView!

    var currentOption: Option = .MeetGenius {
        didSet {
            switch currentOption {

            case .MeetGenius:
                geniusesContainerView.hidden = false
                discoveredUsersContainerView.hidden = true

            case .FindAll:
                geniusesContainerView.hidden = true
                discoveredUsersContainerView.hidden = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        currentOption = .MeetGenius

        segmentedControl.selectedSegmentIndex = currentOption.rawValue
        segmentedControl.addTarget(self, action: #selector(DiscoverContainerViewController.chooseOption(_:)), forControlEvents: .ValueChanged)
    }

    @objc private func chooseOption(sender: UISegmentedControl) {

        guard let option = Option(rawValue: sender.selectedSegmentIndex) else {
            return
        }

        currentOption = option
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        guard let identifier = segue.identifier else {
            return
        }

        switch identifier {

        case "embedDiscover":
            let vc = segue.destinationViewController as! DiscoverViewController
            vc.showProfileOfDiscoveredUserAction = { discoveredUser in

                dispatch_async(dispatch_get_main_queue()) { [weak self] in
                    self?.performSegueWithIdentifier("showProfile", sender: Box<DiscoveredUser>(discoveredUser))
                }
            }

        default:
            break
        }
    }
}

