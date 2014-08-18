//
//  ITCUser.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCUser.h"
#import "ITCTeamCowboyEntitySerializer.h"

@implementation ITCUser

#pragma mark - ITCSerializableObject

//
//
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    _userId       = dictionary[ @"userId" ];
    _fullName     = dictionary[ @"fullName" ];
    _phoneNumber  = dictionary[ @"phoneNumber1" ];
    _emailAddress = dictionary[ @"emailAddress1" ];
    _gender       = [self genderFromServiceGender:dictionary[ @"gender" ]];
    
    return self;
}

//
//
- (NSDictionary *)dictionaryFormat
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary safeSetValue:self.userId       forKey:@"userId"];
    [dictionary safeSetValue:self.fullName     forKey:@"fullName"];
    [dictionary safeSetValue:self.phoneNumber  forKey:@"phoneNumber1"];
    [dictionary safeSetValue:self.emailAddress forKey:@"emailAddress1"];
    [dictionary safeSetValue:[self serviceGenderFromGender:self.gender] forKey:@"gender"];
    return dictionary;
}

#pragma mark - ITCUser

@synthesize userId       = _userId;
@synthesize fullName     = _fullName;
@synthesize phoneNumber  = _phoneNumber;
@synthesize emailAddress = _emailAddress;
@synthesize gender       = _gender;

//
//
+ (ITCUser *)loadCurrentUserWithError:(NSError **)error
{
    if ( !error ) { return nil; }
    
    // First try to load the user from the cache.
    ITCAuthenticationContext *authContext = [ITCAppFactory authenticationProvider].authenticationContext;
    NSError *cacheReadError = nil;
    NSDictionary *userDictionary = [[ITCAppFactory cache] dictionaryFromCacheIdentifier:[self cacheIdentifierFromUserId:authContext.userId]
                                                                                  error:&cacheReadError];
    if ( !cacheReadError )
    {
        return [[ITCUser alloc] initWithDictionary:userDictionary];
    }

    // Otherwise load the user from the service
    if ( !authContext.token )
    {
        *error = [NSError errorWithCode:ITCErrorUserNotAuthenticated message:@"No user is currently authenticated."];
        return nil;
    }
        
    ITCUser *user =  [[ITCAppFactory teamCowboyService] getRequestWithMethod:@"User_Get"
                                                             queryParameters:@{ @"userToken" : authContext.token }
                                                     usingResponseSerializer:[ITCTeamCowboyEntitySerializer serializerForClass:[ITCUser class] isCollection:NO]
                                                                       error:error];
    ITCLogAndReturnValueOnError(*error, nil, @"Failed to load the current logged in user.");

    // If successful, add the user to the cache.
    NSError *cacheWriteError = [[ITCAppFactory cache] addDictionary:[user dictionaryFormat]
                                                 forNumberOfMinutes:60
                                                     withIdentifier:[self cacheIdentifierFromUserId:user.userId]];
    ITCLogError(cacheWriteError, @"Failed to write the user to the cache.");
    
    return user;
}

#pragma mark - Private

//
//
+ (NSString *)cacheIdentifierFromUserId:(NSString *)userId
{
    return [NSString stringWithFormat:@"user_%@", userId];
}

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
