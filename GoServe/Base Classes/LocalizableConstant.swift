//
//  LocalizableConstant.swift
//  GoServe
//
//  Created by Dharmani Apps on 23/12/21.
//

import Foundation
import UIKit

struct LocalizableConstants {
    
    struct SuccessMessage {
        
        static let verificationMailSent = "verification_mail_sent"
        static let mailNotVerifiedYet = "mail_not_verified_yet"
        static let newPasswordSent = "new_password_sent"
        static let profileUpdated = "profile_updated"
        static let passwordChanged = "password_changed"
        static let addRequestSent = "add_request_sent"
        static let addRemoveFavUnfavStudio = "add_remove_fav_Unfav_studio"
        static let cancellationRequestSubmit = "your_cancellation_request_submit"
        static let rejectRequestSubmit = "your_rejection_request_submit"
        static let requestAccept = "your_request_submitted"
        static let timeSlotAdded = "time_slot_added"
        static let addedCard = "added_card_details"
        static let submitFeedback = "feedback_submit"
        static let blokDay = "blok_day"
    }
    
    struct Error {
        
        static let noNetworkConnection = "no_network_connection"
        static let sessionExpired = "session_expired"
        static let inProgress = "in_progress"
        static let cardDetailsNotValid = "please_enter_valid_card_details"
        static let accountDisable = "your_account_has_been_disable_please_contact_with_admin_for_more_detail"
        static let pendingStripeVerification = "pending_verification"
        static let maximumLimit = "add_limit"
        static let invalidCredentials = "invalid_credentials"
    }
    
    struct ValidationMessage {
        
        //signup
        
        static let enterUserName = "Please enter user name"
        static let enterLastName = "Please enter last name"
        static let selectBirthDate = "Please select birth date"
        static let selectGender = "Please select gender"
        static let selectAddress = "Please select address"
        static let enterEmail = "Please enter email"
        static let enterAppointmentDetails = "Please enter appointment Detail"
        static let fillAllDetail = "Please fill all selected filled"
        static let enterDisease = "Please enter disease"
        static let enterTitle = "Please enter title"
        static let enterDescription = "Please enter description"
        static let enterFirstName = "Please enter first name"
        static let enterValidEmail = "Please enter valid email"
        static let enterMobileNumber = "Please enter mobile"
        static let enterValidMobileNumber = "Please enter valid mobile"
        static let enterHomeTown = "Please enter home town"
        static let enterProffession = "Please enter proffession"
        static let enterMemberCousre = "Please enter member course"
        static let enterGolfHandicap = "Please enter golf handicap"
        static let enterPassword = "Please enter password"
        static let enterValidPassword = "Please enter valid password"
        static let agreeTermsAndConditions = "Please agree with terms and conditions"
        static let ageMustBeGreaterThen13 = "Please age should be greater then 13"
        
        //change password
        static let enterNewPassword = "enter_new_password"
        static let enterValidNewPassword = "enter_valid_new_password"
        static let enterRetypePassword = "enter_confirm_password"
        static let enterValidRetypePassword = "enter_valid_confirm_password"
        static let oldNewPasswordNotSame = "old_new_password_not_same"
        static let NewRetypePasswordNotMatch = "new_retype_password_not_match"
        
        //add request
        static let enterName = "enter_name"
        static let selectAddRequestPhoto = "select_add_request_photo"
        
        //signout
        
        static let confirmLogout = "confirm_logout"
        
        //add payment method
        
        static let selectCardType = "select_card_type"
        static let enterCardNumber = "enter_card_number"
        static let enterValidCardNumber = "enter_valid_card_number"
        static let nameOnCard = "name_on_card"
        static let enterCVV = "enter_CVV"
        static let enterValidCVV = "enter_valid_CVV"
        static let enterExpirationDate = "enter_expiration_date"
        static let enterValidExpirationDate = "enter_valid_expiration_date"
        static let selectAnCard = "select_an_card"
        
        //Fringe GolfCourse Host
        
        static let enterGolfCourseName = "enter_golf_course_name"
        static let enterGolfCourseAddress = "enter_address"
        static let enterGolfCoursePrice = "enter_golf_course_price"
        static let enterGolfCourseDescription = "enter_golf_course_description"
        
        //account Details
        
        static let enterAccountHolderName = "enter_account_holder_name"
        static let enterAccountNumber = "enter_account_number"
        static let enterRoutingNumber = "routing_number"
        static let enterSSN = "enter_SSN_number"
        static let enterFrontImage = "upload_front_image"
        static let enterBackImage = "upload_back_image"
        static let enterValidAccountNumber = "enter_valid_account_number"
        static let enterValidRoutingNumber = "enter_valid_routing_number"
        static let enterValidSSNNumber = "enter_valid_SSN_number"
        
        // Confirm pay
        static let enterAddGuestLimit = "enter_add_guest_limit"
        static let enterRemoveGuestLimit =  "enter_remove_guest_limit"
        
        struct Error {
            static let noNetworkConnection = "no_network_connection"
            static let sessionExpired = "session_expired"
            static let inProgress = "in_progress"
            static let cardDetailsNotValid = "please_enter_valid_card_details"
            static let accountDisable = "your_account_has_been_disable_please_contact_with_admin_for_more_detail"
            static let pendingStripeVerification = "pending_verification"
            static let maximumLimit = "add_limit"
        }
        
    }
    
    struct Controller {
        
        struct Pages {
            
            static let pullMore = "pull_more"
            static let releaseToRefresh = "release_to_refresh"
            static let updating = "updating"
        }
        
        struct NearByGolfClubs {
            
            static let noSessionDataFound = "no_near_by_golf_clubs_available"
        }
        
        struct Notifications {
            
            static let title = "notifications"
            static let noRecordsFound = "no_notifications_entry_found"
        }
        struct SureShow {
            
            static let title = "sureshow"
            static let pending = "pending"
            static let confirmed = "confirmed"
            static let cancel = "cancel"
            static let awaiting = "awaiting"
            static let moreInfo = "more_info"
            static let payNow = "pay_now"
        }
        struct FringeDataForGolfclub {
            
            static let pending = "no_pending_data_found"
            static let awating = "no_awating_data_found"
            static let confirmed = "no_confirmed_data_found"
            static let noSelected = "no_session_selected"
            static let calendar = "no_data_available_for_this_date"
            static let blockedDates = "seleceted_dates_are_already_blocked"
            static let noDateBlocked = "no_date_blocked_for_this_month"
        }
        struct Profile {
            
            
            static let changePassword = "change_password"
            static let about = "about"
            static let history = "history"
            static let privacy = "privacy"
            static let termsOfService = "terms_of_service"
            static let logout = "sign_out"
        }
        struct HostProfile {
            
            static let accountInformation = "account_information"
            static let changePassword = "change_password"
            static let paymentMethods = "payment_method"
            static let allowLocation = "allow_location"
            static let allowNotification = "allow_notification"
            static let bookingListing = "my_bookings"
            static let switchToPlayer = "switch_to_player"
            static let termsOfService = "terms_of_service"
            static let privacyPolicy = "Privacy"
            static let logout = "sign_out"
        }
        
        struct AddPaymentMethod {
            
            static let creditDebitCard = "credit_debit_card"
            static let payPalCard = "pay_pal_card"
            static let appleCard = "apple_card"
        }
        
        //account Details
        
        static let enterAccountHolderName = "enter_account_holder_name"
        static let enterAccountNumber = "enter_account_number"
        static let enterRoutingNumber = "routing_number"
        static let enterSSN = "enter_SSN_number"
        static let enterFrontImage = "upload_front_image"
        static let enterBackImage = "upload_back_image"
        static let enterValidAccountNumber = "enter_valid_account_number"
        static let enterValidRoutingNumber = "enter_valid_routing_number"
        static let enterValidSSNNumber = "enter_valid_SSN_number"
        
    }
}

