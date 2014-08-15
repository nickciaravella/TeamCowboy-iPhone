//
//  ITCHttpConnectionDelegate.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITCHttpConnectionMock.h"

@protocol ITCTeamCowboyRequestHandler <NSObject>

- (BOOL)canHandleMethod:(NSString *)method;

- (NSData *)dataForRequest:(NSURLRequest *)request
                withMethod:(NSString *)teamCowboyMethod
         requestParameters:(NSDictionary *)requestParameters
         returningResponse:(NSHTTPURLResponse **)response
                     error:(NSError **)error;

@end

@interface ITCHttpConnectionDelegate : NSObject <ITCHttpConnectionDelegate>

@property (nonatomic, strong) NSArray *requestHandlers;
@property (nonatomic, strong) NSArray *unhandledRequests;

@end
