//
//  ViewController.swift
//  TesteDiligeiro
//
//  Created by Fabio Miciano on 04/04/16.
//  Copyright © 2016 Fabio Miciano. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    // MARK: Variables
    var strDate : String!
    
    // MARK: Properties
    @IBOutlet weak var txt_description: UITextView!
    @IBOutlet weak var txt_price: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: Actions
    @IBAction func saveAction(sender: AnyObject)
    {
        //Fazer metodo POST
        postAction()
    }
    
    @IBAction func dataPickerAction(sender: AnyObject)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'hh:mm"
        strDate = dateFormatter.stringFromDate(datePicker.date)
        
        NSLog("DATA = %@", strDate)
        
    }
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        txt_price.resignFirstResponder();
        return true;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txt_description.delegate = self
        txt_price.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.hideKeyBoard(_:)))
        self.view.addGestureRecognizer(gesture)
        
    }
    
    func hideKeyBoard(sender: UITapGestureRecognizer)
    {
        txt_description.resignFirstResponder();
    }
    
    func postAction()
    {
        let price: Int!  = Int(txt_price.text!)
        let parameters :[String : AnyObject]! = ["diligencia_type":"http://52.35.220.218/api/types/4/", "description":txt_description.text, "location":"http://52.35.220.218/api/locations/4/", "value":price, "expires_at":strDate]
        
        let headers = ["Authorization": "Token d75b7842ef75dbd13df7c8a8a1ef988c8d0e2575"]
        
        Alamofire.request(.POST, "http://52.35.220.218/api/post/diligencias", parameters:parameters, encoding:.JSON, headers:headers).responseJSON { (response) in
            NSLog(response.result.error.debugDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

