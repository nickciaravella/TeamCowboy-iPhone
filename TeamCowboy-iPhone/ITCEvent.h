//
//  ITCEvent.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"

@interface ITCEvent : ITCSerializableObject

@property (nonatomic, readonly) NSString *eventId;
@property (nonatomic, readonly) NSString *teamName;
@property (nonatomic, readonly) NSString *opponentName;
@property (nonatomic, readonly) NSString *locationName;
@property (nonatomic, readonly) NSString *locationAddress;
@property (nonatomic, readonly) NSDate   *eventDate;
@property (nonatomic, readonly) NSString *homeAway;

@end
