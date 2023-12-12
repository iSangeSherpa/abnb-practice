//
//  Failure.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 23/11/2022.
//

import Foundation

enum Failure : Error {
    case UnknownError(_ underlying:Error? = nil)
    case UnAuthenticatedError
    case ServerError(message:String, status:String)
    
    
    static let UNKNOWN_STATUS_CODE = "UNKNOWN"
    static let UNKNOWN_ERROR_MESSAGE = "Something Went wrong"
    static let UN_AUTH_ERROR_MESSAGE = "session expired"
}

extension Error{
    func message()->String{
        
        switch(self){
        case let error as Failure:
            switch(error){
            case Failure.UnknownError(let underlying):
                return underlying?.asAFError?
                    .underlyingError?.localizedDescription ?? Failure.UNKNOWN_ERROR_MESSAGE
            case .UnAuthenticatedError:
                return Failure.UN_AUTH_ERROR_MESSAGE
            case .ServerError(message: let message, status:  _):
                return message;
            }
        default:
            return self.localizedDescription
        }
    }
}


let messageCodes  = [
    Failure.UNKNOWN_STATUS_CODE : Failure.UNKNOWN_ERROR_MESSAGE,
    "airbark_401" : Failure.UN_AUTH_ERROR_MESSAGE,
    "airbark_400" : "bad request",
    "airbark_404" : "not found",
    "airbark_403" : "permission denied",
    "airbark_500" : "internal server error",
    
    "airbark_20001" : "invalid email",
    "airbark_20002" : "email already exists",
    "airbark_20003" : "phone number already exists",
    "airbark_200004" : "invalid password",
    "airbark_20005" : "password min 6 character long",
    "airbark_20006" : "password max 30 character long",
    "airbark_20007" : "either phone number or email is required",
    "airbark_20008" : "invalid phone number",
    "airbark_20009" : "invalid otp code",
    "airbark_20010" : "phone already verified",
    "airbark_20011" : "email already verified",
    "airbark_20012" : "phone number not verified",
    "airbark_20013" : "email not verified",
    "airbark_20014" : "user not found",
    "airbark_20015" : "Username or password incorrect",
    "airbark_20016" : "invalid or expired refresh token",
    "airbark_20017" : "invalid password reset token",
    "airbark_20018" : "invalid full name",
    "airbark_20020" : "invalid image",
    "airbark_20021" : "invalid date of birth",
    "airbark_20022" : "invalid current password",
    "airbark_20023" : "invalid fcm token",
    "airbark_20024" : "invalid fcm device type",
    "airbark_20025" : "invalid session id",
    "airbark_20026" : "session not found",
    "airbark_20027" : "invalid bio",
    "airbark_20028" : "invalid active profile",
    
    "airbark_21001" : "invalid age",
    "airbark_21002" : "invalid bread",
    "airbark_21003" : "invalid behavior",
    "airbark_21004" : "invalid immunization status",
    "airbark_21005" : "invalid images",
    "airbark_21007" : "pets not found",
    "airbark_21008" : "invalid pet name",
    "airbark_21009" : "invalid pet dob",
    
    "airbark_22001" : "invalid name",
    "airbark_22002" : "invalid latitude",
    "airbark_22003" : "invalid longitude",
    
    "airbark_23001" : "invalid document type",
    "airbark_23002" : "invalid document id",
    "airbark_23003" : "invalid document issue place",
    "airbark_23004" : "invalid document images",
    "airbark_23005" : "document not found",
    
    "airbark_24001" : "invalid name",
    "airbark_24002" : "invalid number plate",
    "airbark_24003" : "invalid issue place",
    "airbark_24004" : "invalid images",
    "airbark_24005" : "vehicles not found",
    
    "airbark_25001" : "invalid available status",
    "airbark_25002" : "invalid is traveling",
    "airbark_25003" : "invalid per hour rate",
    "airbark_25004" : "invalid years of experience",
    "airbark_25005" : "invalid pet size preferences",
    "airbark_25006" : "invalid pet behavior preferences",
    "airbark_25007" : "invalid availability",
    "airbark_25008" : "invalid currency",
    "airbark_25009" : "invalid breed",
    
    "airbark_26001" : "profile not complete",
    "airbark_26002" : "finder profile not complete",
    "airbark_26003" : "minder profile not complete",
    "airbark_26004" : "already has active request",
    "airbark_26005" : "nothing to approve",
    "airbark_26006" : "invalid cancelled param",
    "airbark_26007" : "request no found",
    "airbark_26008" : "couldnt cancel request",
    
    "airbark_27001" : "invalid from date",
    "airbark_27002" : "invalid to date",
    "airbark_27003" : "invalid per hour rate",
    "airbark_27004" : "invalid currency",
    "airbark_27005" : "invalid pets",
    "airbark_27006" : "invalid message",
    "airbark_27007" : "invalid user",
    "airbark_27008" : "add pet to send minder request",
    "airbark_27009" : "profile not verified",
    "airbark_27010" : "minder not found",
    "airbark_27011" : "request not found",
    "airbark_27012" : "invalid status",
    "airbark_27013" : "unable to update request",
    "airbark_27014" : "unable to clock in",
    "airbark_27015" : "unable to clock out",
    
    "airbark_27100" : "invalid ratings",
    "airbark_27101" : "invalid message",
    "airbark_27102" : "invalid images",
    "airbark_27103" : "review already exists",
    "airbark_27104" : "review not found",
    "airbark_27105" : "invalid request",
    "airbark_27106" : "either user or pet is required",
    
    "airbark_28000" : "invalid users",
    "airbark_28001" : "conversation not found",
    "airbark_28002" : "invalid text",
    "airbark_28003" : "invalid media",
    
    "airbark_40001" : "invalid email",
    "airbark_40002" : "email already exists",
    "airbark_40003" : "invalid password",
    "airbark_40004" : "password min 6 character long",
    "airbark_40005" : "password max 30 character long",
    "airbark_40006" : "invalid full name",
    "airbark_40008" : "invalid email or password",
    "airbark_40009" : "invalid or expired refresh token",
    "airbark_40010" : "user not found",
    "airbark_40011" : "email already verified",
    "airbark_40012" : "invalid email verification token",
    "airbark_40013" : "invalid password reset token",
    "airbark_40014" : "invalid fcm token",
    "airbark_40015" : "invalid fcm device type",
    "airbark_40016" : "invitation invalid email",
    "airbark_40017" : "invitation invalid role",
    "airbark_40018" : "invitation user with email already exists",
    "airbark_40019" : "invitation not found",
    "airbark_40020" : "invitation expired",
    "airbark_40021" : "invitation already accepted",
    "airbark_40022" : "can not delete accepted invitation",
    "airbark_40023" : "can not update accepted invitation",
    "airbark_40024" : "invalid session id",
    "airbark_40025" : "session not found",
    
    "airbark_60001" : "invalid file type",
    "airbark_60002" : "invalid file name",
    
    "airbark_70001" : "invalid name",
    "airbark_70002" : "breed not found"
]
