//
//  BRDatePicker.h
//  Bravo
//
//  Created by Dheeraj on 24/12/14.
//  Copyright (c) 2014 Agicent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateAndTimePickerDelegate <NSObject>

-(void)doneBtnTappedOnDateAndTimePicker:(NSDate *)date;

@end

@interface ZPADateAndTimePicker : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) id<DateAndTimePickerDelegate>delegate;
@property (strong, nonatomic) NSDate *selectedDate;
- (IBAction)cancelBtnPressed:(UIButton *)sender;
- (IBAction)doneBtnPressed:(id)sender;

@end
