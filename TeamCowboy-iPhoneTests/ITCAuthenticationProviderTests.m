//
//  ITCAuthenticationProviderTests.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ITCTestCase.h"
#import "ITCAuthenticationRequestHandler.h"
#import "ITCAuthenticationProviderImp.h"

#pragma mark - ITCAuthenticationProviderTests (interface)

@interface ITCAuthenticationProviderTests : ITCTestCase

@property (nonatomic, strong) ITCAuthenticationRequestHandler *authHttpHandler;

@property (nonatomic, strong) ITCAuthenticationProviderImp *authProvider;

@end

#pragma mark - ITCAuthenticationProviderTests (implementation)

@implementation ITCAuthenticationProviderTests

#pragma mark - setUp / tearDown

- (void)setUp
{
    [super setUp];
    self.authHttpHandler = [ITCAuthenticationRequestHandler new];
    self.httpConnectionDelegate.requestHandlers = @[ self.authHttpHandler ];
    
    self.authProvider = [ITCAuthenticationProviderImp new];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Parameter validation

- (void)test_authenticateUser_whenUsernameIsNil_returnsInvalidArgError
{
    [self verifyInvalidArgIsReturnedForUsername:nil password:@"password"];
}

- (void)test_authenticateUser_whenUsernameIsEmpty_returnsInvalidArgError
{
    [self verifyInvalidArgIsReturnedForUsername:@"" password:@"password"];
}

- (void)test_authenticateUser_whenUsernameIsWhitespace_returnsInvalidArgError
{
     [self verifyInvalidArgIsReturnedForUsername:@"   " password:@"password"];
}

- (void)test_authenticateUser_whenPasswordIsNil_returnsInvalidArgError
{
    [self verifyInvalidArgIsReturnedForUsername:@"user" password:nil];
}

- (void)test_authenticateUser_whenPasswordIsEmpty_returnsInvalidArgError
{
    [self verifyInvalidArgIsReturnedForUsername:@"user" password:@""];
}

- (void)test_authenticateUser_whenPasswordIsWhitespace_returnsInvalidArgError
{
    [self verifyInvalidArgIsReturnedForUsername:@"user" password:@"    "];
}

- (void)verifyInvalidArgIsReturnedForUsername:(NSString *)username
                                     password:(NSString *)password
{
    // Act
    NSError *error = [self.authProvider authenticateUserWithUsername:username password:password];
    
    // Assert
    XCTAssertEqual(error.code, ITCErrorInvalidArgument);
}

#pragma mark -

- (void)test_authenticateUser_correctParametersSentToService
{
    // Act
    [self.authProvider authenticateUserWithUsername:@"john" password:@"doe"];
    
    // Assert
    XCTAssertEqualObjects(self.authHttpHandler.param_username, @"john");
    XCTAssertEqualObjects(self.authHttpHandler.param_password, @"doe");
    XCTAssertEqualObjects(self.authHttpHandler.param_urlRequest.HTTPMethod, @"POST");
    XCTAssertEqualObjects(self.authHttpHandler.param_urlRequest.URL, [NSURL URLWithString:@"https://api.teamcowboy.com/v1/"]);
}

@end
