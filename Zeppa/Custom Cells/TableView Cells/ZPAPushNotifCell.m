//
//  ZPAPushNotifCell.m
//  Zeppa
//
//  Created by Dheeraj on 07/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAPushNotifCell.h"

@implementation ZPAPushNotifCell
- (IBAction)vibrateNotifBtnTapped:(UIButton *)sender {
    
    if (_vibrateSwitch.isOn) {
        [_vibrateSwitch setOn:NO animated:YES];
        
    }
    else{
        [_vibrateSwitch setOn:YES animated:YES];
        
    }
}

- (IBAction)ringNotifBtnTapped:(UIButton *)sender {
    if (_RingSwitch.isOn) {
        [_RingSwitch setOn:NO animated:YES];
        
    }
    else{
        [_RingSwitch setOn:YES animated:YES];
       
    }
}

- (IBAction)mingleRequestBtnTapped:(UIButton *)sender {
    if (_mingleRequestSwitch.isOn) {
        [_mingleRequestSwitch setOn:NO animated:YES];
        
    }
    else{
        [_mingleRequestSwitch setOn:YES animated:YES];
       
    }
}

- (IBAction)startedMinglingBtnTapped:(UIButton *)sender {
    
    if (_startedMinglingSwitch.isOn) {
        [_startedMinglingSwitch setOn:NO animated:YES];
        
    }
    else{
        [_startedMinglingSwitch setOn:YES animated:YES];
    }
}

- (IBAction)eventRecommentBtnTapped:(UIButton *)sender {
    
    if (_eventRecommendSwitch.isOn) {
        [_eventRecommendSwitch setOn:NO animated:YES];
        
    }
    else{
        [_eventRecommendSwitch setOn:YES animated:YES];
        
    }
}

- (IBAction)eventInvites:(UIButton *)sender {
    
    if (_eventInviteSwitch.isOn) {
        [_eventInviteSwitch setOn:NO animated:YES];
        
    }
    else{
        [_eventInviteSwitch setOn:YES animated:YES];
        
    }
}

- (IBAction)commentBtnTapped:(UIButton *)sender {
    
    if (_commentSwitch.isOn) {
        [_commentSwitch setOn:NO animated:YES];
    }
    else{
        [_commentSwitch setOn:YES animated:YES];
    }
}

- (IBAction)eventCancelBtnTapped:(UIButton *)sender {
  
    if (_eventCancelSwitch.isOn) {
        [_eventCancelSwitch setOn:NO animated:YES];
       
    }
    else{
        [_eventCancelSwitch setOn:YES animated:YES];
        
    }
}

- (IBAction)peopleJoinBtnTapped:(UIButton *)sender {
    
    if (_peopleJoinSwitch.isOn) {
        [_peopleJoinSwitch setOn:NO animated:YES];
        
    }
    else{
        [_peopleJoinSwitch setOn:YES animated:YES];
    }
}

- (IBAction)peopleLeaveBtnTapped:(UIButton *)sender {
    
    if (_peopleLeaveSwitch.isOn) {
        [_peopleLeaveSwitch setOn:NO animated:YES];
       
    }
    else{
        [_peopleLeaveSwitch setOn:YES animated:YES];
       
    }
}
@end
