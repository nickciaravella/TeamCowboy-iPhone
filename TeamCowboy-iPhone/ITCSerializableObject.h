//
//  ITCSerializableObject.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief An object that can be serialized from a dictionary.
 */
@interface ITCSerializableObject : NSObject

/**
 @brief Initializes the object from a dictionary. This is the default constructor.
 @param dictionary A dictionary that contains the data for the object.
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
