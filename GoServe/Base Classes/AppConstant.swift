//
//  AppConstant.swift
//  GoServe
//
//  Created by Dharmani Apps on 23/12/21.
//


import Foundation
import UIKit

let kAppName : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? String()
let kAppBundleIdentifier : String = Bundle.main.bundleIdentifier ?? String()

let DeviceSize = UIScreen.main.bounds.size
@available(iOS 13.0, *)
let appDel = (UIApplication.shared.delegate as! AppDelegate)
@available(iOS 13.0, *)
let appScene = (UIApplication.shared.delegate as! SceneDelegate)


enum DeviceType: String {
    case iOS = "iOS"
    case android = "android"
}

//struct FGSettings {
//    
//    static let cornerRadius = 3
//    static let borderWidth = 1
//    static let shadowOpacity = 0.4
//    static let tableViewMargin = 50
//    
//    static let nameLimit = 20
//    static let emailLimit = 70
//    static let passwordLimit = 20
//
//    static let footerMargin = 50
////    static let profileImageSize = CGSize.init(width: 400, height: 400)
//    static let profileBorderWidth = 4
//}


struct Constant {
    static let appName = "GO SERVE"
    static let alertAppName = "GoServe"
    static let appBaseUrl = "http://161.97.132.85/goServeLatest/Api/" // staging
//    static let appBaseUrl = "http://www.goserveapp.com/goServeLatest/Api/" // live
    
    static let check = "rad"
    static let uncheck = "radio"
    static let iconLogo = "logo"
    static let iconMail = "mail"
    static let iconPassword = "password"
    static let iconCheck = "check"
    static let iconUncheck = "uncheck"
    static let iconUser = "user"
    static let iconClock = "clock"
    static let iconMusic = "music"
    static let iconNotify = "notify"
    static let iconSearch = "search"
    static let iconFirstSelected = "1s"
    static let iconSecondSelected = "2s"
    static let iconThirdSelected = "3s"
    static let iconFourthSelected = "4s"
    static let iconFifthSelected = "5s"
    static let iconFirstUnSelected = "1u"
    static let iconSecondUnSelected = "2u"
    static let iconThirdUnSelected = "3u"
    static let iconFourthUnSelected = "4u"
    static let iconFifthUnSelected = "5u"
    static let iconAbout = "about"
    static let iconBlog = "blog"
    static let iconContact = "contact"
    static let iconLogout = "logout"
    static let iconMember = "member"
    static let iconRefer = "refer"
}

struct WebLinks {
//    static let aboutUsUrl = "http://161.97.132.85/goServeLatest/aboutUs.html"
//    static let termsAndConditionUrl = "http://161.97.132.85/goServeLatest/TermsAndConditions.html"
//    static let privacyPolicyUrl = "http://161.97.132.85/goServeLatest/privacyPolicy.html"
    
    static let aboutUsUrl = "http://www.goserveapp.com/goServeLatest/aboutUs.html"
    static let termsAndConditionUrl = "http://www.goserveapp.com/goServeLatest/TermsAndConditions.html"
    static let privacyPolicyUrl = "http://www.goserveapp.com/goServeLatest/privacyPolicy.html"
}


struct AlertMessage {
    static let shared = AlertMessage()
    let kMsgOk = "OK"
    let kNoInternet = "There is no internet connection."
    let kEnterName = "Please enter username."
    let kValidUserName = "Username may only have alpha numeric characters and the special characters (.) (-) (_) and may not begin with special characters."
    let kEnterPhone = "Please enter phone number."
    let kEnterValidPhone = "Invalid Phone Number. Please enter a valid phone number."
    let kEnterFirstname = "Please enter first name."
    let kEnterLastname = "Please enter last name."
    let kEnterEmailPwd = "Please enter email and password."
    let kEnterEmail = "Please enter email address."
    let kEnterBio = "Please enter your bio."
    let kSelectIdentity = "Please select your identity."
    let kSelectAgeGroup = "Please select your age group."
    let kEnterEmailUName = "Please enter email address or user name."
    let kEnterUserName = "Please enter user name."
    let kEnterValidEmail = "Invalid email, Please try again."
    let kEnterConfirmEmail = "Please enter confirm email."
    let kEnterConfirmValidEmail = "Confirm email must match."
    let kEnterPassword = "Please enter password."
    let kEnterConfirmPassword = "Please enter confirm password."
    let kPasswordNotMatch = "Passwords does not matched."
    let kPasswordWeak = "Password must be atleast 6 characters in length. It can be changed later."
    let kAgreeTerms = "Please agree to Terms and Privacy Policy."
    let kPickProfilePicture = "Please select a profile picture to continue."
    let kPickSponsorPicture = "Please select a sponsor picture to continue."
    let kPickBGPicture = "Please select a background picture to continue."
    let kEnterZip = "Please enter zip code."
    let kEnterValidZip = "Invalid zipcode. Please enter a correct 5 digit zipcode."
    let kLogout = "Are you sure you want to log out?"
    let kAcceptTerms = "Please read Terms & Conditions and accept for register new account."
    let kEnterEventName = "Please enter event name."
    let kEnterEventDate = "Please select event date."
    let kEnterTeeDate = "Please select event Tee time."
    let kEnterValidEventDate = "Please select a valid event date."
    let kEnterValidTeeDate = "Please select a valid Tee time."
    let kEnterEventLoc = "Please select event location."
    let kEnterGroupName = "Please enter group name."
    let kSelectGroupImage = "Please select group image to continue."
    let kEnterPlayerFName = "Please enter player first name."
    let kEnterSponsorName = "Please enter sponsor name."
    let kEnterBackgroundName = "Please enter background name"
    let kSelectBackgroundType = "Please select category type"
    let kEnterPollText = "Please enter poll text."
    let kEnterPollPoints = "Please enter poll points."
    let kEnterValidPollPoints = "Please enter valid poll points."
    let kSelectBackground = "Please select a background to continue."
    let kSelectCategory = "Please select a category to continue."
    let kSelectSponsor = "Please select a sponsor to continue."
    let kFillOutPollOptions = "Please fill out the poll options to continue."
    let kFillPollFields = "Please fill out all the options."
}

struct QLScreenName {
    
    static let subscribed = "subscribed"
    static let home = "home"
    static let settings = "settings"
}

struct DefaultKeys{
    static let appleLoginResponse = "appleLoginResponse"
    static let deviceToken = "deviceToken"
    static let id = "userId"
    static let authToken = "authToken"
    static let role = "Role"
    static let detailsSubmitted = "detailsSubmitted"
    static let storedEmail = "storedEmail"
    static let storedPwd = "storedPwd"
}

//func random(length:Int)->String {
//    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//    var randomString = ""
//    
//    while randomString.utf8.count < length{
//        let randomLetter = letters.randomElement()
//        randomString += randomLetter?.description ?? ""
//    }
//    return randomString
//}

func getFinalUrl(lastComponent: ApiNetworkConstant) -> String {
    let finalUrl = Constant.appBaseUrl + lastComponent.rawValue
    return finalUrl
}

enum ApiNetworkConstant: String {
    case logIn = "logIn"
    case signUp = "signUp"
    case logOut = "logOut"
    case contactUs = "contactUs"
    case addReport = "addReport"
    case getProfile = "getProfile"
    case editProfile = "editProfile"
    case googleLogin = "googleLogin"
    case appleLogin = "appleLogin"
    case forgetPassword = "forgetPassword"
    case changePassword = "changePassword"
    case joinOpportunities = "joinOpportunities"
    case deleteProfileImage = "deleteProfileImage"
    case getAllReportReasons = "getAllReportReasons"
    case filterOpportunities = "filterOpportunities"
    case notificationActivity = "notificationActivity"
    case getAllOpportunitiesByType = "getAllOpportunitiesByType"
    case getAllOpportunitiesByTypev2 = "getAllOpportunitiesByTypev2"
    case getAllOrganizationForStudent = "getAllOrganizationForStudent"
    case checkGoogleAppleTokenExistsByType = "checkGoogleAppleTokenExistsByType"
    case getAllComingPastOpportunitiesByType = "getAllComingPastOpportunitiesByType"
}


