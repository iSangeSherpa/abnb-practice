//
//  public-user+entity.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 12/12/2022.
//

import Foundation
import RealmSwift
import RxCocoa
import RxDataSources

class FinderProfilePeek : Object{
    @Persisted  var averageRating: Float
    @Persisted  var totalRatings: Int
    @Persisted  var completionStatus: ProfileCompletionStatus
    @Persisted  var approvalStatus: ApprovalStatus
    
    
    convenience init(
        averageRating: Float,
        totalRatings: Int,
        completionStatus: ProfileCompletionStatus,
        approvalStatus: ApprovalStatus
    ) {
        
        self.init()
        
        self.averageRating = averageRating
        self.totalRatings = totalRatings
        self.completionStatus = completionStatus
        self.approvalStatus = approvalStatus
    }
}

class MinderProfilePeek :  Object {
    @Persisted  var availableStatus: AvailableStatus
    @Persisted  var approvalStatus: ApprovalStatus
    @Persisted  var petSizePreferences: List<PetSizePreferences>
    @Persisted  var petBehaviorPreferences: List<String>
    @Persisted  var averageRating: Float
    @Persisted  var totalRatings: Int
    
    convenience init(
        availableStatus: AvailableStatus,
        approvalStatus: ApprovalStatus,
        petSizePreferences: [PetSizePreferences],
        petBehaviorPreferences: [String],
        averageRating: Float,
        totalRatings: Int
    ) {
        self.init()
        
        self.availableStatus = availableStatus
        self.approvalStatus = approvalStatus
        self.petSizePreferences = petSizePreferences.asRealmList()
        self.petBehaviorPreferences = petBehaviorPreferences.asRealmList()
        self.averageRating = averageRating
        self.totalRatings = totalRatings
    }
}

class PublicUser : Object {
    @Persisted var id: String
    @Persisted var email: String
    @Persisted var fullName: String?
    @Persisted var showMyNumber: Bool?
    @Persisted var phoneNumber: String?
    @Persisted var active: Bool
    @Persisted var emailVerified: Bool
    @Persisted var phoneVerified: Bool
    @Persisted var activeProfile: ActiveProfile?
    @Persisted var bio: String?
    @Persisted var dob: String?
    @Persisted var image: String?
    @Persisted var gender: Gender?
    @Persisted var address: AddressEntity?
    @Persisted var minderProfile: MinderProfilePeek?
    @Persisted var finderProfile: FinderProfilePeek?
    @Persisted var hasVerifiedDocuments : Bool
    
    convenience  init(
        id: String,
        email: String,
        fullName: String?,
        phoneNumber: String?,
        hidePhoneNumber: Bool?,
        active: Bool,
        emailVerified: Bool,
        phoneVerified: Bool,
        activeProfile: ActiveProfile?,
        bio: String? ,
        dob: String?,
        image: String? ,
        gender: Gender? ,
        address: AddressEntity? ,
        minderProfile: MinderProfilePeek?,
        finderProfile: FinderProfilePeek?,
        hasVerifiedDocuments: Bool
    ) {
        self.init()
        
        self.id = id
        self.email = email
        self.fullName = fullName
        self.phoneNumber = phoneNumber
        self.showMyNumber = !(hidePhoneNumber ?? true)
        self.active = active
        self.emailVerified = emailVerified
        self.phoneVerified = phoneVerified
        self.activeProfile = activeProfile
        self.bio = bio
        self.dob = dob
        self.image = image
        self.gender = gender
        self.address = address
        self.minderProfile = minderProfile
        self.finderProfile = finderProfile
        self.hasVerifiedDocuments = hasVerifiedDocuments
    }
    
  
    
    func isProfileVerified()->Bool{
        guard let activeProfile = activeProfile else{
            return false;
        }
        
        switch(activeProfile){
            
        case .MINDER:
            return minderProfile?.approvalStatus == .APPROVED && hasVerifiedDocuments
        case .FINDER:
            return finderProfile?.approvalStatus == .APPROVED && hasVerifiedDocuments
        case .BOTH:
           return minderProfile?.approvalStatus == .APPROVED && finderProfile?.approvalStatus == .APPROVED && hasVerifiedDocuments
        }
    }
}

extension PublicUser: IdentifiableType{
    
    var identity: String{
        return self.isInvalidated ? UUID().uuidString : id
    }
}

struct ConversationWithLatestMessage {
    var conversation:Conversation
    var lastMessage:ConversationMessage?
}

extension ConversationWithLatestMessage : Equatable,IdentifiableType {
   
    static func == (lhs: ConversationWithLatestMessage, rhs: ConversationWithLatestMessage) -> Bool {
        return (lhs.lastMessage?.isInvalidated == true || rhs.lastMessage?.isInvalidated == true) ? false : (lhs.lastMessage?.id  == rhs.lastMessage?.id)
    }
    
    var identity: String{
        return conversation.isInvalidated ? UUID().uuidString : conversation.id
    }
}

enum MessageContentType:String,Encodable{
    case Photo
    case Text
}


struct MessageWithOtherUser {
    var message: ConversationMessage
    var otherUser: PublicUser
}


extension MessageWithOtherUser: Equatable,IdentifiableType{
    static func == (lhs: MessageWithOtherUser, rhs: MessageWithOtherUser) -> Bool {
        return lhs.message.id  == rhs.message.id
    }
    
    var identity: String{
        return message.id
    }
    
    var isSentbySelf:Bool{
        get{
            return SessionManager.shared.userId == message.fromUserID
        }
    }
    
    var contentType:MessageContentType{
        get{
            return message.media.count > 0 ? .Photo : .Text
        }
    }
}
