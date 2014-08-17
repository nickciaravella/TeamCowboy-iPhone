//
//  ITCButtonTableViewCell.m
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

#import "ITCButtonTableViewCell.h"

@interface ITCButtonTableViewCell ()

@property (nonatomic, strong) UIColor *originalColor;

@end

@implementation ITCButtonTableViewCell

//
//
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.originalColor = self.textLabel.textColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

//
//
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    if ( highlighted )
    {
        self.textLabel.textColor = [UIColor lightGrayColor];
    }
    else
    {
        self.textLabel.textColor = self.originalColor;
    }
}

@end
