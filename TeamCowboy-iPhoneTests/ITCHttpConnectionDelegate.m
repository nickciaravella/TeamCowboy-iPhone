//
//  ITCHttpConnectionDelegate.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCHttpConnectionDelegate.h"

@implementation ITCHttpConnectionDelegate

- (NSData *)dataForHttpConnection:(id<ITCHttpConnection>)connection
                      withRequest:(NSURLRequest *)request
                returningResponse:(NSHTTPURLResponse **)response
                            error:(NSError **)error
{
    NSString *method = @"Auth_GetUserToken";
    
    for (id<ITCTeamCowboyRequestHandler> handler in self.requestHandlers)
    {
        if ( [handler canHandleMethod:method] )
        {
            return [handler dataForRequest:request
                                withMethod:method
                         requestParameters:nil
                         returningResponse:response
                                     error:error];
        }
    }
    
    self.unhandledRequests = [self.unhandledRequests arrayByAddingObject:request];
    return nil;
}

@end
