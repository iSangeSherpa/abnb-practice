//
//  strings.swift
//  airbarknbark
//
//  Created by Sujan Poudel on 07/09/2022.
//

import Foundation

class Singleton  {
    static let sharedInstance = Singleton()
}

extension String {
    
    static var airbark = "Air Bark'n'Bark"
    static var continue_ = "Continue"
    static var yes =  "Yes"
    static var no =  "No"
    static var error = "Error !"
    static var alert = "Alert !"
    static var dismiss = "Dismiss"
    static var tryAgain = "Try Again"
    static var gender = "Gender"
    static var newVersionAvailable = "A new version is available, Please update to the latest version."
    
    struct Landing{
        static var pagerText1 = "Allows people to travel anywhere with their \ndog by creating a mobile network of\n \"minders and finders\"";
        static var pagerText2 = "When you travel with your dog and you need someone to mind your dog, whether it's for a few minutes, a few hours or all day, our App will connect you with 'minders' in the area. It might be someone living in the local area or a fellow traveller.";
        static var pagerText3 = "If you’re travelling around Australia, maybe you’re a grey nomad or just taking a year out, registering as a dog minder can be an excellent way to generate extra income. And when that involves meeting lots of lovely dogs, what could be a better way to earn some side money? You don’t have to be a traveller to register as a dog minder. We need minders everywhere, particularly near National Parks and tourist destinations - all you have to do is love dogs and have some spare time";
        static var button = "Get Started"
        static var alreadyHaveAccount = "Already have an account?";
        static var login = "Login";
    }
    
    struct Login{
        static var welcomeBack = "Welcome back!"
        static var emailAdress =  "Email Address"
        static var pasword = "Password"
        static var forgotPassword = "Forgot Password?"
        static var login = "Login"
        static var dontHaveAccount = "Don’t have an account?"
        static var register = "Register"
    }
    
    struct Register{
        static var gettingStarted = "Getting Started"
        static var emailAdress =  "Email Address"
        static var pasword = "Password"
        static var confirmPasword = "Confirm Password"
        static var continue_ = "Continue"
        static var termsCaption = "By creating an account, you agree to our Terms and Conditions."
        static var alreadyHaveAccount = "Already have an account?";
        static var login = "Login"
        static var termsLink = "https://www.airbarknbark.com.au/air-barknbark-terms-of-service/"
        static var privacyPolicyLink = "https://www.airbarknbark.com.au/privacy-statement/"
        
        static var invalidEmail = "Invalid email, Please enter a valid email."
        static var invalidPassword = "Invalid password, Please enter a valid password."
        static var passwordsNotMatched = "Passwords not matched."
        static var termsConditionsNotAccepted = "Terms and conditions must be accepted before proceding."
        
    }
    
    struct ForgotPassword{
        static var enterPassword = "Enter Password"
        static var newPassword =  "New Password"
        static var reEnterNewPassword =  "Re-enter New Password"
        static var resetPassword = "Reset Password"
    }
    
    struct VerifyOTP{
        static var otpVerification = "OTP Verification"
        static var desciption =  "An 6 digit authentication code has been sent to your registered email."
        static var codeSent =  "Code sent. Resend code in "
        static var submit = "Submit"
        static var resendCode = "Resend code"
        
        static var invalidOTP = "Please enter a valid OTP"
    }
    
    struct SetupProfile{
        static var setupYourProfile = "Setup Your Profile"
        static var fullName = "Full Name"
        static var shortBio = "Short Bio"
        static var uploadYourPhoto = "Upload your photo"
        static var setYourPhotoText = "Set your photo as profile pic"
        static var continue_ = String.continue_
        static var myPets = "My Pets"
        static var newPet = "New Pet"
        
        static var invalidProfilePhoto = "Please select a valid profile picture"
        static var invalidFullName = "Please enter a valid full name."
        static var invalidShortbio = "Please enter a valid short bio."
        static var invalidGender = "Please select your gender"
    }
    
    struct NewPet{
        static var petInformation = "Pet information"
        static var petName = "Pet Name"
        static var dateOfBirth = "Year of Birth"
        static var dateOfBirthHint =  "Select Year of Birth"
        static var chooseBreedType =  "Choose the breed type"
        static var uploadPetPhoto =   "Upload pet photo"
        static var vaccinationCertificate = "Please include immunization certificate in photos."
        static var canUploadMoreThanOne =  "You can upload more than one."
        static var immunizationStatus =  "Immunization Status"
        static var behaviour =  "Personality"
        static var selectBehaviour =  "Select the personality"
        static var personalityInfo =  "Please include the one that best describes your dog’s personality when being minded. We recommend you to expand on this in your dog’s ‘about’ information and to always discuss your dog’s personality with a potential minder."
        
        static var invalidPetName = "Please enter a valid pet name."
        static var invalidAbout = ""
        static var invalidDob = "Please select valid date of birth."
        static var invalidBreedType = "Please select breed type."
        static var invalidImmunizationStatus = "Please choose immunization status."
        static var invalidPetBehaviour = "Please select pet personality."
        static var invalidPetPhoto = "Please select pet photos."
    }
    
    struct RegisterVerification{
        static var verificationForm = "Verification Form"
        static var addressOptional = "Address (Optional)"
        static var iAmTraveller = "I am a traveller"
        static var emailAdress = "Email Address"
        static var dateOfBirth = "Date of Birth"
        static var dateOfBirthOptional = "Date of Birth (Optional)"
        static var dateOfBirthHint = "Day/Month/Year"
        static var contactNumber = "Contact Number"
        static var contactNumberOptional = "Contact Number (Optional)"
        static var emergencyContactNumber = "Kin/Emergency Contact"
        static var emergencyContactNumberOptional = "Kin/Emergency Contact (Optional)"
        static var addLegalDocument = "Add Legal Document"
        static var addLegalDocumentOptional = "Add Legal Document (Optional)"
        static var fillLegalIdSection = "Fill out the legal ID section"
        static var emergencyContactInfo = "In case of an emergency."
        static var dontHaveCriminalRecord = "I do not have any past criminal convictions against animals or theft."
        
        static var invalidAddress = "Please select a valid address"
        static var invalidDob = "Please select a valid date of birth"
        static var invalidContactNumber = "Please enter a valid contact number"
        static var invalidEmergencyContactNumber = "Please enter a valid Kin/Emergency contact number"
        static var invalidDocument = "Please add a valid legal document"
        static var hasCriminalActivity = "Cannot have any past criminal convictions against animals or theft."
        
        static var isTravellingInfoText = "In lieu of a permanent address, vehicle registration is required - in case of emergency."
        static var idVerifiedInfoText = "Only Minders (or both) who include ID will be given a tick of verification on their profile"
    }
    
    struct NewVehicle{
        static var vehicleDetails = "Vehicle Details"
        static var vehicleName = "Vehicle Name"
        static var numberPlate = "Number Plate"
        static var issuePlace = "Issued Place"
        static var vehiclePhoto =  "Vehicle Photo"
        static var uploadVehiclePhoto =  "Upload your vehicle photo"
        static var addVehicle =  "Add Vehicle"
        static var includePhotosInfo =  "Please include a photo of your registration number - (other users can not view this, but we need this to make the app safe and in case of an emergency). "
        
        static var invalidVehicleName = "Please enter a valid vehicle name."
        static var invalidNumberPlate = "Please enter a valid number plate."
        static var invalidIssuedPlace = "Please enter a valid issued place."
        static var invalidVehiclePhoto = "Please select vehicle photos."
    }
    struct NewDocument{
        static var addDrivingLicenseInfo = "If applicable, please upload a photo of both the front and back of your driver's licence"
        static var legalDocInfoText = "We need photo proof of ID for security purposes and to make the app safe"
        
        static var invalidDocumentType = "Please select a valid document type."
        static var invalidIdentificationNumber = "Please enter a valid identification number."
        static var invalidIssuedPlace = "Please enter a valid issued place."
        static var invalidDocumentPhoto = "Please select document photos"
        
    }
    
    struct MinderProfileSetup{
        static var profileSetup = "Profile Setup"
        static var availability = "Availability"
        static var availabilityInfo = "This is only a general availability setting. You can always mind outside of these days and hours, if suitable."
        static var areYouAvailable = "Are you available?"
        static var availableWeekDays = "Available week days"
        static var workingHours = "Working Hours"
        static var rates = "Rates"
        static var payPerService = "Service Charge"
        static var perHour = "/hour"
        static var experience = "Experience"
        static var yearsOfExperience = "Years of Experience"
        static var noExperience = "No experience"
        static var preferences = "Preferences"
        static var dogSmall = "Small dog (0-15 lbs)"
        static var dogMedium = "Medium dog (16-40 lbs)"
        static var dogLarge = "Large dog (41-100 lbs)"
        static var breedPreferences = "Breed Preference"
        static var chooseFromList = "Choose from the list"
        static var orWriteYourOwn = "or write your own.."
        static var petBehaviour = "Pet Personality Preference"
        static var done = "Done"
        
        static var invalidAvailability = "Please select your availability."
        static var invalidAvailableWeekDays = "Please select your available week days."
        static var invalidRate = "Please enter a valid rate."
        static var invalidExperience = "Please enter a valid experience."
        static var invalidDogSizePreference = "Please select dog size preference."
        static var invalidBreedPreference = "Please select breed preference"
        static var invalidPetBehaviour = "Please select pet Personality"
        static var termsConditionsNotAccepted = "Terms and conditions must be accepted before proceding."
        
        static var missingContactAndDocuments = "Please add your contact details by visiting Profile->Edit profile \n Please add your ID documents by visiting Profile, My documents"
        static var missingContact = "Please add your contact details by visiting Profile->Edit profile"
        static var missingDocuments = "Please add your ID documents by visiting Profile, My documents"
       
    }
    
    struct HomeContainer{
        static var home = "Home"
        static var Map = "Map"
        static var chat = "Chat"
        static var profile = "Profile"
    }
    struct HomeTab{
        static var mindingFor = "Minding for"
        static var mindingBy = "Minding by"
        static var sentRequest = "Requests Sent"
        static var receivedRequest = "Requests Received"
        static var sentBooking = "Bookings Made"
        static var receivedBooking = "Bookings Received"
    
    }
    struct MapTab{
        static var searchLocation = "Search for the location"
    }
    
    struct FinderAllBokings{
        static var bookings =  "Bookings"
    }
    
    struct FinderAllRequests{
        static var requests =  "Requests"
    }
    
    struct Reviews{
        static var reviews = "Reviews"
    }
    
    struct MinderFullProfile{
        static var createRequest = "Create Request"
        static var sendRequest = "Send Request"
        static var selectDateTime = "Select date and time"
        static var selectPets = "Select Pets"
        static var additionalNotes = "Additional notes"
        static var bottomNote = "*Please wait until 24 hour to get a response"
        static var noReviews = "No reviews yet"
        static var noPets = "No pets"
        
        static var serviceChargeInfo = "If you have negotiated a reciprocal arrangement or a fixed price for the minding service please include $0 in the ‘Per Hour Rate’ field, and add the agreed price or arrangement in ‘Additional Notes’. Otherwise use the hourly rate included in the ‘Minders’ profile."
    }
    
    struct Dialog{
        static var sentSuccessTitle = "Sent Sucessfully!"
        static var sentSuccessBody = "Your request has been successfully sent to the selected minder."
        
        static var failedTitle = "Try again later!"
        static var failedBody = "Your request cannot be sent at this moment, please try again."
        
        static var thankYou = "Thank you"
        static var tryAgain = "Try again"
        
        static var sentForVerificationTitle = "Sent for verification"
        static var sentForVerificationBody = "Your account has been sent for verification. It may take upto 2-3 business days."
        static var gotoHome = "Go to Home"
        
        static var reportAccountSuccess = "Account has been reported."
        static var selectReason = "Please select reason"
        
        static var declineWithMessage = "Decline with messsage"
        
        static var deleteAccountTitle = "Delete your account"
        static var deleteAccountMessage = "Are you sure you want to delete your account? This is permanent and your account cannot be recovered."
        
        static var blockAccountMessage = "Are you sure you want to block this account?"
        static var blockAccountButtonText = "Yes, block it."
        
        static var unblockAccountMessage = "Are you sure you want to unblock this account?"
        static var unblockAccountButtonText = "Yes, unblock it."
        
        static var enableLocationServiceMessage = "Location services must be enabled for this app to work correctly."
        
        
    }
    
    struct AppSubscription{
        static var subscriptionInfoText1 = "Travel Anywhere with your Dog"
        static var subscriptionInfoText2 = "Verified Minders"
        static var subscriptionInfoText3 = "Search locations in advance"
        static var subscriptionInfoText4 = "Be a Finder/Minder or Both"
        static var proceedToPayment = "Proceed to Payment"
        
        static var paymentPlan = "Payment Plan"
        static var redeem = "Redeem Coupon"
        static var restorePurchase = "Restore Purchase"
        static var privacyPolicyTermsOfUse = "By purchasing, you agree to "
        static var privacyPolicy = "Privacy Policy"
        static var termsOfUse = "Terms of Use"
        static var termsAndCondition = "The payment for the subscription will be charged to your iTunes account. Your subscription will be automatically renewed within 24 hours prior to the end of the current subscription period until vou cancel in your iTunes Store settings. By purchasing, you agree to our Privacy Policy and Terms of Use."
        static var choosePlan = "Please choose plan to procced for the payment"
        static var subscribedTofreePlan = "Already subscribed"
        static var alreadySubscribedInOtherAccount = "There is already an active subscription associated with the user "
    }
    
    struct ChangePassword{
        static var changePassword = "Change Password"
        static var enterCurrentPassword = "Enter Current Password"
        static var enterNewPassword = "Enter New Password"
        static var passwordNote = "Password must be 8 character or more with at least one letter and one number."
        static var retypeNewPassword = "Retype New Password"
    }
    
    struct YourPets{
        static var yourPets = "Your Pets"
        static var addNew = "Add New"
        static var saveChanges = "Save Changes"
    }
    
    struct YourDocuments{
        static var yourDocuments = "Your Documents"
    }
    
    struct
    EditProfile{
        static var addressInfo = "If you are permanently on the road we need this to keep the app safe and in case of emergency."
        static var saveChanges = "Save Changes"
        static var savedSuccessfully = "Changes saved successfully."
        static var photoInfo = "Must be a photo of you and/or your dog."
        
    }
    
    struct Notifications{
        static var notifications = "Notifications"
        static var markAllAsSeen = "Mark all as seen"
    }
    
    struct RatingsAndReviews{
        static var minderTitle = "How did you like my service?"
        static var finderTitle = "Rate this finder"
        static var ratePetTitle = "Rate the Pet"
        static var addPhotos = "Add Photos"
        static var feedbackNote = "*Your feedback will be added to their profile"
        static var successTitle = "Success"
        static var successBody = "Review has been submitted successfully."
        static var invalidRatings = "Please give a valid ratings"
        static var invalidFinderRatings = "Please give a valid ratings for finder."
        static var invalidReviews = "Please write a review"
        static var invalidPetReviews = "Please fill a valid pet reviews for all pets"
    }
    
    struct Selectbreed{
        static var selectBreed = "Select breed"
        static var searchBreed = "search breed"
        static var addNewBreed = "+ add new breed"
    }
    
    struct ProfileTab{
        struct profileVerificationStatus{
             static var IN_REVIEW = "Your profile is in the process of verification."
             static var REVIEW_REQUIRED = "Your profile is in the process of verification."
             static var APPROVED = "Your profile has been approved."
             static var REJECTED = "Your profile has been rejected."
        }
    }
}
