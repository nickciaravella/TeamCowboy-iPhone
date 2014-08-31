//
//  ITCSerializableObjectTests.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ITCMockObject : ITCSerializableObject

@property (nonatomic, strong) NSString *flatProperty;
@property (nonatomic, strong) NSString *nestedProperty;
@property (nonatomic, strong) ITCMockObject *embeddedProperty;
@property (nonatomic, strong) NSArray *arrayProperty; // Of ITCMockObject
@property (nonatomic, strong) NSArray *stringArrayProperty; // Of NSString

@end

@implementation ITCMockObject

+ (NSDictionary *)propertyToKeyPathMapping
{
    return @{ @"flatProperty"        : @"property1",
              @"nestedProperty"      : @"anotherDictionary.nestedProperty",
              @"embeddedProperty"    : @"serializableProperty",
              @"arrayProperty"       : @"arrayProperty",
              @"stringArrayProperty" : @"stringArrayProperty"};
}

+ (NSDictionary *)embeddedObjectPropertyToClassMapping
{
    return @{ @"embeddedProperty" : @"ITCMockObject",
              @"arrayProperty"    : @"ITCMockObject" };
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

- (void)testSerializationOfArrayProperty
{
    // Setup
    NSDictionary *inputDictionary = @{ @"arrayProperty" : @[ @{ @"property1" : @"something1" }, @{ @"property1" : @"something2" } ] };
    
    // Act
    ITCMockObject *object = [[ITCMockObject alloc] initWithDictionary:inputDictionary];
    
    // Asserts
    XCTAssertEqual([object.arrayProperty count], 2U);
    XCTAssertEqualObjects([object.arrayProperty[0] flatProperty], @"something1");
    XCTAssertEqualObjects([object.arrayProperty[1] flatProperty], @"something2");
}

- (void)testSerializationOfStringArrayProperty
{
    // Setup
    NSDictionary *inputDictionary = @{ @"stringArrayProperty" : @[ @"something1", @"something2" ] };
    
    // Act
    ITCMockObject *object = [[ITCMockObject alloc] initWithDictionary:inputDictionary];
    
    // Asserts
    XCTAssertEqual([object.stringArrayProperty count], 2U);
    XCTAssertEqualObjects(object.stringArrayProperty[0], @"something1");
    XCTAssertEqualObjects(object.stringArrayProperty[1], @"something2");
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

- (void)testDictionaryWithArrayProperty
{
    // Setup
    ITCMockObject *object = [[ITCMockObject alloc] init];
    
    ITCMockObject *arrayObject1 = [[ITCMockObject alloc] init];
    arrayObject1.flatProperty = @"something1";
    
    ITCMockObject *arrayObject2 = [[ITCMockObject alloc] init];
    arrayObject2.flatProperty = @"something2";
    
    object.arrayProperty = @[ arrayObject1, arrayObject2 ];
    
    // Act
    NSDictionary *dictionary = [object dictionaryFormat];
    
    // Asserts
    NSDictionary *expectedDictionary = @{ @"arrayProperty" : @[ @{ @"property1" : @"something1" }, @{ @"property1" : @"something2" } ] };
    XCTAssertEqualObjects(dictionary, expectedDictionary);
}

- (void)testDictionaryWithStringArrayProperty
{
    // Setup
    ITCMockObject *object = [[ITCMockObject alloc] init];
    object.stringArrayProperty = @[ @"something1", @"something2" ];
    
    // Act
    NSDictionary *dictionary = [object dictionaryFormat];
    
    // Asserts
    NSDictionary *expectedDictionary = @{ @"stringArrayProperty" : @[ @"something1", @"something2" ] };
    XCTAssertEqualObjects(dictionary, expectedDictionary);
}

@end
