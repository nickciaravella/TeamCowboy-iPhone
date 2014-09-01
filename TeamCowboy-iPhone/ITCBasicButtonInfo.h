//
//  ITCBasicButtonInfo.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface ITCBasicButtonInfo : NSObject

+ (ITCBasicButtonInfo *)buttonInfoWithTitle:(NSString *)title
                                     action:(void (^)())actionBlock;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void (^actionBlock)();
@property (nonatomic, assign) NSInteger tag;

@end
