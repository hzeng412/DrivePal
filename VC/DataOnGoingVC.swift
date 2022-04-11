//
//  DataOnGoingVC.swift
//  Reminder
//
//  Created by bari on 2022/4/7.
//
import CoreMotion
import UIKit

class DataOnGoingVC: UIViewController {

    let manager = CMMotionManager()
    var timer = Timer()
    var score = 0
    @IBOutlet var scoreImage: UIImageView!
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var scoreDisplay: UILabel!
    
    override func loadView() {
        super.loadView()
        scoreImage.isHidden = true
        homeButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        score = 100
        print("Active!")
        manager.startGyroUpdates()
        manager.gyroUpdateInterval = 0.1
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ [self] timer in
            
            if let gyroData = self.manager.gyroData {
                let x = gyroData.rotationRate.x
                
                //print(x) //front and backward
                
                if (x<(-8)){
                    print("FRONT TILT DETECTED")
                    //load abrubt braking
                    self.performSegue(withIdentifier: "abruptBrakingSegue", sender: self)
                    //timer.invalidate()
                    self.score = self.score - 10
                    scoreDisplay.text = String(self.score)
                }
                if (x>8){
                    print("BACK TILT DETECTED")
                    //load hard acceleration
                    self.performSegue(withIdentifier: "abruptAccelSegue", sender: self)
                    //timer.invalidate()
                    self.score = self.score - 10
                    scoreDisplay.text = String(self.score)
                }
            }
                    
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder() // To get shake gesture
        self.navigationController?.isNavigationBarHidden = true
    }

    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    @IBAction func endTripClicked(_ sender: Any) {
        timer.invalidate()
        if (score <= 100 && score >= 80){
            //scoreImage.image = UIImage(named: "90")
            UIView.transition(with: self.scoreImage, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.scoreImage.image = UIImage(named: "90")
            }, completion: nil)
        }
        else if (score < 80 && score >= 60){
            //scoreImage.image = UIImage(named: "70")
            UIView.transition(with: self.scoreImage, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.scoreImage.image = UIImage(named: "70")
            }, completion: nil)
        }
        else{
            //scoreImage.image = UIImage(named: "50")
            UIView.transition(with: self.scoreImage, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.scoreImage.image = UIImage(named: "50")
            }, completion: nil)
        }
        
        scoreImage.isHidden = false
        homeButton.isHidden = false
        

    }
    
    @IBAction func homeClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Bumpy Bumpy")
            self.performSegue(withIdentifier: "BumpySegue", sender: self)
        }
    }
    
    func asyncAfter(deadline: DispatchTime, execute: DispatchWorkItem){}
    
//    let delay : Double = 3.0    // 5 seconds here
//    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//        // Code to go to other controller, either segue, or VC instantiation
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
