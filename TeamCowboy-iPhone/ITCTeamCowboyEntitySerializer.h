//
//  ITCTeamCowboyEntitySerializer.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCObjectSerializer.h"

@interface ITCTeamCowboyEntitySerializer : NSObject <ITCObjectSerializer>

/**
 @brief Creates a new serializer for the given type.
 @param type          The class of the object to be serialized. This should be a subclass of ITCSerializableObject.
 @param isACollection If YES, an array of 'type' is expected to be serialized.
 @return An initialized serializer.
 */
+ (ITCTeamCowboyEntitySerializer *)serializerForClass:(Class)type
                                         isCollection:(BOOL)isACollection;

@end
