//
//  ITCTeam.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTeam.h"

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
    
    NSDictionary *teamPhoto = dictionary[ @"teamPhoto" ];
    if ( teamPhoto[ @"thumbUrl" ] )
    {
        _hasThumbnailPhoto = YES;
        _thumbnailPhotoUrl = teamPhoto[ @"thumbUrl" ];
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
    
    if ( self.hasThumbnailPhoto && self.thumbnailPhotoUrl )
    {
        [dictionary setValue:@{ @"thumbUrl" : self.thumbnailPhotoUrl } forKey:@"teamPhoto"];
    }
    
    return dictionary;
}

#pragma mark - ITCTeam

@synthesize teamId               = _teamId;
@synthesize name                 = _name;
@synthesize hasThumbnailPhoto    = _hasThumbnailPhoto;
@synthesize loadedThumbnailPhoto = _loadedThumbnailPhoto;

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
