//
//  WebVC.swift
//  Reminder
//
//  Created by bari on 2021/12/3.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    
    @IBOutlet weak var WebView: WKWebView!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var URLCancelButton: UIButton!
    
    var address = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        URLTextField?.text = address
        loadRequest()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func loadRequest() {
       if let url = URL(string: address) {
           let request = URLRequest(url: url)
           WebView.load(request)
       }
    }
    
    @IBAction func OnCancelURL(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
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
