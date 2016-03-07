//
//  ZPAHomeTabController.h
//  Zeppa
//
//  Created by Peter Schuette on 2/23/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPASplitViewProtocol.h"

#define TAG_HIDE_LEFT_MENU              1001
#define TAG_SHOW_LEFT_MENU              1002

@interface ZPAHomeTabController : UITabBarController

@property (nonatomic,assign) id<ZPASplitViewProtocol>splitViewDelegate;


- (IBAction)btnRevealLeftMenuPanelTapped:(UIBarButtonItem *)sender;

-(void) setNotificationsBadge: (NSInteger) badgeCount;

@end
