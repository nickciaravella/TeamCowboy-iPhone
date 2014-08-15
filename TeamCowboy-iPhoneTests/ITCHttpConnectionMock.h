//
//  ITCHttpConnectionMock.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ITCHttpConnectionDelegate <NSObject>

- (NSData *)dataForHttpConnection:(id<ITCHttpConnection>)connection
                      withRequest:(NSURLRequest *)request
                returningResponse:(NSHTTPURLResponse **)response
                            error:(NSError **)error;

@end

@interface ITCHttpConnectionMock : NSObject <ITCHttpConnection>

@property (nonatomic, weak) id<ITCHttpConnectionDelegate> delegate;

@end
