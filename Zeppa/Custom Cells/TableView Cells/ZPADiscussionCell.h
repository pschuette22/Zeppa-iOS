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

@interface ZPADiscussionCell : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView_discussionUser;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightConstraint;

-(void) defineCellWidth: (CGFloat) width;
-(void)showEventCommentDetail:(GTLZeppaclientapiEventComment *)eventComment;
@end
