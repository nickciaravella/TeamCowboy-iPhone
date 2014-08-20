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
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (!(self = [super initWithDictionary:dictionary])) { return nil; }
    
    _teamId = dictionary[ @"teamId" ];
    _name   = dictionary[ @"name" ];
    _activity = [[ITCActivity alloc] initWithDictionary:dictionary[ @"activity" ]];
    _teamMemberType = dictionary[ @"meta" ][ @"teamMemberType" ][ @"titleShortSingular" ];
    
    NSDictionary *teamPhoto = dictionary[ @"teamPhoto" ];
    if ( teamPhoto[ @"smallUrl" ] )
    {
        _hasThumbnailPhoto = YES;
        _thumbnailPhotoUrl = teamPhoto[ @"smallUrl" ];
    }
 
    return self;
}

//
//
- (NSDictionary *)dictionaryFormat
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    [dictionary safeSetValue:self.teamId forKey:@"teamId"];
    [dictionary safeSetValue:self.name forKey:@"name"];
    [dictionary safeSetValue:[self.activity dictionaryFormat] forKey:@"activity"];

    if ( self.teamMemberType )
    {
        [dictionary setValue:@{ @"teamMemberType" : @{ @"titleShortSingular" : self.teamMemberType } }
                      forKey:@"meta"];
    }
    
    if ( self.hasThumbnailPhoto && self.thumbnailPhotoUrl )
    {
        [dictionary setValue:@{ @"smallUrl" : self.thumbnailPhotoUrl } forKey:@"teamPhoto"];
    }
    
    return dictionary;
}

#pragma mark - ITCTeam

@synthesize teamId               = _teamId;
@synthesize name                 = _name;
@synthesize hasThumbnailPhoto    = _hasThumbnailPhoto;
@synthesize loadedThumbnailPhoto = _loadedThumbnailPhoto;
@synthesize teamMemberType       = _teamMemberType;

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
