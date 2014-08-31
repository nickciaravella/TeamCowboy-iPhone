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

/**
 @brief Deserializes the object to its dictionary format.
 */
- (NSDictionary *)dictionaryFormat;

/**
 @brief A mapping between the property name of the object and a key path mapping inside the dictionary. This dictionary is used for serializing and deserializing the object to/from a dictionary.
 @example @{ @"property" : @"key1.key2" } would map the property to value in @{ @"key1" : @{ @"key2" : @"value" } }
 */
+ (NSDictionary *)propertyToKeyPathMapping;

/**
 @brief A mapping of embedded serializable object properties and their class.
 @example @{ @"property" : @"ITCSerializableObject" } will treat the property as an embedded ITCSerializableObject, and try to initialize it using initWithDictionary.
 */
+ (NSDictionary *)embeddedObjectPropertyToClassMapping;

@end
