//
//  ZPASplitVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPASplitVC.h"
#import "ZPASplitViewProtocol.h"

#import "ZPASwapperVC.h"
#import "ZPAMyProfileVC.h"
#import "ZPAFriendListVC.h"
#import "ZPAExtendABidVC.h"
#import "ZPAFeedbackVC.h"
#import "ZPASettingsVC.h"


#define CORNER_RADIUS   0
#define SLIDE_TIMING    .35
#define PANEL_WIDTH     60

#define TAG_HIDE_LEFT_MENU  1001
#define TAG_SHOW_LEFT_MENU  1002


@interface ZPASplitVC ()<UIGestureRecognizerDelegate,ZPASplitViewProtocol>

@property (nonatomic, strong) ZPALeftMenuVC         * leftMenuVC;
@property (nonatomic, strong) ZPASwapperVC          * swapperVC;
@property (nonatomic, strong) ZPAMyProfileVC        * myProfileVC;
@property (nonatomic, strong) ZPAExtendABidVC       * extendABidVC;
@property (nonatomic, strong) ZPAFriendListVC       * minglersVC;
@property (nonatomic, strong) ZPAFeedbackVC         * feedbackVC;
@property (nonatomic, strong) ZPASettingsVC         * settingsVC;


@property (nonatomic, strong) UINavigationController  * myProfileNavC;
@property (nonatomic, strong) UINavigationController  * extendABidNavC;
@property (nonatomic, strong) UINavigationController  * minglersNavC;
@property (nonatomic, strong) UINavigationController  * feedbackNavC;
@property (nonatomic, strong) UINavigationController  * settingsNavC;


@property (nonatomic, assign) NSInteger selectedMenuIndex;


@property (nonatomic, assign) BOOL showingLeftPanel;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;

//@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (nonatomic, strong) UIButton *btnTapRecognizer;


//this is used if one operation is perform then other not work
@property (assign, nonatomic) BOOL transitionInProgress;

@property (nonatomic, weak)UIBarButtonItem *btnRevealLeftMenu;

@end

@implementation ZPASplitVC

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
    // Do any additional setup after loading the view.
    //[self setupView];
    self.selectedMenuIndex = -1; ///None Selected for first time
    
    [self didSelectMenuItemAtIndex:TABLE_ROW_INDEX_HOME]; ///Show Swapper VC with Feed Menu
    

}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"selected Index %ld",(long)_selectedMenuIndex);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _btnTapRecognizer.frame = self.view.bounds;
}

#pragma mark Setup View

/*
- (void)setupView
{
    // setup Swapper view
    if (!self.swapperVC) {
        
      //  UINavigationController *swapperNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPASwapperNavVC"];
     //   self.swapperVC = [[swapperNavController viewControllers]firstObject];
        self.swapperVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPASwapperVC"];
        self.swapperVC.splitViewDelegate = self;
//        self.btnRevealLeftMenu.tag = TAG_SHOW_LEFT_MENU;///Set Default Tag on their separate VCs
        [_swapperVC willMoveToParentViewController:self];
        [self addChildViewController:self.swapperVC];
        [self.view addSubview:self.swapperVC.view];
        
        [_swapperVC didMoveToParentViewController:self];
        
        // [self setupTapGestureToHideMenu];
    }
}
*/


- (void)showLeftMenuViewWithShadow:(BOOL)value withOffset:(CGSize)offset
{
    
    if (value)
        
    {
        [_leftMenuVC.view.layer setCornerRadius:CORNER_RADIUS];
        [_leftMenuVC.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_leftMenuVC.view.layer setShadowOpacity:0.2];
        [_leftMenuVC.view.layer setShadowOffset:offset];
        
    }
    else
    {
        [_leftMenuVC.view.layer setCornerRadius:0.0f];
        [_leftMenuVC.view.layer setShadowOffset:offset];
    }
}

- (void)resetMainView
{
    // remove left view and reset variables, if needed
    if (_leftMenuVC != nil)
    {
        [self.leftMenuVC.view removeFromSuperview];
        [self.leftMenuVC removeFromParentViewController];
        self.leftMenuVC = nil;
        
        self.btnRevealLeftMenu.tag = TAG_SHOW_LEFT_MENU;
        /*
        [[_tapRecognizer view]removeGestureRecognizer:_tapRecognizer];
        _tapRecognizer = nil;
       */
        [_btnTapRecognizer removeFromSuperview];
        _btnTapRecognizer = nil;
        self.showingLeftPanel = NO;
        
    }
    
    // remove view shadows
    //    [self showCenterViewWithShadow:NO withOffset:0];
}

- (UIView *)getLeftView
{
    NSLog(@"%ld",(long)_selectedMenuIndex);
    // init view if it doesn't already exist
    if (_leftMenuVC == nil)
    {
        
        // this is where you define the view for the left panel
        self.leftMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPALeftMenuVC"];
        //       self.leftMenuVC.delegate = _centerViewController;
        self.leftMenuVC.delegate = self;
        
        self.leftMenuVC.currentSelectedIndex = _selectedMenuIndex ;
        
        [_leftMenuVC willMoveToParentViewController:self];
        [self addChildViewController:_leftMenuVC];
        [self.view addSubview:self.leftMenuVC.view];
        
        [_leftMenuVC didMoveToParentViewController:self];
        
        
        _leftMenuVC.view.frame = CGRectMake(-1 * (self.view.frame.size.width - PANEL_WIDTH), 0,self.view.frame.size.width - PANEL_WIDTH, self.view.frame.size.height);
        
        [self setupGesturesOnLeftMenu];
    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showLeftMenuViewWithShadow:YES withOffset:CGSizeMake(5, 20)];
    
    UIView *view = self.leftMenuVC.view;
    return view;
}



#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupTapGestureToHideMenu
{
    /*
    if (_tapRecognizer) {
        [[_tapRecognizer view]removeGestureRecognizer:_tapRecognizer];
    }
    
    _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideLeftMenuPanel:)];
    _tapRecognizer.delegate = self;
    
    NSInteger indexOfViewBehindMenu = self.view.subviews.count - 2;
    if (indexOfViewBehindMenu >= 0) {
        [[[self.view subviews]objectAtIndex:indexOfViewBehindMenu]addGestureRecognizer:_tapRecognizer];
    }

    //    [_swapperVC.view addGestureRecognizer:_tapRecognizer];
    */
    
    if (_btnTapRecognizer) {
        [_btnTapRecognizer removeFromSuperview];
        _btnTapRecognizer = nil;
    }
    
    _btnTapRecognizer = [[UIButton alloc]init];
    [_btnTapRecognizer addTarget:self action:@selector(hideLeftMenuPanel:) forControlEvents:UIControlEventTouchUpInside];
   
    NSInteger indexOfViewBehindMenu = self.view.subviews.count - 2;
    if (indexOfViewBehindMenu >= 0) {
        UIView *viewBehindMenu = [[self.view subviews]objectAtIndex:indexOfViewBehindMenu];
        [viewBehindMenu addSubview:_btnTapRecognizer];
        _btnTapRecognizer.frame = viewBehindMenu.bounds;
    }

}

- (void)setupGesturesOnLeftMenu
{
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(movePanel:)];
    panRecognizer.delegate = self;
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [_leftMenuVC.view addGestureRecognizer:panRecognizer];
    
}

-(void)hideLeftMenuPanel:(id)sender
{
    /*
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
     */
     if (_showingLeftPanel) {
        
        [self movePanelToOriginalPosition:nil];
        
    }
    
}


//****************************************************
#pragma mark - Private Methods
//****************************************************

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    
    UIViewController *toBeRemovedVC = fromViewController;
    UIViewController *toBeVisibleVC = toViewController;
    if ([fromViewController isKindOfClass:[UINavigationController class]]) {
        toBeRemovedVC = [[(UINavigationController *)fromViewController viewControllers]firstObject];
        
    }
    
    if ([toViewController isKindOfClass:[UINavigationController class]]) {
        toBeVisibleVC = [[(UINavigationController *)toViewController viewControllers]firstObject];
        
    }
    
    toViewController.view.frame = self.view.bounds;
    
    //    NSLog(@"width =%f , height %f",self.view_Container.frame.size.width, self.view_Container.frame.size.height);
    
    [toBeRemovedVC willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    [self.view addSubview:toViewController.view];
   
    
    
    
    [fromViewController.view removeFromSuperview];
    [fromViewController removeFromParentViewController];
    [toBeVisibleVC didMoveToParentViewController:self];
    
    
    [self.view sendSubviewToBack:toViewController.view];
    
    UIViewController *firstChildVC = [self.childViewControllers firstObject];
    
    if ([firstChildVC isMemberOfClass:[ZPALeftMenuVC class]]) {
        ///Hack to move the leftMenuVC from 0 index to lastobject
        [self addChildViewController:firstChildVC];

    }
    
    
    
//    self.transitionInProgress = NO;
    
    //    [self transitionFromViewController:fromViewController toViewController:toViewController duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
    //        [fromViewController removeFromParentViewController];
    //        [toViewController didMoveToParentViewController:self];
    //        self.transitionInProgress = NO;
    //    }];
    
}



//****************************************************
#pragma mark - UIGestureRecognizerDelegate Method
//****************************************************
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}


#pragma mark -
#pragma mark Delegate Actions
// to show left panel
- (void)movePanelToRight:(id)sender
{
    self.transitionInProgress = YES;
    ///Reset Reveal button property to hold the reference of the reveal button of the currently displayed VC
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        self.btnRevealLeftMenu = sender;
    }
    
    UIView *childView = [self getLeftView];
    //  [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         //                         _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                         childView.frame = CGRectMake(0, 0, self.view.frame.size.width - PANEL_WIDTH, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             self.btnRevealLeftMenu.tag = TAG_HIDE_LEFT_MENU;
                             [self setupTapGestureToHideMenu];
                             self.transitionInProgress = NO;
                         }
                     }];
    
}

- (void)movePanelToOriginalPosition:(id)sender
{
    self.transitionInProgress = YES;
    ///Reset Reveal button property to hold the reference of the reveal button of the currently displayed VC
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        self.btnRevealLeftMenu = sender;
    }

    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _leftMenuVC.view.frame = CGRectMake(-(self.view.frame.size.width), 0,self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self resetMainView];
                             self.transitionInProgress = NO;
                         }
                     }];
    
}


-(void)movePanel:(id)sender
{
    
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        //        UIView *childView = nil;
        
        //        if(velocity.x > 0) {
        //            //            if (!_showingRightPanel) {
        //            childView = [self getLeftView];
        //            //            }
        //        } else {
        //            if (!_showingLeftPanel) {
        //                childView = [self getRightView];
        //            }
        //
        //        }
        //        // Make sure the view you're working with is front and center.
        //        [self.view sendSubviewToBack:childView];
        //        [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition:nil];
        } else {
            if (_showingLeftPanel) {
                [self movePanelToRight:nil];
            }
            //            else if (_showingRightPanel) {
            //    [self movePanelLeft];
            //            }
        }
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        // Are you more than halfway? If so, show the panel when done dragging by setting this value to YES (1).
        //  _showPanel = abs([sender view].center.x - _centerViewController.view.frame.size.width/2) > _centerViewController.view.frame.size.width/2;
        _showPanel = fabs([sender view].frame.origin.x + [sender view].frame.size.width) > _swapperVC.view.frame.size.width/2;
        
        // Allow dragging only in x-coordinates by only updating the x-coordinate with translation position.
        CGRect panelFrame = [sender view].frame;
        float translatedX = panelFrame.origin.x + translatedPoint.x;
        panelFrame.origin.x = translatedX < 0 ? translatedX : 0;
        [sender view].frame = panelFrame;
        //        [sender view].center = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0,0) inView:self.view];
        
        // If you needed to check for a change in direction, you could use this code to do so.
        if(velocity.x*_preVelocity.x + velocity.y*_preVelocity.y > 0) {
            // NSLog(@"same direction");
        } else {
            // NSLog(@"opposite direction");
        }
        
        _preVelocity = velocity;
    }
    
}

//****************************************************
#pragma mark - ZPALeftMenuSelctionDelegate Method
//****************************************************

-(void)didSelectMenuItemAtIndex:(NSInteger)menuIndex
{
    NSLog(@"selected Index %ld",(long)_selectedMenuIndex);
    if (self.transitionInProgress) {
        return;
    }
    
    switch (menuIndex) {
        case TABLE_ROW_INDEX_PROFILE:
        {
            if (_selectedMenuIndex == TABLE_ROW_INDEX_PROFILE) {
               
                ///Simply close the menu panel
                [self movePanelToOriginalPosition:nil];
            
            }
            else{
               ///Replace Profile view with the currently displayed View behind Menu
                if (!self.myProfileVC) {
                    self.myProfileNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAMyProfileNavC"];
                    self.myProfileVC = [[self.myProfileNavC viewControllers]firstObject];
                    self.myProfileVC.splitViewDelegate = self;
                }
                
                [self swapFromViewController:[self.childViewControllers firstObject] toViewController:self.myProfileNavC];
                [self movePanelToOriginalPosition:nil];

            }
        
        }
            
            break;
        case TABLE_ROW_INDEX_HOME:
        {
            if (_selectedMenuIndex == TABLE_ROW_INDEX_HOME) {
                
                ///Simply close the menu panel
                [self movePanelToOriginalPosition:nil];
                
            }
            else{
                ///Replace Minglers view with the currently displayed View behind Menu
                if (!self.swapperVC) {
                    self.swapperVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPASwapperVC"];
                    self.swapperVC.splitViewDelegate = self;
               }
                
                if (self.childViewControllers.count > 0) {
                   
                    [self swapFromViewController:[self.childViewControllers firstObject] toViewController:self.swapperVC];
                    [self movePanelToOriginalPosition:nil];

                }
                else{
                    // If this is the very first time we're loading this we need to do
                    // an initial load and not a swap.

                    [_swapperVC willMoveToParentViewController:self];
                    [self addChildViewController:self.swapperVC];
                    [self.view addSubview:self.swapperVC.view];
                    
                    [_swapperVC didMoveToParentViewController:self];

                    
                }
                
                
            }
            
        }

            
            break;
        case TABLE_ROW_INDEX_MINGLERS:
        {
            if (_selectedMenuIndex == TABLE_ROW_INDEX_MINGLERS) {
                
                ///Simply close the menu panel
                [self movePanelToOriginalPosition:nil];
                
            }
            else{
                ///Replace Minglers view with the currently displayed View behind Menu
                if (!self.minglersVC) {
                    self.minglersNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAFriendListNavC"];
                    self.minglersVC = [[self.minglersNavC viewControllers]firstObject];
                    self.minglersVC.splitViewDelegate = self;
                }
                
                [self swapFromViewController:[self.childViewControllers firstObject] toViewController:self.minglersNavC];
                [self movePanelToOriginalPosition:nil];

            }
            
        }
            
            break;
//        case TABLE_ROW_INDEX_EXTEND_BID:
//        {
//            if (_selectedMenuIndex == TABLE_ROW_INDEX_EXTEND_BID) {
//                
//                ///Simply close the menu panel
//                [self movePanelToOriginalPosition:nil];
//                
//            }
//            else{
//                ///Replace Minglers view with the currently displayed View behind Menu
//                if (!self.extendABidVC) {
//                    self.extendABidNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAExtendABidNavC"];
//                    self.extendABidVC = [[self.extendABidNavC viewControllers]firstObject];
//                    self.extendABidVC.splitViewDelegate = self;
//                }
//                
//                [self swapFromViewController:[self.childViewControllers firstObject] toViewController:self.extendABidNavC];
//                [self movePanelToOriginalPosition:nil];
//
//            }
//            
//        }

            
            break;
        case TABLE_ROW_INDEX_FEEDBACK:
        {
            if (_selectedMenuIndex == TABLE_ROW_INDEX_FEEDBACK) {
                
                ///Simply close the menu panel
                [self movePanelToOriginalPosition:nil];
                
            }
            else{
                ///Replace Minglers view with the currently displayed View behind Menu
                if (!self.feedbackVC) {
                    self.feedbackNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAFeedbackNavC"];
                    self.feedbackVC = [[self.feedbackNavC viewControllers]firstObject];
                    self.feedbackVC.splitViewDelegate = self;
                }
                
                [self swapFromViewController:[self.childViewControllers firstObject] toViewController:self.feedbackNavC];
                [self movePanelToOriginalPosition:nil];

            }
            
        }

            
            break;
        case TABLE_ROW_INDEX_SETTINGS:
        {
            if (_selectedMenuIndex == TABLE_ROW_INDEX_SETTINGS) {
                
                ///Simply close the menu panel
                [self movePanelToOriginalPosition:nil];
                
            }
            else{
                ///Replace Minglers view with the currently displayed View behind Menu
                if (!self.settingsVC) {
                    self.settingsNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPASettingsNavC"];
                    self.settingsVC = [[self.settingsNavC viewControllers]firstObject];
                    self.settingsVC.splitViewDelegate = self;
                }
                
                [self swapFromViewController:[self.childViewControllers firstObject] toViewController:self.settingsNavC];
                [self movePanelToOriginalPosition:nil];

            }
            
        }

            
            break;
            
        default:
            break;
    }
    
    _selectedMenuIndex = menuIndex;
    
}



@end
