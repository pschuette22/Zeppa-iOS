//
//  BRDatePicker.m
//  Bravo
//
//  Created by Dheeraj on 24/12/14.
//  Copyright (c) 2014 Agicent. All rights reserved.
//

#import "ZPADateAndTimePicker.h"

#define TRANCEPARENT_VIEW_TAG 11

@implementation ZPADateAndTimePicker

- (IBAction)pickDate:(UIDatePicker *)sender {
    
    _selectedDate = sender.date;
    
}
- (IBAction)cancelBtnPressed:(UIButton *)sender{
    
    [self removeFromSuperview];
    
}
- (IBAction)doneBtnPressed:(id)sender {
    
    _selectedDate = _selectedDate ? _selectedDate:[NSDate date];
    
//    _selectedDate = [_selectedDate dateByAddingTimeInterval:5*60];
    
    
    [_delegate doneBtnTappedOnDateAndTimePicker:_selectedDate];
    [self removeFromSuperview];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if ([touch view].tag ==  TRANCEPARENT_VIEW_TAG) {
        [self removeFromSuperview];
    }
}
@end
