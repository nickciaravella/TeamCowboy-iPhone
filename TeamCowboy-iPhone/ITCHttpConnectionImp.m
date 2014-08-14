//
//  ITCHttpConnectionImp.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCHttpConnectionImp.h"

@implementation ITCHttpConnectionImp

//
//
- (NSData *)sendRequest:(NSURLRequest *)request
      returningResponse:(NSHTTPURLResponse **)response
                  error:(NSError **)error
{
    return [NSURLConnection sendSynchronousRequest:request
                                 returningResponse:response
                                             error:error];
}

@end
