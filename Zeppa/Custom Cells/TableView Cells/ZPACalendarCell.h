//
//  ZPACalendarCell.h
//  Zeppa
//
//  Created by Faran on 02/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPACalendarCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *view_CalendarColor;
@property (weak, nonatomic) IBOutlet UILabel *lblCalendarSummary;

@property (weak, nonatomic) IBOutlet UISwitch *synEvents;




@end
