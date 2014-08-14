//
//  ITCObjectSerializer.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@protocol ITCObjectSerializer <NSObject>

/**
 @brief Serializes data into an object.
 @param objectData The object in data form.
 @param error       An error that occurred during serialization. Nil on success.
 @return The initialized object.
 */
- (id)serializedObjectFromData:(NSData *)objectData
                         error:(NSError **)error;

@end
