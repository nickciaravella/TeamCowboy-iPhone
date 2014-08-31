//
//  ITCTeam.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeam.h"
#import "ITCTeamCowboyRepository.h"

#pragma mark - ITCTeam ()

@interface ITCTeam ()

@property (nonatomic, strong) NSString *thumbnailPhotoUrl;

@end

#pragma mark - ITCTeam (implementation)

@implementation ITCTeam

#pragma ITCSerializableObject

//
//
+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{
             @"teamId"            : @"teamId",
             @"name"              : @"name",
             @"activity"          : @"activity",
             @"teamMemberType"    : @"meta.teamMemberType.titleShortSingular",
             @"thumbnailPhotoUrl" : @"teamPhoto.smallUrl"
             };
}

//
//
+ (NSDictionary *)embeddedObjectPropertyToClassMapping
{
    return @{
             @"activity" : NSStringFromClass([ITCActivity class])
             };
}

#pragma mark - ITCTeam

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

@end
