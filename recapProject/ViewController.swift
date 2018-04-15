//
//  ViewController.swift
//  Recap
//
//  Created by Hesham Saleh on 9/12/16.
//  Copyright © 2016 Hesham Saleh. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    @IBOutlet weak var summarizeBtn: UIToolbar!
    
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextView!
    
    var btn: AVAudioPlayer!
    
    class Word {
        
        var word = [String]()
        var occurrence = [Int]()
        
        init() {
            
        }
    }

    var sentences = [[String]]()
    
    var sentenceArr = [String]()
    
    var sum = [Int]()
    
    var tempText = ""
    
    var textGrabbed = ""
    
    let text = Word()
    
    func btnSound() {
        
        let path = Bundle.main.path(forResource: "click", ofType: "wav")
        
        let soundUrl = URL(fileURLWithPath: path!)
        
        do {
            try btn = AVAudioPlayer(contentsOf: soundUrl)
            btn.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        btn.volume = 0.1
        btn.play()
    }

    
    @IBAction func onSummarizePressed(_ sender: AnyObject) {
        
        btnSound()
        
        if textField.text == tempText || textField.text == "" || textField.text == "⚠️You have not entered any text!To create a new summary, press the top left button." || textField.text == "Please enter or paste the text to be summarized. When done, press 'Summarize' in order to see your result." {
            textField.alpha = 0.7
            textField.text = "⚠️You have not entered any text!\nTo create a new summary, press the top left button."
        } else {
            activityIndicatorStart()
        }
        
        newSummary()
        
        textField.isEditable = false
        textField.endEditing(true)
        pasteBtn.isEnabled = false

    }
    
    
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    var timer: Timer!
    
    func activityIndicatorStart() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.activityIndicatorStop), userInfo: nil, repeats: false)
        
        actInd.isHidden = false
        actInd.startAnimating()
        holdLbl.isHidden = false
        blackView.isHidden = false
        textField.isHidden = true
    }
    
    @objc func activityIndicatorStop() {
        
        actInd.isHidden = true
        actInd.stopAnimating()
        blackView.isHidden = true
        holdLbl.isHidden = true
        textField.isHidden = false
        summarizeBtn.isHidden = true
        shareBtn.isEnabled = true
        reductionLbl.isHidden = false
        blackTab.isHidden = false
        
    }
    
    @IBOutlet weak var blackView: UIView!
    
    @IBOutlet weak var holdLbl: UILabel!
    
    @IBOutlet weak var reductionLbl: UILabel!
    
    @IBOutlet weak var blackTab: UIImageView!
    
    @IBOutlet weak var pasteBtn: UIBarButtonItem!
    
    @IBAction func onSharePressed(_ sender: AnyObject) {
        
        btnSound()
        displayShareSheet(textField.text)
    }
    
    func displayShareSheet(_ shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    @IBAction func onNewPressed(_ sender: AnyObject) {
        
        btnSound()
        pasteBtn.isEnabled = true
        textField.textColor = UIColor.white
        textField.alpha = 0.7
        textField.isEditable = true
        textField.endEditing(true)
        
        textField.text = "Please enter or paste the text to be summarized. When done, press 'Summarize' in order to see your result."
        
        summarizeBtn.isHidden = false
        
        reductionLbl.isHidden = true
        blackTab.isHidden = true
        
    }
    
    @IBAction func onPastePressed(_ sender: AnyObject) {
        
        btnSound()
        textField.alpha = 1.0
        textField.text = UIPasteboard.general.string
    }
    
    func newSummary() {
        
        textGrabbed = textField.text
        
        textField.text = ""
        
        text.word.removeAll()
        
        text.occurrence.removeAll()
        
        sentences.removeAll()
        
        sentenceArr.removeAll()
        
        separateWords(textGrabbed)
        
        separateSentences(textGrabbed)
    }
    
    func separateWords(_ textGrabbed: String) {
        
        let separators = CharacterSet(charactersIn: " ]),?.;'!\"([\n:")
        
        let textArrTemp = textGrabbed.components(separatedBy: separators)
        
        var textArr = [String]()
        
        for words in textArrTemp {
            if words != "" {
                textArr.append(words)
            }
        }
        
        wordFrequency(textArr)
    }
    
    func separateSentences(_ textGrabbed: String) {
        
        let separators = CharacterSet(charactersIn: ".?!\n")
        
        let sentenceArrTemp = textGrabbed.components(separatedBy: separators)
        
        for sentences in sentenceArrTemp {
            if sentences != "" {
                sentenceArr.append(sentences)
            }
        }
        
        tokenizeSentences(sentenceArr)
    }
    
    func wordFrequency(_ textArr: [String]) {
        var textArr = textArr
        
        var occur = [Int]()
        var count = 0
        var cmp = 5
        
        for i in 0 ..< textArr.count {
            
            count = 1
            for j in i+1 ..< textArr.count {
                if strlen(textArr[i]) < 5 {
                    cmp = 4
                } else {
                        cmp = 5;
                }
                if strncasecmp(textArr[i],textArr[j],cmp) == 0 {
                    count += 1
                    textArr[j] = ""
                }
            }
            occur.append(count)
        }
        
        for i in 0 ..< textArr.count {
            if textArr[i] != "" {
                text.word.append(textArr[i])
                text.occurrence.append(occur[i])
            }
        }
        
    }

    func tokenizeSentences(_ sentenceArr: [String]) {
        
        for i in 0 ..< sentenceArr.count {
            
            let separators = CharacterSet(charactersIn: " ]),?.;!'\"([\n:")
            
            let temp = sentenceArr[i].components(separatedBy: separators)
            
            var tempArr = [String]()
            
            for sentences in temp {
                if sentences != "" {
                    tempArr.append(sentences)
                }
            }
            
            sentences.append(tempArr)
        }
        
        determineSentenceImportance()
    }
    
    func removeUselessWords() {
        
        var uselessWords = ["the","but","I","if","why","also","any","for","if","a","an","in","on","at","it","he","she","from","to","and","or","his","her","of","my","as","we", "there", "then", "what", "where","likewise","however","while","also","nor", "this", "is", "was", "hey", "very", "much", "you", "say", "same", "had", "by", "can", "all", "how", "do", "their", "like", "so", "here", "has", "more", "did", "no", "now", "when", "they", "were", "here", "are"]
        
        for i in 0 ..< text.word.count {
            
            for j in 0 ..< uselessWords.count {
                
                if text.word[i] == uselessWords[j] {
                    text.occurrence[i] = 0
                }
            }
        }
        
    }
    
    
    func determineSentenceImportance() {
        
        removeUselessWords()
        
        var cmp = 4
        var temp = 0
        sum.removeAll()
        
        for i in 0 ..< sentences.count {
            
            for j in 0 ..< sentences[i].count {
                
                for k in 0 ..< text.word.count {
                    
                    if strlen(sentences[i][j]) < 5 {
                        cmp = 4
                    } else {
                        cmp = 5;
                    }

                    if strncasecmp(sentences[i][j],text.word[k],cmp) == 0 {
                        temp += text.occurrence[k]
                    }
                }
            }
            
            sum.append(temp)
            temp = 0
        }
        
        var total = 0
        
        for points in sum {
            total += points
        }
        
        let avg = total/sentences.count
        tempText = ""
        
        print(avg, sum, sentences.count)
        
        tempText += "\(sentenceArr[0]).\n" //First Sentence.
        for i in 1 ..< sentences.count {
            if sum[i] > (avg + Int(Double(avg)*0.3)) {
                tempText += "\(sentenceArr[i]).\n"
            }
        }
        
        calculateReduction()
        
        textField.text = tempText //Output on screen.
        
    }
    
    func calculateReduction() {
        
        let reductionPercentage = 100 - Int((Double(tempText.characters.count)/Double(textGrabbed.characters.count))*100)
        
        let separators = CharacterSet(charactersIn: " ]),?.;!'\"([\n:")
        
        let temp = tempText.components(separatedBy: separators)
        
        var reductionArray = [String]()
        
        for words in temp {
            if words != "" {
                reductionArray.append(words)
            }
        }
        
        if reductionPercentage < 5 {
            reductionLbl.text = "Little or no reduction."
        } else {
            reductionLbl.text = "\(reductionPercentage)% Reduction. (\(reductionArray.count) Words)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        editBtn.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!], for: UIControlState())
        
        textField.delegate = self
        textField.alpha = 0.7
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textField.text = ""
        textField.alpha = 1.0
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }


}
