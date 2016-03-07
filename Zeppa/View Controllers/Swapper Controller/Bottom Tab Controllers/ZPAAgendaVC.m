//
//  ZPAAgendaVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 27/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAAgendaVC.h"
#import "ZPADateHelper.h"
#import "ZPAMyEventAgendaCell.h"
#import "ZPAEventInfoBase.h"
#import "ZPAOtherEventAgendaCell.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPAEventDetailVC.h"
#import "ZPADefaultZeppaEventInfo.h"


@interface ZPAAgendaVC ()

@property (retain, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *arrAttendingEvents;
@property (nonatomic, strong)UINavigationController *eventDetailNavigation;
@property (retain,nonatomic) IBOutlet UILabel *emptyAgendaLabel;

@end

@implementation ZPAAgendaVC

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

//    _eventDetailNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
    // Do any additional setup after loading the view.
//    self.title = NSLocalizedString(@"Watching", nil);
    
    ///Set background color of uiview
    [self.view setBackgroundColor:[ZPAStaticHelper backgroundTextureColor]];
    
    _emptyAgendaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 450)];
    _emptyAgendaLabel.text= @"So much Room for Activities!\nJoin, Watch, or Start one and it'll show up here";
    _emptyAgendaLabel.backgroundColor=[UIColor clearColor];
    _emptyAgendaLabel.numberOfLines=2;
    _emptyAgendaLabel.textAlignment = NSTextAlignmentCenter;
    // Hold the currently logged in user
    _currentUser = [ZPAAppData sharedAppData].loggedInUser;
    
    _refreshControl = [[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Fetching Activities..."];
    [self.tableView addSubview:_refreshControl];
    
    [_refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
    
    [self updateEvents];
    // TODO: register for notifications when user joins/ leaves events
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didReceiveNotification:) name:kZeppaEventsUpdateNotificationKey object:nil];
}


- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// If the view is deallocated, stop observing
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// Get ready to show event details
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Get ready to show event details
    // check to make sure this is headed to an Event Detail View Controller
    if([segue.destinationViewController.restorationIdentifier isEqualToString:@"ZPAEventDetailVC"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ZPAMyZeppaEvent *zeppaEvent = _arrAttendingEvents[indexPath.row];
        ZPAEventDetailVC *eventDetailVC = (ZPAEventDetailVC*) segue.destinationViewController;
        eventDetailVC.eventDetail = zeppaEvent;
    }
    
}

//****************************************************
#pragma mark - UITableViewDataSource Methods
//****************************************************

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_arrAttendingEvents){
        return _arrAttendingEvents.count;
    } else {
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowIndex = indexPath.row;
    
    ZPAEventInfoBase* eventInfo = [_arrAttendingEvents objectAtIndex:rowIndex];
//    ZPAUserInfoBase* userInfo = [eventInfo getHostInfo];
    
    
    if([eventInfo isMyEvent]){
        
        ZPAMyEventAgendaCell *myEventAgendaCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAMyEventAgendaCell"];
        
        [myEventAgendaCell showEventDetailsOnAgendaCell:[_arrAttendingEvents objectAtIndex:rowIndex]];
        
        return myEventAgendaCell;
        
    }else{
        ZPAOtherEventAgendaCell *otherEventAgendaCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAOtherEventAgendaCell"];

        [otherEventAgendaCell showEventDetailsOnAgendaCell:[_arrAttendingEvents objectAtIndex:rowIndex]];
        
         return otherEventAgendaCell;
        
    }
    
    
    return  nil;
    
//    ZPAOtherEventAgendaCell *otherEventAgendaCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAOtherEventAgendaCell"];
//           return otherEventAgendaCell;
//    
//    ZPAMyEventAgendaCell *myEventAgendaCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAMyEventAgendaCell"];
//    
//    [myEventAgendaCell showEventDetailsOnAgendaCell:[_arrAttendingEvents objectAtIndex:rowIndex]];
//    
//    return myEventAgendaCell;
    
}


//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

///@todo need to implement below methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZPAEventInfoBase* eventInfo = [_arrAttendingEvents objectAtIndex:indexPath.row];
    
    if( [eventInfo isMyEvent]){
        return 95.0f;
    }else{
        return 142.0f;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Set the selected event when touched
//    ZPAEventInfoBase* eventInfo = [_arrAttendingEvents objectAtIndex:indexPath.row];
    // Handle anything else from here?
    
}

///**********************************************
#pragma mark - Action Methods
///**********************************************

-(void) didReceiveNotification:(NSNotification *)notif {

    if([notif.name isEqualToString:kZeppaEventsUpdateNotificationKey]) {
        [self updateEvents];
    }
    
}

/**
 * Notify the controller that interesting events changed
 */
-(void)updateEvents {
    
    _arrAttendingEvents = [[ZPAZeppaEventSingleton sharedObject] getInterestingEventMediators];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([_arrAttendingEvents count] == 0){
        //add it to view controller
        [self.tableView addSubview:_emptyAgendaLabel];
    }else{
        [_emptyAgendaLabel removeFromSuperview];
        //_emptyFeedLabel.hidden = true;
    }
    [self.tableView reloadData];
    
}

-(void)joinBtnTapped:(UIButton *)sender{
    
    
//    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
//    myEvent = [_arrAttendingEvents objectAtIndex:indexPath.row];
//    
//    myEvent.isAgenda = YES;
//    
//    if (![myEvent.relationship.isAttending boolValue] == true) {
//        [sender setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
//        [_otherEventAgendaCell.btnWatch setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
//    }
//    else{
//        [_otherEventAgendaCell.btnWatch setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
//        [sender setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
//    }
//    
//    [[ZPADefaulZeppatEventInfo sharedObject]onJoinButtonClicked:myEvent.relationship];
//    
//    [_tableView reloadData];

    
}

-(void)watchBtnTapped:(UIButton *)sender{
    
    
//    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
//    myEvent = [_arrAttendingEvents objectAtIndex:indexPath.row];
//    
//    if (![myEvent.relationship.isWatching boolValue] == true) {
//        [sender setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
//    }
//    else{
//        [sender setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
//    }
//    [[ZPADefaulZeppatEventInfo sharedObject]onWatchButtonClicked:myEvent.relationship];
//    
//    [_tableView reloadData];
//    

}

// to get index path of Button.
-(NSIndexPath *)getIndexPathOfRowWithBtnClick:(UIButton *)sender{
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%@",indexPath);
    
    return indexPath;
    
}


//****************************************************
#pragma mark - UIRefresh Control
//****************************************************
- (void)refreshTable:(UIRefreshControl *)refresh {
    
    
    [_refreshControl endRefreshing];
    [self updateEvents];
}


@end
