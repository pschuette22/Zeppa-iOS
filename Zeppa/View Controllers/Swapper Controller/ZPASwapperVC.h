//
//  ZPASwapperVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPASplitViewProtocol.h"
//@protocol ZPASwapperDelegate <NSObject>
//
//@optional
//
//-(void)movePanelToOriginalPosition;
//
//@required
//-(void)movePanelToRight;
//
//@end

@interface ZPASwapperVC : UIViewController
@property (nonatomic,assign) id<ZPASplitViewProtocol>splitViewDelegate;
@property (weak, nonatomic) IBOutlet UIView *view_Container;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnRevealLeftMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnCalendar;
@property (weak, nonatomic) IBOutlet UIButton *btnFeed;
@property (weak, nonatomic) IBOutlet UIButton *activity_BedgeBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnAgenda;
@property (weak, nonatomic) IBOutlet UIButton *btnActivity;

-(void) onEventsChanged;
-(void) updateNotificationNumber;
@end
