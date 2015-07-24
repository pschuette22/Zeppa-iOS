//
//  ZPAActivityVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 27/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAActivityVC.h"
#import "ZPAActivityNotificationCell.h"
#import "ZPAFetchInitialNotifications.h"
#import "ZPANotificationSingleton.h"
#import "ZPAEventDetailVC.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPARequsetMinglersVC.h"
#import "ZPAUserProfileVC.h"
#import "ZPAZeppaEventTagSingleton.h"

@interface ZPAActivityVC ()
@property (retain, nonatomic) UIRefreshControl *refreshControl;
@property(nonatomic,strong) UINavigationController * eventDetailVc;
@property(nonatomic,retain) UILabel *emptyActivityLabel;
@end

@implementation ZPAActivityVC{
    ZPAFetchInitialNotifications *initialNotification;
    NSMutableArray *notificationEventArr;
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
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Activity", nil);
    
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    
    _emptyActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 450)];
    _emptyActivityLabel.text= @"You have no notifications";
    _emptyActivityLabel.backgroundColor=[UIColor clearColor];
    _emptyActivityLabel.textAlignment = NSTextAlignmentCenter;
    
    _refreshControl = [[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self.tableView addSubview:_refreshControl];
    
    [_refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    
    _arrNotifications = [[[ZPANotificationSingleton sharedObject]getNotification]mutableCopy];
    notificationEventArr = [NSMutableArray array];
    if ([_arrNotifications count]==0){
        [self.tableView addSubview:_emptyActivityLabel];
    }else{
        [_emptyActivityLabel removeFromSuperview];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - UITableViewDataSource
//****************************************************

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   return self.arrNotifications.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellId = @"ZPAActivityNotificationCell";
    
    ZPAActivityNotificationCell *notificationCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    UIView *bgView = [[UIView alloc]initWithFrame:(CGRect){0,0,tableView.bounds.size.width,notificationCell.bounds.size.height}];
    bgView.backgroundColor = [UIColor clearColor];
    //notificationCell.selectedBackgroundView = bgView;
    
    [notificationCell showDetailOncell:[_arrNotifications objectAtIndex:indexPath.row]];

    
    return notificationCell;
    
    
}

//****************************************************
#pragma mark - UITableViewDelegate
//****************************************************


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 68.0f;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self onClickActivity:indexPath.row];
    
//    _eventDetailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
//    
//    
//    ZPAEventDetailVC *event = [[_eventDetailVc viewControllers] objectAtIndex:0];
//    
//    for (GTLZeppanotificationendpointZeppaNotification *notification in _arrNotifications) {
//        
//       [notificationEventArr addObject:[[ZPAZeppaEventSingleton sharedObject]getEventById: [notification.eventId longLongValue]]];
//    }
//    
//   
//    
//    
//    event.eventDetail = [notificationEventArr objectAtIndex:indexPath.row];
//    
//    [self presentViewController:_eventDetailVc animated:YES completion:NULL];
//
    
    ///Take Action according to Notification Type

}

//****************************************************
#pragma mark - Private Method
//****************************************************
-(void)onClickActivity:(NSInteger )index{
    
    GTLZeppanotificationendpointZeppaNotification * notification = [_arrNotifications objectAtIndex:index];
    
    switch ([[ZPANotificationSingleton sharedObject]getNotificationTypeOrder:notification]) {
        case 0: //Mingle Request
        {
            ZPARequsetMinglersVC * requestMinglers = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPARequsetMinglersVC"];
           // [ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:<#(long long)#>
            
            [[ZPANotificationSingleton sharedObject]executeRemoveNotification:[notification.identifier longLongValue]];
            
            [self.navigationController pushViewController:requestMinglers animated:YES];
            
            [_tableView reloadData];
            
            break;
        }
        case 1: // mingler Accepted
        {
            ZPAUserProfileVC *userProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAUserProfileVC"];
            
            ZPADefaulZeppatUserInfo *defaultZeppaUserInfo = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[notification.userId longLongValue]];
            
            NSString * str = [NSString stringWithFormat:@"%@ %@", defaultZeppaUserInfo.zeppaUserInfo.givenName,defaultZeppaUserInfo.zeppaUserInfo.familyName];
            
            NSLog(@"name %@",str);
            
            userProfile.userProfileInfo = defaultZeppaUserInfo;
            
            userProfile.userTagArray = [[[ZPAZeppaEventTagSingleton sharedObject] getZeppaTagForUser:[defaultZeppaUserInfo.userId longLongValue]]mutableCopy];
            
            NSLog(@"userTag %@",userProfile.userTagArray);
            
            [[ZPANotificationSingleton sharedObject]executeRemoveNotification:[notification.identifier longLongValue]];
            
            [self.navigationController pushViewController:userProfile animated:YES];
            
            [_tableView reloadData];
            
        }
            break;
        
        case 2: // event Recommendation
            
            [self showEventDetailViewController:notification];
            break;
            
        case 3: // Direct Invite, Implement Later
            
            [self showEventDetailViewController:notification];
            break;
            
        case 4: // Post Comment
            // TODO: Determine if this is my event or another
            
            [self showEventDetailViewController:notification];
            break;
            
        case 5: // Event Cancelled
            
            [ZPAStaticHelper showAlertWithTitle:nil andMessage:@"Event Was Canceled..."];
            break;
            
        case 6: // Event Updated (Unimplemented for now)
        
           [self showEventDetailViewController:notification];
            break;
            
        case 7: // Friend Joined Event
            [self showEventDetailViewController:notification];
            break;
            
        case 8: // User Left Event
            
            [self showEventDetailViewController:notification];
            break;
            
            
        default:
            break;
    }
    
}




//
//Intent intent = null;
//switch (NotificationSingleton.getInstance().getNotificationTypeOrder(
//                                                                     notification)) {
//        
//    case 0: // Mingle Request;
//        intent = new Intent(activity, StartMinglingActivity.class);
//        activity.overridePendingTransition(R.anim.slide_up_in, R.anim.hold);
//        activity.startActivity(intent);
//        ThreadManager.execute(new RemoveNotificationRunnable(
//                                                             (ZeppaApplication) activity.getApplication(), activity
//                                                             .getGoogleAccountCredential(), notification.getId()
//                                                             .longValue()));
//        
//        break;
//    case 1: // Mingle Accepted
//        intent = new Intent(activity, MinglerActivity.class);
//        intent.putExtra(Constants.INTENT_ZEPPA_USER_ID,
//                        notification.getSenderId());
//        activity.startActivity(intent);
//        
//        activity.overridePendingTransition(R.anim.slide_left_in,
//                                           R.anim.slide_left_out);
//        ThreadManager.execute(new RemoveNotificationRunnable(
//                                                             (ZeppaApplication) activity.getApplication(), activity
//                                                             .getGoogleAccountCredential(), notification.getId()
//                                                             .longValue()));
//        
//        break;
//    case 2: // Event Recommendation
//        intent = new Intent(activity, DefaultEventViewActivity.class);
//        intent.putExtra(Constants.INTENT_ZEPPA_EVENT_ID,
//                        notification.getEventId());
//        activity.startActivity(intent);
//        activity.overridePendingTransition(R.anim.slide_left_in,
//                                           R.anim.slide_left_out);
//        break;
//    case 3: // Direct Invite, Implement Later
//        intent = new Intent(activity, DefaultEventViewActivity.class);
//        intent.putExtra(Constants.INTENT_ZEPPA_EVENT_ID,
//                        notification.getEventId());
//        activity.startActivity(intent);
//        activity.overridePendingTransition(R.anim.slide_left_in,
//                                           R.anim.slide_left_out);
//        
//        break;
//    case 4: // Post Comment
//        // TODO: Determine if this is my event or another
//        intent = new Intent(activity, AbstractEventViewActivity.class);
//        intent.putExtra(Constants.INTENT_ZEPPA_EVENT_ID,
//                        notification.getEventId());
//        activity.startActivity(intent);
//        activity.overridePendingTransition(R.anim.slide_left_in,
//                                           R.anim.slide_left_out);
//        break;
//        
//    case 5: // Event Canceled
//        // TODO: delete notification and notify Dataset changed
//        Toast toast = Toast.makeText(activity, "Event Was Canceled...",
//                                     Toast.LENGTH_LONG);
//        toast.show();
//        // Perhaps send them to the calendar and show the opened time slot?
//        break;
//        
//    case 6: // Event Updated (Unimplemented for now)
//        intent = new Intent(activity, DefaultEventViewActivity.class);
//        intent.putExtra(Constants.INTENT_ZEPPA_EVENT_ID,
//                        notification.getEventId());
//        activity.startActivity(intent);
//        
//        activity.overridePendingTransition(R.anim.slide_left_in,
//                                           R.anim.slide_left_out);
//        break;
//    case 7: // Friend Joined Event
//        intent = new Intent(activity, MyEventViewActivity.class);
//        intent.putExtra(Constants.INTENT_ZEPPA_EVENT_ID,
//                        notification.getEventId());
//        activity.startActivity(intent);
//        activity.overridePendingTransition(R.anim.slide_left_in,
//                                           R.anim.slide_left_out);
//        break;
//    case 8: // User Left Event
//        intent = new Intent(activity, MyEventViewActivity.class);
//        intent.putExtra(Constants.INTENT_ZEPPA_EVENT_ID,
//                        notification.getEventId());
//        activity.startActivity(intent);
//        activity.overridePendingTransition(R.anim.slide_left_in,
//                                           R.anim.slide_left_out);
//        break;
//        
//}
//
//}

-(void)showEventDetailViewController:(GTLZeppanotificationendpointZeppaNotification *)notification{
    
        _eventDetailVc = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
    
    
        ZPAEventDetailVC *event = [[_eventDetailVc viewControllers] objectAtIndex:0];
    
    
    
//        [notificationEventArr addObject:[[ZPAZeppaEventSingleton sharedObject]getEventById: [notification.eventId longLongValue]]];
    
    
        event.eventDetail = [[ZPAZeppaEventSingleton sharedObject]getEventById: [notification.eventId longLongValue]];
    
        [self presentViewController:_eventDetailVc animated:YES completion:NULL];

    
    
}

//****************************************************
#pragma mark - UIRefresh Control
//****************************************************
- (void)refreshTable:(UIRefreshControl *)refresh {
    
    
    [_refreshControl endRefreshing];
   _arrNotifications = [[[ZPANotificationSingleton sharedObject]getNotification]mutableCopy];
    [self.tableView reloadData];
}

@end
