//
//  ZPADiscussionCell.h
//  Zeppa
//
//  Created by Faran on 09/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLZeppaclientapiEventComment.h"
#import "ZPAMyZeppaEvent.h"

@interface ZPADiscussionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewUserDisscussion;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_discussionUser;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionTime;


-(void)showEventCommentDetail:(GTLZeppaclientapiEventComment *)eventComment;
@end
