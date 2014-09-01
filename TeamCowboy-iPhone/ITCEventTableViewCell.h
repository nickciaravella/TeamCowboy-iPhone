//
//  ITCEventTableViewCell.h
//  Copyright (c) 2014 Nick Ciaravella. All rights reserved.
//

@interface ITCEventTableViewCell : UITableViewCell

// Date/time
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

// Teams
@property (nonatomic, weak) IBOutlet UILabel *teamNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *homeAwayLabel;
@property (nonatomic, weak) IBOutlet UILabel *opponentNameLabel;

// Location
@property (nonatomic, weak) IBOutlet UIButton *locationButton;

// RSVP status
@property (nonatomic, weak) IBOutlet UILabel *yesRSVPLabel;
@property (nonatomic, weak) IBOutlet UILabel *noRSVPLabel;
@property (nonatomic, weak) IBOutlet UILabel *maybeRSVPLabel;
@property (nonatomic, weak) IBOutlet UIView  *currentUserRSVPStatusView;

@end
