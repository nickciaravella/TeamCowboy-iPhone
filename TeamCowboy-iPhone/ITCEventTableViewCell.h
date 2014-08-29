//
//  ITCEventTableViewCell.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface ITCEventTableViewCell : UITableViewCell

// Outlets
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *teamNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *opponentNameLabel;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;
@property (nonatomic, weak) IBOutlet UILabel *homeAwayLabel;

@end
