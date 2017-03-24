//
//  ViewController.swift
//  StJosemariaDaily
//
//  Created by Kurt Espinosa on 27/02/2017.
//  Copyright © 2017 Kurt Espinosa. All rights reserved.
//
/*
TODO:
 - format em dash
 - new one every viewappear?
 */

import UIKit

class ViewController: UIViewController {

    
    var list = [String] ()
    var maxChar = 290
    var minChar = 5
    @IBOutlet weak var text: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //loadFile()
        generateNew()
        
    }
    func generateNew() {
        var thepoint = ""
        repeat {
            let (source, point) = getRandomNumber()
            //source+1 for books 1 to 3
            thepoint = retrievePoint(source: String(source+1), point: String(point))
            print("len", thepoint.characters.count)
        } while (thepoint.characters.count > maxChar || thepoint.characters.count < minChar)
        self.text.text = thepoint
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        generateNew()
    }
    
    @IBAction func sharePressed(_ sender: Any) {
        let saying: String!
        saying = "\"" + self.text.text! + "\" - St. Josemaria #inspireme"
        let activityVC = UIActivityViewController(activityItems: [saying], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func  getRandomNumber() -> (Int, Int) {
        /*
        let thewaypoints = 999
        let thefurrowpoints = 1000
        let theforgepoints = 1055
        */
        
        let limits = [999,1000,1055]
        let numsources = 3
        
        let randomsrc:UInt32 = arc4random_uniform(UInt32(numsources))
        
        let source:Int = Int(randomsrc)
        
        let randomNum:UInt32 = arc4random_uniform(UInt32(limits[source])) 
        let point:Int = Int(randomNum)
        return (source, point)
    }
    
    func retrievePoint(source: String, point: String) -> String {
        /*
         TODO:
         - fix encoding esp for various languages
         - add support for new languages. Need to parse differently
         */
        
        let myURLString = "http://www.escrivaworks.org/book/\(source)/\(point)"
        print(myURLString)
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return ""
        }
        
        var thesaying = ""
        
        do {
            let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
            //print("HTML : \(myHTMLString)")
            let str = myHTMLString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//            print(str)
            let lines:[String] = str.components(separatedBy: "\n")
            var index:Int
            index = 0
//            print(lines.count)
            var line_stripped = ""
            var printline = false
            
            for line in lines{
                index += 1
                line_stripped = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if line_stripped == point {
//                    print("\(index) : \(line_stripped)")
                    printline = true
                }
                if line_stripped == "[Print]" {
//                    print("encountered [Print]")
                    break
                }
                if printline{
//                    print("\(index) : \(line_stripped)")
                    if line_stripped != ""{
                        if line_stripped != point {
                            thesaying += line_stripped + " "
                        }
                    }
                }
                
            }
            
        } catch let error {
            print("Error: \(error)")
        }
        print(thesaying)
        //TODO: need to find a way to replace all the unicode symbols automatically to ascii
        thesaying = thesaying.replacingOccurrences(of: "&#151;", with: "-")
        thesaying = thesaying.replacingOccurrences(of: "&#8212;", with: "\n-")
        return thesaying

    }
    
    
    func loadFile(){
        if let filepath = Bundle.main.path(forResource: "sjd", ofType: "txt")
        {
            do
            {
                let contents = try String(contentsOfFile: filepath)
                let lines = contents.components(separatedBy: "\n")
                for line in lines {
                    print(line)
                    list.append(line)
                }
                
            }
            catch
            {
                // contents could not be loaded
            }
        }
        else
        {
            // example.txt not found!
        }
    }
    

}
