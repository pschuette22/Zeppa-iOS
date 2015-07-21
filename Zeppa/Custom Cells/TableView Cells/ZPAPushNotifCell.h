//
//  ZPAPushNotifCell.h
//  Zeppa
//
//  Created by Dheeraj on 07/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPAPushNotifCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *pushNotifSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibrateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *RingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *mingleRequestSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *startedMinglingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *eventRecommendSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *eventInviteSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *commentSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *eventCancelSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *peopleJoinSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *peopleLeaveSwitch;

- (IBAction)vibrateNotifBtnTapped:(UIButton *)sender;
- (IBAction)ringNotifBtnTapped:(UIButton *)sender;

- (IBAction)mingleRequestBtnTapped:(UIButton *)sender;
- (IBAction)startedMinglingBtnTapped:(UIButton *)sender;
- (IBAction)eventRecommentBtnTapped:(UIButton *)sender;
- (IBAction)eventInvites:(UIButton *)sender;
- (IBAction)commentBtnTapped:(UIButton *)sender;
- (IBAction)eventCancelBtnTapped:(UIButton *)sender;
- (IBAction)peopleJoinBtnTapped:(UIButton *)sender;

- (IBAction)peopleLeaveBtnTapped:(UIButton *)sender;

@end
