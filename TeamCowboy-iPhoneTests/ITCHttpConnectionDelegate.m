//
//  ITCHttpConnectionDelegate.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCHttpConnectionDelegate.h"

@implementation ITCHttpConnectionDelegate

#pragma mark - ITCHttpConnectionDelegate

//
//

- (NSData *)dataForHttpConnection:(id<ITCHttpConnection>)connection
                      withRequest:(NSURLRequest *)request
                returningResponse:(NSHTTPURLResponse **)response
                            error:(NSError **)error
{
    NSString *concatenatedString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    NSDictionary *parameters = [NSDictionary dictionaryFromURLQuery:concatenatedString];
    
    if ( ![self containsAllRequiredParameters:parameters] )
    {
        self.unhandledRequests = [self.unhandledRequests arrayByAddingObject:request];
        return nil;
    }
    
    NSString *method = parameters[ @"method" ];
    for (id<ITCTeamCowboyRequestHandler> handler in self.requestHandlers)
    {
        if ( [handler canHandleMethod:method] )
        {
            return [handler dataForRequest:request
                                withMethod:method
                         requestParameters:parameters
                         returningResponse:response
                                     error:error];
        }
    }
    
    self.unhandledRequests = [self.unhandledRequests arrayByAddingObject:request];
    return nil;
}

#pragma mark - Private

//
//
- (BOOL)containsAllRequiredParameters:(NSDictionary *)parameters
{
    return ([parameters[ @"sig" ] length] > 0 &&
            [parameters[ @"timestamp" ] length] > 0 &&
            [parameters[ @"method" ] length] > 0 &&
            [parameters[ @"nonce" ] length] > 0 &&
            [parameters[ @"response_type" ] length] > 0 &&
            [parameters[ @"api_key" ] length] > 0);
}

@end
