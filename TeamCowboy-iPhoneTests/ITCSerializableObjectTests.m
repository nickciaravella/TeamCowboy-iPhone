//
//  ITCSerializableObjectTests.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ITCMockObject : ITCSerializableObject

@property (nonatomic, strong) NSString *flatProperty;
@property (nonatomic, strong) NSString *nestedProperty;
@property (nonatomic, strong) ITCMockObject *embeddedProperty;

@end

@implementation ITCMockObject

+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{ @"flatProperty"     : @"property1",
              @"nestedProperty"   : @"anotherDictionary.nestedProperty",
              @"embeddedProperty" : @"serializableProperty" };
}

+ (NSDictionary *)embeddedObjectPropertyToClassMapping
{
    return @{ @"embeddedProperty" : @"ITCMockObject" };
}

@end

@interface ITCSerializableObjectTests : XCTestCase

@end

@implementation ITCSerializableObjectTests

#pragma mark - initWithDictionary

- (void)testSerializationOfFlatProperty
{
    ITCMockObject *object = [[ITCMockObject alloc] initWithDictionary:@{ @"property1" : @"something" }];
    XCTAssertEqualObjects(object.flatProperty, @"something");
}

- (void)testSerializationOfNestedProperty
{
    ITCMockObject *object = [[ITCMockObject alloc] initWithDictionary:@{ @"anotherDictionary" : @{ @"nestedProperty" : @"something" } }];
    XCTAssertEqualObjects(object.nestedProperty, @"something");
}

- (void)testSerializationOfEmbeddedProperty
{
    ITCMockObject *object = [[ITCMockObject alloc] initWithDictionary:@{ @"serializableProperty" : @{ @"property1" : @"something" } }];
    XCTAssertEqualObjects(object.embeddedProperty.flatProperty, @"something");
}

- (void)testMissingPropertiesSetToNil
{
    ITCMockObject *object = [[ITCMockObject alloc] initWithDictionary:@{ @"random" : @"Random" }];
    XCTAssertNil(object.flatProperty);
    XCTAssertNil(object.embeddedProperty);
    XCTAssertNil(object.nestedProperty);
}

#pragma mark - dictionaryFormat

- (void)testDictionaryWithFlatProperty
{
    // Setup
    ITCMockObject *object = [[ITCMockObject alloc] init];
    object.flatProperty = @"something";
    
    // Act
    NSDictionary *dictionary = [object dictionaryFormat];
    
    // Asserts
    XCTAssertEqualObjects(dictionary, @{ @"property1" : @"something" });
}

- (void)testDictionaryWithNestedProperty
{
    // Setup
    ITCMockObject *object = [[ITCMockObject alloc] init];
    object.nestedProperty = @"something";
    
    // Act
    NSDictionary *dictionary = [object dictionaryFormat];
    
    // Asserts
    NSDictionary *expectedDictionary = @{ @"anotherDictionary" : @{ @"nestedProperty" : @"something" } };
    XCTAssertEqualObjects(dictionary, expectedDictionary);
}

- (void)testDictionaryWithEmbeddedProperty
{
    // Setup
    ITCMockObject *object = [[ITCMockObject alloc] init];
    ITCMockObject *embeddedObject = [[ITCMockObject alloc] init];
    embeddedObject.nestedProperty = @"something";
    object.embeddedProperty = embeddedObject;
    
    // Act
    NSDictionary *dictionary = [object dictionaryFormat];
    
    // Asserts
    NSDictionary *expectedDictionary = @{ @"serializableProperty" : @{ @"anotherDictionary" : @{ @"nestedProperty" : @"something" } } };
    XCTAssertEqualObjects(dictionary, expectedDictionary);
}

- (void)testDictionaryWithMultipleProperties
{
    // Setup
    ITCMockObject *object = [[ITCMockObject alloc] init];
    object.flatProperty = @"something";
    object.nestedProperty = @"something2";
    
    // Act
    NSDictionary *dictionary = [object dictionaryFormat];
    
    // Asserts
    NSDictionary *expectedDictionary = @{ @"property1" : @"something",
                                          @"anotherDictionary" : @{ @"nestedProperty" : @"something2" } };
    XCTAssertEqualObjects(dictionary, expectedDictionary);
}

@end
