//
//  ZPAUserCalendarNameCell.h
//  Zeppa
//
//  Created by Milan Agarwal on 07/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPAUserCalendarNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblCalendarName;
@property (weak, nonatomic) IBOutlet UISwitch *switch_syncCalendar;

@end
