//
//  StructData.swift
//  hangMan
//
//  Created by 欧阳云慧 on 16/6/14.
//  Copyright © 2016年 欧阳云慧. All rights reserved.
//

import Foundation

// 结构体存储数据
public struct StoreData{
    static var sessionId: String = ""
    static var numberOfWordsToGuess: Int = 0
    static var numberOfGuessAllowedForEachWord: Int = 0
    static var word:String = ""
    static var totalWordCount: Int = 0
    static var wrongGuessCountOfCurrentWord: Int = 0
    static var score: Int = 0
    static var totalWrongGuessCount: Int = 0
    static var playerId: String = ""
    static var datetime: String = ""
    static var correctWordCount: Int = 0
}

public struct AlertMessage{

    static let dataError = "Data error"
    static let cannotGetTheData = "Can not get the data"
    static let sure = "ok"
    static let messageDonnotExite = "Message did't exite"
    static let netWorkingError = "Networking error"
    static let pleaseCheck = "Please check your networking"
    static let sessionIdWrong = "SessionIdWrong"
    static let checkYourEmail = "Check Your Email"
    static let getWrongMessage = "Get wrong Message"
    static let tryAgain = "Please try again!"
    static let playId: String = "playID:"
    static let totalWordCount: String = "totalWordCount:"
    static let correctWordCount = "correctWordCount:"
    static let totalWrongGuessCount = "totalWrongGuessCount:"
    static let score = "score:"
    static let datetime = "datetime:"
    static let result = "Result"
    
}

public struct IpAndOther{
    static let ip = "http://www.domain-name.com/game/on"
    static let header = ["Content-Type":"application/json"]
}