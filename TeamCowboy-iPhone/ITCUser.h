//
//  ITCUser.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

/**
 @brief The possible genders of a user.
 */
typedef NS_ENUM(NSUInteger, ITCUserGender)
{
    ITCUserGenderUnknown,
    ITCUserGenderMale,
    ITCUserGenderFemale
};

@interface ITCUser : ITCSerializableObject

/**
 @brief Gets the current signed in user.
 @param error An error that occurred.
 @return The current user.
 */
+ (ITCUser *)loadCurrentUserWithError:(NSError **)error;

//
// User properties
//
@property (nonatomic, readonly) NSString *userId;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) ITCUserGender gender;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, readonly) NSString *emailAddress;

@end
