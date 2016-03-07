//
//  ZPAHomeTabController.m
//  Zeppa
//
//  Created by Peter Schuette on 2/23/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAHomeTabController.h"
#import "ZPANotificationSingleton.h"
#import "ZPAFeedVC.h"
#import "ZPAAgendaVC.h"
#import "ZPAActivityVC.h"
#import "ZPAEventDetailVC.h"
#import "ZPAUserDefault.h"
#import "MBProgressHUD.h"



@implementation ZPAHomeTabController


- (void)viewDidLoad
{
    [super viewDidLoad];
    ZPAAppDelegate *appdelegate = (ZPAAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.swapperClassRef = self;
    
    self.selectedIndex = 1;

    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setTranslucent:NO];
    [self.tabBar setAlpha:1];
    [self setNotificationsBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];

    //   [self btnToggleCalendarTapped:_btnCalendar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
}


/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Navigating to a new activity
    if([segue.identifier isEqualToString:@"NavToNewActivity"]){
        // Navigating to NewActivityViewController
    }
}
 */


- (IBAction)btnRevealLeftMenuPanelTapped:(UIBarButtonItem *)sender {
    
    [self.view endEditing:YES];
    ///If first Time then set initial tag
    if ((sender.tag != TAG_SHOW_LEFT_MENU)
        && (sender.tag != TAG_HIDE_LEFT_MENU)) {
        sender.tag = TAG_SHOW_LEFT_MENU;
    }
    
    switch (sender.tag) {
        case TAG_HIDE_LEFT_MENU:
            if ([_splitViewDelegate respondsToSelector:@selector(movePanelToOriginalPosition:)]) {
                [_splitViewDelegate movePanelToOriginalPosition:sender];
            }
            break;
            
        case TAG_SHOW_LEFT_MENU:
            [_splitViewDelegate movePanelToRight:sender];
            
        default:
            break;
    }
    
}


-(void) setNotificationsBadge: (NSInteger) badgeCount{
    UITabBarItem *tabItem = (UITabBarItem *) [self.tabBar.items objectAtIndex:3];
    
    if(badgeCount>0){
        // Indicate to the user how many unseen notifications they have
        tabItem.badgeValue=[NSString stringWithFormat:@"%ld",badgeCount];
    } else {
        // Otherwise, don't show a badge
        tabItem.badgeValue=nil;
    }

}

@end
