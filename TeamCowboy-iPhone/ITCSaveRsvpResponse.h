//
//  ITCSaveRsvpResponse.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCSerializableObject.h"

/**
 @brief A response object for a request to save an RSVP.
 */
@interface ITCSaveRsvpResponse : ITCSerializableObject

/**
 @brief YES if the RSVP was saved, NO otherwise. If NO, check the statusCode property.
 */
@property (nonatomic, readonly) BOOL isRsvpSaved;

/**
 @brief More details for why an RSVP was not saved.
 */
@property (nonatomic, readonly) NSString *statusCode;

@end
