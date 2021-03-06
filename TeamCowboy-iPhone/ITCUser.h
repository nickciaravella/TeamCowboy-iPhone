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

/**
 @brief A user. Depending on how the user is retrieved, different properties may be available.
 */
@interface ITCUser : ITCSerializableObject

/**
 @brief Gets the current signed in user.
 @param bypassCache YES if cached values should be ignored.
 @param error       If an error occurred, it will be put into this parameter.
 @return The current user.
 */
+ (ITCUser *)loadCurrentUserBypassingCache:(BOOL)bypassCache
                                 withError:(NSError **)error;

/**
 @brief Gets the teams that the user belongs to.
 @param bypassCache YES if cached values should be ignored.
 @param error       If an error occurred, it will be put into this parameter.
 @return An array of ITCTeam objects.
 */
- (NSArray *)loadTeamsBypassingCache:(BOOL)bypassCache
                           withError:(NSError **)error;

/**
 @brief Gets the events for the teams that the user belongs to.
 @param bypassCache YES if cached values should be ignored.
 @param error       If an error occurred, it will be put into this parameter.
 @return An array of ITCEvent objects.
 */
- (NSArray *)loadTeamEventsBypassingCache:(BOOL)bypassCache
                                withError:(NSError **)error;

/**
 @brief Loads the thumbnail photo for the team. Once complete, the loadedThumbnailPhoto property will be initialized.
 @param error If an error occurs, it will be put into this variable.
 @return The data for the thumbnail photo.
 */
- (NSData *)loadThumbnailPhotoWithError:(NSError **)error;

//
// User properties
//
@property (nonatomic, readonly) NSNumber *userId;
@property (nonatomic, readonly) NSString *fullName;
@property (nonatomic, readonly) ITCUserGender gender;
@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic, readonly) NSString *emailAddress;

@property (nonatomic, readonly) BOOL hasThumbnailPhoto;
@property (nonatomic, readonly) UIImage *loadedThumbnailPhoto;


@end
