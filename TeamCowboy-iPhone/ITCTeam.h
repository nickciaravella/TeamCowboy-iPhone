//
//  ITCTeam.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"
#import "ITCActivity.h"

/**
 @brief A team.
 */
@interface ITCTeam : ITCSerializableObject

@property (nonatomic, readonly) NSNumber *teamId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) ITCActivity *activity;
@property (nonatomic, readonly) NSString *teamMemberType;
@property (nonatomic, readonly) UIImage  *loadedThumbnailPhoto;
@property (nonatomic, readonly) BOOL hasThumbnailPhoto;

/**
 @brief Loads the thumbnail photo for the team. Once complete, the loadedThumbnailPhoto property will be initialized.
 @param error If an error occurs, it will be put into this variable.
 @return The data for the thumbnail photo.
 */
- (NSData *)loadThumbnailPhotoWithError:(NSError **)error;

@end
