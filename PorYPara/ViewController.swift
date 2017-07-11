//
//  ViewController.swift
//  PorYPara
//
//  Created by Mark McArthey on 7/8/17.
//  Copyright © 2017 Mark McArthey. All rights reserved.
//

import UIKit
import Foundation
import CSV
import GameplayKit

class ViewController: UIViewController {
    @IBOutlet weak var porButton: UIButton!
    @IBOutlet weak var paraButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var applicationLabel: UILabel!
    
    struct Question {
        var attr = [String: String]()
    }
    var questions = [Int: Question]()
    var headers = [String]()
    var rand: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Por o Para?"
        porButton.layer.cornerRadius = 4
        paraButton.layer.cornerRadius = 4
        
        loadFile()
        askQuestion()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        
        rand = Int(arc4random_uniform(UInt32(questions.count)))
        let ques = questions[rand]!
        
        questionLabel.text = ques.attr["first"]! + " ______ " + ques.attr["last"]!
        translationLabel.text = ques.attr["translation"]
        applicationLabel.text = ques.attr["application"]
        
        applicationLabel.isHidden = true
        
        questionLabel.sizeToFit()
        translationLabel.sizeToFit()
        applicationLabel.sizeToFit()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let answer = questions[rand]!.attr["answer"]!.lowercased()
        
        if sender.titleLabel!.text == answer {
            title = "RIGHT"
            sender.backgroundColor = UIColor.green
        } else {
            title = "WRONG"
            sender.backgroundColor = UIColor.red
        }
        
        porButton.isEnabled = false
        paraButton.isEnabled = false
        applicationLabel.isHidden = false
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        title = "Por o Para?"
        
        porButton.backgroundColor = UIColor.blue
        paraButton.backgroundColor = UIColor.blue
        porButton.isEnabled = true
        paraButton.isEnabled = true
        
        askQuestion()
    }
    @IBAction func starTapped(_ sender: UIButton) {
        let starFilled = #imageLiteral(resourceName: "Star-Filled-20x20")
        let star = #imageLiteral(resourceName: "Star-20x20")
        
        if starButton.currentImage == starFilled {
            starButton.setImage(star, for: .normal)
        } else {
            starButton.setImage(starFilled, for: .normal)
        }
    }
    
    func loadFile() {
        if let path = Bundle.main.path(forResource: "porypara", ofType: "csv") {
            if let stream = InputStream(fileAtPath: path) {
                let csv = try! CSVReader(stream: stream, hasHeaderRow: true, delimiter: ";")
                let headerRow = csv.headerRow!
                headers.append(contentsOf: headerRow)
                
                //print("headers: \(headers)")
                var idx = 0
                while let row = csv.next() {
                    //print("row: \(row)")
                    var question = Question()
                    for (index, value) in row.enumerated() {
                        question.attr[headers[index]] = value
                    }
                    questions[idx] = question
                    idx += 1
                }
            }
        }
    }
    
    //    func sample() {
    //        struct Person {
    //            var attributes = [String : String]()
    //        }
    //        var peopleByID = [ Int : Person ]()
    //
    //        // and then:
    //
    //        var p1 = Person()
    //        var p2 = Person()
    //        p1.attributes["Surname"] = "Somename"
    //        p1.attributes["Name"] = "Firstname"
    //        p2.attributes["Address"] = "123 Main St."
    //        peopleByID[1] = p1
    //        peopleByID[2] = p2
    //
    //        if let person1 = peopleByID[1] {
    //            print(person1.attributes["Surname"]!)
    //
    //            for attrKey in person1.attributes.keys {
    //                print("Key: \(attrKey) value: \(person1.attributes[attrKey]!)")
    //            }
    //        }
    //    }
}

