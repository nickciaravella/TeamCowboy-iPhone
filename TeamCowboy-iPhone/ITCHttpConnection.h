//
//  ITCHttpConnection.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

/**
 @brief Abstraction around making HTTP connections.
 */
@protocol ITCHttpConnection <NSObject>

/**
 @brief Sends a request to the HTTP service.
 @param request  The HTTP request to make.
 @param response The HTTP response received.
 @param error    An error that occurred when making the request. Nil on success.
 @return The returned body data from the response.
 */
- (NSData *)sendRequest:(NSURLRequest *)request
      returningResponse:(NSHTTPURLResponse **)response
                  error:(NSError **)error;

@end
