//
//  ITCActivity.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

/**
 @brief An activity, such as "Hockey" or "Soccer"
 */
@interface ITCActivity : ITCSerializableObject

@property (nonatomic, readonly) NSString *activityId;
@property (nonatomic, readonly) NSString *name;

@end
