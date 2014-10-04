//
//  ITCUser.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCUser.h"
#import "ITCEvent.h"
#import "ITCTeam.h"
#import "ITCTeamCowboyRepository.h"

#pragma mark - ITCUser ()

@interface ITCUser ()

@property (nonatomic, readonly) NSString *serverGender;
@property (nonatomic, readonly) NSString *thumbnailPhotoUrl;

@end

#pragma mark - ITCUser (implementation)

@implementation ITCUser

#pragma mark - ITCSerializableObject

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }

    _gender = [self genderFromServiceGender:self.serverGender];
    
    return self;
}

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{
             @"userId"            : @"userId",
             @"fullName"          : @"fullName",
             @"phoneNumber"       : @"phone1",
             @"emailAddress"      : @"emailAddress1",
             @"serverGender"      : @"gender",
             @"thumbnailPhotoUrl" : @"profilePhoto.smallUrl"
             };
}

#pragma mark - ITCUser

//
//
+ (ITCUser *)loadCurrentUserBypassingCache:(BOOL)bypassCache
                                 withError:(NSError **)error
{
    NSString *userId = [ITCAppFactory authenticationProvider].authenticationContext.userId;
    return [ITCTeamCowboyRepository getEntityOfType:[ITCUser class]
                                withCacheIdentifier:[NSString stringWithFormat:@"user_%@", userId]
                                  shouldBypassCache:bypassCache
                                   teamCowboyMethod:@"User_Get"
                                    queryParameters:nil
                                      cacheDuration:60
                                              error:error];
}

//
//
- (NSArray *)loadTeamsBypassingCache:(BOOL)bypassCache
                           withError:(NSError **)error
{
    return [ITCTeamCowboyRepository getCollectionOfEntitiesOfType:[ITCTeam class]
                                              withCacheIdentifier:[NSString stringWithFormat:@"user_%@_teams", self.userId]
                                                shouldBypassCache:bypassCache
                                                 teamCowboyMethod:@"User_GetTeams"
                                                  queryParameters:nil
                                                    cacheDuration:30
                                                            error:error];
}

//
//
- (NSArray *)loadTeamEventsBypassingCache:(BOOL)bypassCache
                                 withError:(NSError **)error
{
    return [ITCTeamCowboyRepository getCollectionOfEntitiesOfType:[ITCEvent class]
                                              withCacheIdentifier:[NSString stringWithFormat:@"user_%@_teamEvents", self.userId]
                                                shouldBypassCache:bypassCache
                                                 teamCowboyMethod:@"User_GetTeamEvents"
                                                  queryParameters:nil
                                                    cacheDuration:30
                                                            error:error];
}

//
//
- (BOOL)hasThumbnailPhoto
{
    return self.thumbnailPhotoUrl.length > 0;
}

//
//
- (NSData *)loadThumbnailPhotoWithError:(NSError **)error
{
    NSData * photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailPhotoUrl]
                                               options:NSDataReadingMappedIfSafe
                                                 error:error];
    
    _loadedThumbnailPhoto = [UIImage imageWithData:photoData];
    return photoData;
}

#pragma mark - Private

//
//
- (ITCUserGender)genderFromServiceGender:(NSString *)serviceGender
{
    if ( [serviceGender isEqualToString:@"m"] )
    {
        return ITCUserGenderMale;
    }
    else if ( [serviceGender isEqualToString:@"f"] )
    {
        return ITCUserGenderFemale;
    }
    else
    {
        return ITCUserGenderUnknown;
    }
}

//
//
- (NSString *)serviceGenderFromGender:(ITCUserGender)gender
{
    switch (gender)
    {
        case ITCUserGenderMale:    return @"m";
        case ITCUserGenderFemale:  return @"f";
        case ITCUserGenderUnknown: return @"other";
        default:                   return @"other";
    }
}

@end
