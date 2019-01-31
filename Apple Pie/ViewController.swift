//
//  ViewController.swift
//  Apple Pie
//
//  Created by student on 29/01/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

var listOfWords:[String] = ["food","lab","simple","guess"] //list of words to guess
let incorrectMovesAllowed = 7 //number of incorrect guesses allowed in a round

class ViewController: UIViewController {
    
    var totalWins:Int = 0{
        didSet{
            newRound()
        }
    }
    var totalLosses:Int = 0{
        didSet{
            newRound()
        }
    }

    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var tree1: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newRound()
        //tree1.image = #imageLiteral(resourceName: "Tree 0")
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) { //sender is specified as UIButton to identify which button is pressed
        //sender.isEnabled = false a player cannot select a letter more than once in the same round
        let letterString = sender.title(for: .normal)!
        showToast(message: letterString)
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showAlertWin(){
        let alertControl = UIAlertController(title: "Won", message: "You won this round!", preferredStyle: UIAlertControllerStyle.alert)
        alertControl.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func showAlertLoss(){
        let alertControl = UIAlertController(title: "Lost", message: "You lost this round!", preferredStyle: UIAlertControllerStyle.alert)
        alertControl.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertControl, animated: true, completion: nil)
    }
    
    func updateGameState(){
        //game is lost if number of incorrect moves left is 0
        if currentGame.incorrectMovesRemaining == 0{
            totalLosses = totalLosses + 1
            showAlertLoss()
        }
        else if currentGame.word == currentGame.formattedWord{
            totalWins = totalWins + 1
            showAlertWin()
        }
        else{
            updateUI()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentGame:Game! //force unwrap to Game struct type
    
    func newRound(){
        let newWord = listOfWords.removeFirst()
        currentGame = Game(word:newWord, incorrectMovesRemaining:incorrectMovesAllowed, guessedLetters: [])
        updateUI()
    }
    
    func updateUI(){
        correctWordLabel.text = currentGame.formattedWord
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        let tr:String = "Tree \(currentGame.incorrectMovesRemaining).pdf"
        //correctWordLabel.text=tr
        tree1.image = UIImage(named: tr) //the more incorrect moves you make, the lesser number of apples show up on the tree
    }


}

