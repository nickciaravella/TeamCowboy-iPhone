//
//  ITCAuthenticationProviderTests.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ITCTestCase.h"
#import "ITCAuthenticationRequestHandler.h"
#import "ITCAuthenticationProviderImp.h"
#import "ITCTeamCowboyHttpDataGenerator.h"

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

#pragma mark - Success

- (void)test_authenticateUser_correctParametersSentToService
{
    // Act
    [self.authProvider authenticateUserWithUsername:@"john" password:@"doe"];
    
    // Assert
    XCTAssertEqualObjects(self.authHttpHandler.param_username, @"john");
    XCTAssertEqualObjects(self.authHttpHandler.param_password, @"doe");
    XCTAssertEqualObjects(self.authHttpHandler.param_urlRequest.HTTPMethod, @"POST");
    XCTAssertEqualObjects(self.authHttpHandler.param_urlRequest.URL, [ITCTeamCowboyHttpDataGenerator teamCowboySecureUrl]);
}

- (void)test_authenticateUser_updatedAuthContext
{
    // Setup
    [self.authHttpHandler setAuthContextWithUserId:@"someId" token:@"someToken"];
    
    // Act
    [self.authProvider authenticateUserWithUsername:@"john" password:@"doe"];
    
    // Assert
    XCTAssertEqualObjects(self.authProvider.authenticationContext.userId, @"someId");
    XCTAssertEqualObjects(self.authProvider.authenticationContext.token,  @"someToken");
}

- (void)test_authenticateUser_missingToken_returnsGenericServerError
{
    // Setup
    [self.authHttpHandler setAuthContextWithUserId:@"someId" token:nil];
    
    // Act
    NSError *error = [self.authProvider authenticateUserWithUsername:@"john" password:@"doe"];
    
    // Assert
    XCTAssertEqual(error.code, ITCErrorGenericServerError);
}

- (void)test_authenticateUser_missingUserId_returnsGenericServerError
{
    // Setup
    [self.authHttpHandler setAuthContextWithUserId:nil token:@"someToken"];
    
    // Act
    NSError *error = [self.authProvider authenticateUserWithUsername:@"john" password:@"doe"];
    
    // Assert
    XCTAssertEqual(error.code, ITCErrorGenericServerError);
}

#pragma mark - Response errors

- (void)test_authenticateUser_httpStatus400s_returnsGenericClientError
{
    [self verifyErrorWithResponseCode:404
                         responseData:nil
                    expectedErrorCode:ITCErrorGenericClientError];
}

- (void)test_authenticateUser_httpStatus400sWithGarbageErrorData_returnsGenericClientError
{
    [self verifyErrorWithResponseCode:400
                         responseData:[@"lakfjsldfkj" dataUsingEncoding:NSUTF8StringEncoding]
                    expectedErrorCode:ITCErrorGenericClientError];
}

- (void)test_authenticateUser_httpStatus400sWithTeamCowboyError_returnsGenericTeamCowboyError
{
    [self verifyErrorWithResponseCode:400
                         responseData:[ITCTeamCowboyHttpDataGenerator dataForErrorResponseWithCode:@"methodError"
                                                                                           message:@"some message"
                                                                                        httpStatus:@"400"]
                    expectedErrorCode:ITCErrorGenericTeamCowboyError];
}

- (void)test_authenticateUser_httpStatus500s_returnsGenericServerError
{
    [self verifyErrorWithResponseCode:502
                         responseData:nil
                    expectedErrorCode:ITCErrorGenericServerError];
}

- (void)test_authenticateUser_httpStatus500sWithGarbageErrorData_returnsGenericServerError
{
    [self verifyErrorWithResponseCode:500
                         responseData:[@"lakfjsldfkj" dataUsingEncoding:NSUTF8StringEncoding]
                    expectedErrorCode:ITCErrorGenericServerError];
}

- (void)test_authenticateUser_httpStatus500sWithTeamCowboyError_returnsGenericTeamCowboyError
{
    [self verifyErrorWithResponseCode:500
                         responseData:[ITCTeamCowboyHttpDataGenerator dataForErrorResponseWithCode:@"methodError"
                                                                                           message:@"some message"
                                                                                        httpStatus:@"400"]
                    expectedErrorCode:ITCErrorGenericTeamCowboyError];
}


- (void)verifyErrorWithResponseCode:(NSInteger)httpStatus
                       responseData:(NSData *)errorData
                  expectedErrorCode:(NSUInteger)errorCode
{
    // Setup
    self.authHttpHandler.return_response = [[NSHTTPURLResponse alloc] initWithURL:[ITCTeamCowboyHttpDataGenerator teamCowboySecureUrl]
                                                                       statusCode:httpStatus
                                                                      HTTPVersion:@"1.1"
                                                                     headerFields:@{}];
    self.authHttpHandler.return_responseData = errorData;
    
    // Act
    NSError *error = [self.authProvider authenticateUserWithUsername:@"john" password:@"doe"];
    
    // Assert
    XCTAssertEqual(error.code, errorCode);
}

@end
