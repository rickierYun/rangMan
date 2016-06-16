//
//  MainViewController.swift
//  
//
//  Created by 欧阳云慧 on 16/6/14.
//
//

import UIKit
import Alamofire

private struct CalNumber{
    static var indexA = 0
}

class MainViewController: UIViewController {

    @IBOutlet weak var wordShowText: UILabel!
    @IBOutlet weak var guessEnter: UITextField!
    @IBAction func guessButton(sender: UIButton) {
        if CalNumber.indexA < 10{
            makeAGuess(guessEnter.text!)
            CalNumber.indexA += 1
            wordShowText.text = StoreData.word
        }else{
            submitResult()
            CalNumber.indexA = 0
            wordShowText.text = StoreData.word
        }
    }

    @IBAction func resultButton(sender: UIButton) {
        getTheResult()
    }
    @IBAction func startButton(sender: UIButton) {
        startGame()
        wordShowText.text = "****"
    }
    @IBAction func submitButton(sender: UIButton) {
        submitResult()
        CalNumber.indexA = 0
        // 用弹框来显示结果
        let message =  AlertMessage.playId + "\(StoreData.playerId)" + AlertMessage.totalWordCount + "\(StoreData.totalWordCount)"  + AlertMessage.correctWordCount + "\(StoreData.correctWordCount)"  + AlertMessage.totalWrongGuessCount + "\(StoreData.totalWrongGuessCount)" + AlertMessage.score + "\(StoreData.score)" + AlertMessage.datetime + "\(StoreData.datetime)"
        showAlert(AlertMessage.result, message:message, alertTitle: AlertMessage.sure, viewController: self, showTheWindows: false)
        wordShowText.text = StoreData.word
    }

//MARK: -view-
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//MARK: -Func-
    // 开始游戏这里内置帐号，如果更一般化可以给startGame加个参数
    func startGame() {
        //json请求
        Alamofire.request(.POST, IpAndOther.ip, parameters: ["playerId":"ou173697476@gmail.com", "action":"startGame"], encoding: ParameterEncoding.JSON, headers: IpAndOther.header).responseJSON { (response) in

            //这里可以利用枚举将类型将response结果进行封装
            let result = String(response.result)
            if result == "SUCCESS"{
                guard let json = response.result.value where response.result.value == nil else { return self.dataError()}

                guard let datalist = json as? [String: AnyObject] else{ return self.dataError()}
                guard let messageResponse = datalist["message"] as? String else{ return showAlert(AlertMessage.messageDonnotExite, message: "", alertTitle: AlertMessage.sure, viewController: self, showTheWindows: false) }

                if messageResponse == "THE GAME IS ON"{
                    StoreData.sessionId = datalist["sessionId"] as! String //确定数据库中是String时用！

                    guard let data = datalist["data"] as? [String: AnyObject] else{ return self.dataError()}

                    StoreData.numberOfWordsToGuess = data["numberOfWordsToGuess"] as! Int // 确定数据库中是Int时用！
                    StoreData.numberOfGuessAllowedForEachWord = data["numberOfGuessAllowedForEachWord"] as! Int

                }else{
                    showAlert(AlertMessage.getWrongMessage, message: AlertMessage.tryAgain, alertTitle: AlertMessage.sure, viewController: self, showTheWindows: false)
                }
            }else{
                showAlert("Networking error", message: "Please check your networking", alertTitle: "ok", viewController: self, showTheWindows: false)
            }
        }
    }

    func makeAGuess(guessWordInResponseWord: String){
        if guessWordInResponseWord != ""{
            Alamofire.request(.POST, IpAndOther.ip, parameters: ["playerId":"ou173697476@gmail.com", "action":"guessWord","sessionId":"\(StoreData.sessionId)","guess": "\(guessWordInResponseWord)"], encoding: ParameterEncoding.JSON, headers: IpAndOther.header).responseJSON { (response) in
                self.getWord(response)
            }

        }else{
            Alamofire.request(.POST, IpAndOther.ip, parameters: ["playerId":"ou173697476@gmail.com", "action":"nextWord","sessionId":"\(StoreData.sessionId)"], encoding: ParameterEncoding.JSON, headers: IpAndOther.header).responseJSON { (response) in
                self.getWord(response)
            }
        }
    }

    func getTheResult() {
        Alamofire.request(.POST, IpAndOther.ip, parameters: ["playerId":"ou173697476@gmail.com", "action":"getResult","sessionId":"\(StoreData.sessionId)"], encoding: ParameterEncoding.JSON, headers: IpAndOther.header).responseJSON { (response) in
            self.getWord(response)
        }

    }

    func submitResult() {
        Alamofire.request(.POST, IpAndOther.ip, parameters: ["playerId":"ou173697476@gmail.com", "action":"submitResult","sessionId":"\(StoreData.sessionId)"], encoding: ParameterEncoding.JSON, headers: IpAndOther.header).responseJSON { (response) in
            self.getWord(response)
        }
    }

//MARK: -privateModel-
    func getWord(response: Response<AnyObject, NSError>) {
        let result = String{response.result}
        if result == "SUCCESS"{
            guard let json = response.result.value where response.result.value == nil else { return self.dataError()}
            guard let datalist = json as? [String: AnyObject] else{ return self.dataError()}
            guard let sessionId = datalist["sessionId"] as? String else{ return self.dataError()}

            if sessionId == StoreData.sessionId{
                guard let data = datalist["data"] as? [String: AnyObject] else{ return self.dataError()}

                StoreData.totalWordCount = data["totalWordCount"] as! Int
                guard let wrongGuessCountOfCurrentWord = data["wrongGuessCountOfCurrentWord"] as? Int else {return}
                StoreData.wrongGuessCountOfCurrentWord = wrongGuessCountOfCurrentWord
                guard let word = data["word"] as? String else{return}
                StoreData.word = word
                guard let score = data["score"] as? Int else{return}
                StoreData.score = score
                guard let totalWrongGuessCount = data["totalWrongGuessCount"] as? Int else {return}
                StoreData.totalWrongGuessCount = totalWrongGuessCount
                guard let playerId = data["playerId"] as? String else{return}
                StoreData.playerId = playerId
                guard let datetime = data["datetime"] as? String else{return}
                StoreData.datetime = datetime
                guard let correctWordCount = data["correctWordCount"] as? Int else{return}
                StoreData.correctWordCount = correctWordCount

            }else{
                showAlert(AlertMessage.sessionIdWrong, message: AlertMessage.checkYourEmail, alertTitle: AlertMessage.sure, viewController: self, showTheWindows: false)
            }
            guard let message = datalist["message"] as? String else{return self.dataError()} // 处理优先级欠考虑
            if message == "The error message here"{
                showAlert(AlertMessage.getWrongMessage, message: AlertMessage.tryAgain, alertTitle: AlertMessage.sure, viewController: self, showTheWindows: false)
            }
        }else{
            showAlert("Networking error", message: "Please check your networking", alertTitle: "ok", viewController: self, showTheWindows: false)
        }

    }
    
    func dataError()  {
        showAlert(AlertMessage.dataError, message: AlertMessage.cannotGetTheData, alertTitle: AlertMessage.sure, viewController: self, showTheWindows: false)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
