//
//  ITCTestCase.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ITCHttpConnectionDelegate.h"

@interface ITCTestCase : XCTestCase

// Individual test cases should add request handlers to the delegate
// held in "self.httpConnectionDelegate". This delegate is set up to
// catch HTTP requests in setUp.
@property (nonatomic, strong) ITCHttpConnectionDelegate *httpConnectionDelegate;

@end
