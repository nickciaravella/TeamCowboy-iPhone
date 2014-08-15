//
//  ITCHttpConnectionMock.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCHttpConnectionMock.h"

@implementation ITCHttpConnectionMock

- (NSData *)sendRequest:(NSURLRequest *)request
      returningResponse:(NSHTTPURLResponse **)response
                  error:(NSError **)error
{
    return [self.delegate dataForHttpConnection:self
                                    withRequest:request
                              returningResponse:response
                                          error:error];
}

@end
