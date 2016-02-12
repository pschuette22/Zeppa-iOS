//
//  ZPASwapperVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//
#import "ZPASwapperVC.h"
#import "ZPANotificationSingleton.h"
#import "ZPAFeedVC.h"
#import "ZPAAgendaVC.h"
#import "ZPAActivityVC.h"
#import "MFDatePickerViewController.h"
#import "DFDatePickerViewController.h"
#import "ZPAEventDetailVC.h"
#import "DaySlots.h"
#import "ZPAUserDefault.h"
#import "MBProgressHUD.h"


#define SEGUE_ID_SHOW_FEEDS             @"showFeedSegue"
#define SEGUE_ID_SHOW_AGENDA            @"showAgendaSegue"
#define SEGUE_ID_SHOW_ACTIVITY          @"showActivitySegue"

#define TAG_MONTH_CALENDAR_VISIBLE      1101
#define TAG_DAY_CALENDAR_VISIBLE        1102

#define TAB_INDEX_CALENDAR              0
#define TAB_INDEX_FEEDS                 1
#define TAB_INDEX_AGENDA                2
#define TAB_INDEX_ACTIVITY              3

@interface ZPASwapperVC ()<MFDatePickerViewControllerDelegate>


@property (nonatomic, strong)UINavigationController         * feedNavC;
@property (nonatomic, strong)UINavigationController         * agendaNavC;
@property (nonatomic, strong)UINavigationController         * activityNavC;
@property (nonatomic, strong)UINavigationController         * monthCalendarNavC;
@property (nonatomic, strong)UINavigationController         * dayCalendarNavC;

@property (nonatomic, strong)ZPAFeedVC                      * feedVC;
@property (nonatomic, strong)ZPAAgendaVC                    * agendaVC;
@property (nonatomic, strong)ZPAActivityVC                  * activityVC;
@property (nonatomic, strong)MFDatePickerViewController     * monthCalendarVC;
@property (nonatomic, strong)DFDatePickerViewController     * dayCalendarVC;



@property (nonatomic, assign)int    selectedTabIndex;
@property (nonatomic, weak)UIButton *btnSelectedTab;

//this is used if one operation is perform then other not work
@property (assign, nonatomic) BOOL transitionInProgress;


@end

@implementation ZPASwapperVC{
    MBProgressHUD * progress;
}


//****************************************************
#pragma mark - Life Cycle
//****************************************************


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    ZPAAppDelegate *appdelegate = (ZPAAppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.swapperClassRef = self;
    
    self.selectedTabIndex = -1;
    self.transitionInProgress = NO;
    _btnCalendar.tag = TAG_MONTH_CALENDAR_VISIBLE;
    
    [self performSegueWithIdentifier:SEGUE_ID_SHOW_FEEDS sender:_btnFeed];
    
    
 //   [self btnToggleCalendarTapped:_btnCalendar];
    // Do any additional setup after loading the view.
}
  
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self updateNotificationNumber];
    // Attempt to set the
    
}

-(void)eventButtonTapped:(id)object{
    
   
    UINavigationController *nav  =[self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
    
    ZPAEventDetailVC *eventDetailVc = [[nav viewControllers] objectAtIndex:0];
    eventDetailVc.eventDetail = object;
    
    [self presentViewController:nav animated:YES completion:NULL];


}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//****************************************************
#pragma mark - Action Methods
//****************************************************



- (IBAction)btnToggleCalendarTapped:(UIButton *)sender {
    
    
     if (self.transitionInProgress) {
        return;
    }
    if (self.selectedTabIndex != TAB_INDEX_CALENDAR) {
        ///Coming from another tab so show Calendar Tab in Preserved State
        switch (sender.tag) {
            case TAG_MONTH_CALENDAR_VISIBLE:{
                progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [progress show:YES];
                if (!self.monthCalendarVC) {
                    self.monthCalendarNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"MFDatePickerNavC"];
                    self.monthCalendarVC = [[self.monthCalendarNavC viewControllers]firstObject];
                    self.monthCalendarVC.delegate=self;
                    self.monthCalendarVC.splitViewDelegate = _splitViewDelegate;
               }
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                       [progress show:YES];
                       
                       self.transitionInProgress = YES;
                       [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.monthCalendarNavC];
                       [progress hide:YES];

                   });
                
            }
                break;
                
            case TAG_DAY_CALENDAR_VISIBLE:
                if (!self.dayCalendarVC) {
                    self.dayCalendarNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"DFDatePickerNavC"];
                    self.dayCalendarVC = [[self.dayCalendarNavC viewControllers]firstObject];
                    self.dayCalendarVC.splitViewDelegate = _splitViewDelegate;
                    
                }
                self.transitionInProgress = YES;
                [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.dayCalendarNavC];
                [progress hide:YES];
                break;

                
            default:
                break;
        }
        
        [self toggleTabSelectionImage:sender];
        
        
    }
    else if(sender.tag == TAG_DAY_CALENDAR_VISIBLE){
    
        ///Tapping on Day Calendar will switch to Month calendar but not vice versa
        if (!self.monthCalendarVC) {
            self.monthCalendarNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"MFDatePickerNavC"];
            self.monthCalendarVC = [[self.monthCalendarNavC viewControllers]firstObject];
            self.monthCalendarVC.delegate=self;
            self.monthCalendarVC.splitViewDelegate = _splitViewDelegate;
        }
        self.transitionInProgress = YES;
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.monthCalendarNavC];
        
        sender.tag = TAG_MONTH_CALENDAR_VISIBLE;
        
        [progress hide:YES];
    }
    
    self.selectedTabIndex = TAB_INDEX_CALENDAR;
        
 }

//****************************************************
#pragma mark - Private Methods
//****************************************************

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Segue Id -> %@",segue.identifier);
    
    if (self.transitionInProgress) {
        return;
    }

    ///Change selection state of selected tab
    [self toggleTabSelectionImage:sender];
    
    
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    //if statements to get new VC instances instead.
    if (([segue.identifier isEqualToString:SEGUE_ID_SHOW_FEEDS])
        && (!self.feedVC)) {
        self.feedNavC = segue.destinationViewController;
        self.feedVC = [[self.feedNavC viewControllers]firstObject];
        self.feedVC.toCalendar = YES;
        self.feedVC.splitViewDelegate = _splitViewDelegate;
    }
    else if (([segue.identifier isEqualToString:SEGUE_ID_SHOW_AGENDA])
             &&(!self.agendaVC)) {
        self.agendaNavC = segue.destinationViewController;
        self.agendaVC = [[self.agendaNavC viewControllers]firstObject];
        self.agendaVC.splitViewDelegate = _splitViewDelegate;
    }
    else if (([segue.identifier isEqualToString:SEGUE_ID_SHOW_ACTIVITY])
             &&(!self.activityVC)) {
        self.activityNavC = segue.destinationViewController;
        self.activityVC = [[self.activityNavC viewControllers]firstObject];
        self.activityVC.splitViewDelegate = _splitViewDelegate;
    }
    
    ///Swap view controllers
    
    if ([segue.identifier isEqualToString:SEGUE_ID_SHOW_FEEDS]) {
        if (self.selectedTabIndex == TAB_INDEX_FEEDS) {
            return;
        }
        else{
            self.selectedTabIndex = TAB_INDEX_FEEDS;
        }
        
        if (self.childViewControllers.count > 0) {
            self.transitionInProgress = YES;
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.feedNavC];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            
            [self.feedVC willMoveToParentViewController:self];
            [self addChildViewController:self.feedNavC];
            UIView* destView = self.feedNavC.view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view_Container.frame.size.width, self.view_Container.frame.size.height);
            
          //  NSLog(@"width =%f , height %f",self.view.frame.size.width, self.view.frame.size.height);
            [self.view_Container addSubview:destView];
            [self.feedVC didMoveToParentViewController:self];
        }

        
    }
    else if ([segue.identifier isEqualToString:SEGUE_ID_SHOW_AGENDA]) {
        if (self.selectedTabIndex == TAB_INDEX_AGENDA) {
            return;
        }
        else{
            self.selectedTabIndex = TAB_INDEX_AGENDA;
        }
        self.transitionInProgress = YES;
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.agendaNavC];
 
    }
    else if ([segue.identifier isEqualToString:SEGUE_ID_SHOW_ACTIVITY]) {
        if (self.selectedTabIndex == TAB_INDEX_ACTIVITY) {
            return;
        }
        else{
            self.selectedTabIndex = TAB_INDEX_ACTIVITY;
        }
        self.transitionInProgress = YES;
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.activityNavC];
        
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
   
    
   // toViewController.view.frame = CGRectMake(0, 0, self.view_Container.frame.size.width, self.view_Container.frame.size.height);
    UIViewController *toBeVisibleVC = [[(UINavigationController *)toViewController viewControllers]firstObject];
    UIViewController *toBeRemovedVC = [[(UINavigationController *)fromViewController viewControllers]firstObject];
    toViewController.view.frame = self.view_Container.bounds;

    //    NSLog(@"width =%f , height %f",self.view_Container.frame.size.width, self.view_Container.frame.size.height);
    
    [toBeRemovedVC willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self.view_Container addSubview:toViewController.view];
    
    [fromViewController.view removeFromSuperview];
    [fromViewController removeFromParentViewController];
    [toBeVisibleVC didMoveToParentViewController:self];
    self.transitionInProgress = NO;
    
    

//    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
//        [fromViewController removeFromParentViewController];
//        [toViewController didMoveToParentViewController:self];
//        self.transitionInProgress = NO;
//    }];
    
}


-(void)toggleTabSelectionImage:(id)sender
{

    if ([sender isKindOfClass:[UIButton class]]) {
        _btnSelectedTab.selected = NO;
        
        _btnSelectedTab = sender;
        _btnSelectedTab.selected = YES;
        
    }
    
}

-(void) registerAsEventObserver {
    
    
}

-(void) unregisterAsEventObserver {
    
}

-(void) onEventsChanged {


}

/**
 * Update the badge indicating the number of notifications
 */
-(void) updateNotificationNumber {
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if(badgeNumber > 0){
        [self.activity_BedgeBtn setHidden:NO];
        if(badgeNumber>99){
            [self.activity_BedgeBtn setTitle:[NSString stringWithFormat:@"+99"] forState:UIControlStateNormal];
        } else {
            [self.activity_BedgeBtn setTitle:[NSString stringWithFormat:@"%d",badgeNumber] forState:UIControlStateNormal];
        }
    } else {
        [self.activity_BedgeBtn setHidden:YES];
    }
}


//****************************************************
#pragma mark - MFDatePickerViewControllerDelegate Method
//****************************************************


-(void)monthFlowDatePickerViewController:(MFDatePickerViewController *)controller didSelectDate:(NSDate *)date
{
   
    self.dayCalendarNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"DFDatePickerNavC"];
    self.dayCalendarVC = [[self.dayCalendarNavC viewControllers]firstObject];
    self.dayCalendarVC.splitViewDelegate = _splitViewDelegate;
    self.dayCalendarVC.date=date;
    self.transitionInProgress = YES;
    [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.dayCalendarNavC];
    _btnCalendar.tag=TAG_DAY_CALENDAR_VISIBLE;
    
}
@end
