//
//  ViewController.swift
//  Jelly-Animators
//
//  Created by Sebastian Boldt on 11/16/2016.
//  Copyright (c) 2016 Sebastian Boldt. All rights reserved.
//
import UIKit
import Jelly

class ViewController: UIViewController {

    @IBOutlet var presentMeButton: UIButton!
    private var jellyAnimator: JellyAnimator? // We need to keep a strong reference to the Animator because the transitiong delegate is weak
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func presentMeNavButtonPressed(_ sender: Any) {
        self.navigationController?.delegate = jellyAnimator
        if let viewController = createVC() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func presentMeButtonPressed(_ sender: Any) {
        if let viewController = createVC() {
            
            let presentation = JellySlideInPresentation()
            self.jellyAnimator = JellyAnimator(presentation:presentation)
            self.jellyAnimator?.prepare(viewController: viewController)
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    private func createVC() -> UIViewController? {
        return self.storyboard?.instantiateViewController(withIdentifier: "PresentMe")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
