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
             @"userId"       : @"userId",
             @"fullName"     : @"fullName",
             @"phoneNumber"  : @"phone1",
             @"emailAddress" : @"emailAddress1",
             @"serverGender" : @"gender"
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
                                withCacheIdentifier:bypassCache ? nil : [NSString stringWithFormat:@"user_%@", userId]
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
                                              withCacheIdentifier:bypassCache ? nil : [NSString stringWithFormat:@"user_%@_teams", self.userId]
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
                                              withCacheIdentifier:bypassCache ? nil : [NSString stringWithFormat:@"user_%@_teamEvents", self.userId]
                                                 teamCowboyMethod:@"User_GetTeamEvents"
                                                  queryParameters:nil
                                                    cacheDuration:30
                                                            error:error];
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
