//
//  ZPAViewController.m
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAFeedVC.h"
#import "ZPAEventDetailVC.h"

#import "ZPADateHelper.h"
#import "ZPAMyEventFeedCell.h"

#import "ZPAZeppaEventSingleton.h"
#import "MBProgressHUD.h"
#import "ZPAFetchEventsForMingler.h"
#import "ZPADefaulZeppatEventInfo.h"
#import "ZPAFetchInitialEvents.h"
#import "ZPAAgendaVC.h"
#import "ZPASwapperVC.h"
#import "ZPAUserDefault.h"




@interface ZPAFeedVC ()

@property (retain, nonatomic) UIRefreshControl *refreshControl;
@property(nonatomic,strong) NSMutableArray *arrFeeds;
@property(nonatomic,strong) ZPAMyZeppaUser *currentUser;
@property(nonatomic,strong) UINavigationController * eventDetailVc;
@property (nonatomic, strong) MBProgressHUD *progressHud;
@property (nonatomic, strong) ZPAFetchEventsForMingler *eventForMingler;
@property (retain,nonatomic) IBOutlet UILabel *emptyFeedLabel;

@end

@implementation ZPAFeedVC{
    ZPAMyZeppaEvent *myEvent;
    ZPASwapperVC *swaperVC;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _emptyFeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 450)];
    _emptyFeedLabel.text= @"Your feed is empty";
    _emptyFeedLabel.backgroundColor=[UIColor clearColor];
    _emptyFeedLabel.textAlignment = NSTextAlignmentCenter;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateEvents:) name:kZeppaEventsUpdateNotificationKey object:nil];
    
    //[self callZeppaApi];
    self.title = NSLocalizedString(@"Feed", nil);
    
    _progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHud.labelText = @"Finding Activities...";
    [_progressHud show:YES];
    
   // _arrFeeds = [ZPAZeppaEventSingleton sharedObject].zeppaEvents;
    _currentUser = [ZPAAppData sharedAppData].loggedInUser;
    
    ///Set background color of uiview
    [self.view setBackgroundColor:[ZPAStaticHelper backgroundTextureColor]];
    ZPAFetchInitialEvents * initialEvents = [[ZPAFetchInitialEvents alloc]init];
    if (initialEvents.isNewUser == YES) {
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
//    if ([ZPAUserDefault isValueExistsForKey:@"sync"] ) {
//        
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    _refreshControl = [[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self.tableView addSubview:_refreshControl];
    
    [_refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    _arrFeeds = [ZPAZeppaEventSingleton sharedObject].zeppaEvents;
    
    [ZPAStaticHelper sortArrayAlphabatically:_arrFeeds withKey:@"event.start"];
    
    //Hide empty feed label if events were added.
    if ([_arrFeeds count] > 0){
        [_emptyFeedLabel removeFromSuperview];
    }else{//or add it
        if(_progressHud.alpha==0){//Do this check so the label doesnt show up until the loading icon leaves
            [self.tableView addSubview:_emptyFeedLabel];
        }
    }
    
    [_tableView reloadData];
    
}
- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    return self.arrFeeds.count;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowIndex = indexPath.row;
    
    myEvent = [_arrFeeds objectAtIndex:rowIndex];
    NSLog(@"%@",myEvent.event.hostId);
    NSLog(@"%@",_currentUser.endPointUser.identifier);
    
        if( [myEvent.event.hostId isEqualToNumber: _currentUser.endPointUser.identifier]){
           
            ZPAMyEventFeedCell *myEventFeedCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAMyEventFeedCell"];
            
            [myEventFeedCell showDetailOnCell:[_arrFeeds objectAtIndex:rowIndex]];
            
            return myEventFeedCell;
            
        }else{
            _otherEventFeedCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAOtherEventFeedCell"];
            
            [_otherEventFeedCell showDetailOnCell:[_arrFeeds objectAtIndex:rowIndex]];
            
            return _otherEventFeedCell;

        }
    
    return  nil;
    
}


//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

///@todo need to implement below methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myEvent = [_arrFeeds objectAtIndex:indexPath.row];
    
    if( [myEvent.event.hostId isEqualToNumber: _currentUser.endPointUser.identifier]){
        
        return 95.0f;
        
    }else{
        
        return 142.0f;
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    _eventDetailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
   
    
    ZPAEventDetailVC *event = [[_eventDetailVc viewControllers] objectAtIndex:0];
    event.eventDetail = [_arrFeeds objectAtIndex:indexPath.row];
   
    [self presentViewController:_eventDetailVc animated:YES completion:NULL];
    
}
//****************************************************
#pragma mark - UIRefresh Control
//****************************************************
- (void)refreshTable:(UIRefreshControl *)refresh {
    
 
    [_refreshControl endRefreshing];
    _arrFeeds = [ZPAZeppaEventSingleton sharedObject].zeppaEvents;
    [self.tableView reloadData];
}


-(void)updateEvents:(NSNotification *)notify{
 
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    if ([_arrFeeds count] == 0){
        //add it to view controller
        [self.tableView addSubview:_emptyFeedLabel];
    }else{
        [_emptyFeedLabel removeFromSuperview];
        //_emptyFeedLabel.hidden = true;
    }
    [self.tableView reloadData];

}

//-(void)callZeppaApi{
//    _eventForMingler  =  [[ZPAFetchEventsForMingler alloc]init];
//    _eventForMingler.delegate = self;
//    //    [_eventForMingler executeZeppaApiWithMinglerId:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
//    [_eventForMingler executeZeppaApiWithMinglerId:[_currentUser.endPointUser.identifier longLongValue]];
//}
//-(void)getMutualMinglerEventsList{
//    
//    
//    
//    
//    NSLog(@"%zd",_arrFeeds.count);
//    
////    [_progressHud setUserInteractionEnabled:YES];
////    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//    [self.tableView reloadData];
//}

- (IBAction)joinBtnTapped:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
    myEvent = [_arrFeeds objectAtIndex:indexPath.row];
    
    myEvent.isAgenda = YES;
    
    if (![myEvent.relationship.isAttending boolValue] == true) {
        [sender setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
        [_otherEventFeedCell.watchBtn setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [_otherEventFeedCell.watchBtn setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
    }
    
    [[ZPADefaulZeppatEventInfo sharedObject]onJoinButtonClicked:myEvent.relationship];
    
    [_tableView reloadData];
   
}

- (IBAction)watchBtnTapped:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
    myEvent = [_arrFeeds objectAtIndex:indexPath.row];
    
    if (![myEvent.relationship.isWatching boolValue] == true) {
        [sender setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
    }
    [[ZPADefaulZeppatEventInfo sharedObject]onWatchButtonClicked:myEvent.relationship];
    
    [_tableView reloadData];

}



-(NSIndexPath *)getIndexPathOfRowWithBtnClick:(UIButton *)sender{
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%@",indexPath);
    
    return indexPath;
    
}


@end
