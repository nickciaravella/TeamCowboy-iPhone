//
//  ITCTestCase.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCTestCase.h"
#import "ITCHttpConnectionMock.h"

@implementation ITCTestCase

- (void)setUp
{
    [super setUp];
    
    // Factory should be set to use the mocks
    [ITCAppFactory setShouldUseMocks:YES];

    // Set up the HTTP connection mock with a delegate for handling requests.
    // Individual test cases should add request handlers to the delegate
    // held in "self.httpConnectionDelegate".
    id<ITCHttpConnection> httpConnection = [ITCAppFactory httpConnection];
    ITCHttpConnectionMock *httpConnectionMock = (ITCHttpConnectionMock *)httpConnection;
    
    self.httpConnectionDelegate = [ITCHttpConnectionDelegate new];
    httpConnectionMock.delegate = self.httpConnectionDelegate;
}

@end
