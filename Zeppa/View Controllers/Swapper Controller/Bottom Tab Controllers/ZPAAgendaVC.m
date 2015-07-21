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
#import "ZPAOtherEventAgendaCell.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPAEventDetailVC.h"
#import "ZPADefaulZeppatEventInfo.h"

#import <MessageUI/MessageUI.h>


@interface ZPAAgendaVC ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong)NSMutableArray *arrAttendingEvents;
@property (nonatomic, strong)UINavigationController *eventDetailNavigation;



@end

@implementation ZPAAgendaVC{
     ZPAMyZeppaEvent *myEvent;
}

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
    _eventDetailNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Agenda", nil);
    
    ///Set background color of uiview
    [self.view setBackgroundColor:[ZPAStaticHelper backgroundTextureColor]];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self.tableView addSubview:_refreshControl];
    
    [_refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
	[super viewDidAppear:animated];
    
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    
    _arrAttendingEvents = [[[ZPAZeppaEventSingleton sharedObject]getInterestingEventMediators]mutableCopy];
    
    _currentUser = [ZPAAppData sharedAppData].loggedInUser;
    
    

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
#pragma mark - UIMessage Controller Delegate
//****************************************************
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            
            break;
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//****************************************************
#pragma mark - Mail Controller Delegate
//****************************************************
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"mail cancelled");
            
            break;
        case MFMailComposeResultFailed:
            
            NSLog(@"Mail failed %@",[error localizedDescription]);
            
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail succcessfuly sent");
            
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    

    return self.arrAttendingEvents.count;

    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger rowIndex = indexPath.row;
    
    myEvent = [_arrAttendingEvents objectAtIndex:rowIndex];
    NSLog(@"%@",myEvent.event.hostId);
    NSLog(@"%@",_currentUser.endPointUser.identifier);
    
    if( [myEvent.event.hostId isEqualToNumber: _currentUser.endPointUser.identifier]){
        
        ZPAMyEventAgendaCell *myEventAgendaCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAMyEventAgendaCell"];
        
        [myEventAgendaCell showEventDetailsOnAgendaCell:[_arrAttendingEvents objectAtIndex:rowIndex]];
        
        return myEventAgendaCell;
        
    }else{
        _otherEventAgendaCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAOtherEventAgendaCell"];
       

        
        [_otherEventAgendaCell showEventDetailsOnAgendaCell:[_arrAttendingEvents objectAtIndex:rowIndex]];
        
         return _otherEventAgendaCell;
        
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
    myEvent = [_arrAttendingEvents objectAtIndex:indexPath.row];
    
    if( [myEvent.event.hostId isEqualToNumber: _currentUser.endPointUser.identifier]){
        
        return 95.0f;
        
    }else{
        
        return 142.0f;
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     _eventDetailNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
    
    ZPAEventDetailVC *eventDetail= [[_eventDetailNavigation viewControllers] objectAtIndex:0];
    
    eventDetail.eventDetail= [_arrAttendingEvents objectAtIndex:indexPath.row];

    
    [self presentViewController:_eventDetailNavigation animated:YES completion:NULL];
    
    
    
}

///**********************************************
#pragma mark - Action Methods
///**********************************************
-(void)joinBtnTapped:(UIButton *)sender{
    
    
    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
    myEvent = [_arrAttendingEvents objectAtIndex:indexPath.row];
    
    myEvent.isAgenda = YES;
    
    if (![myEvent.relationship.isAttending boolValue] == true) {
        [sender setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
        [_otherEventAgendaCell.btnWatch setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [_otherEventAgendaCell.btnWatch setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
    }
    
    [[ZPADefaulZeppatEventInfo sharedObject]onJoinButtonClicked:myEvent.relationship];
    
    [_tableView reloadData];

    
}
-(void)watchBtnTapped:(UIButton *)sender{
    
    
    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
    myEvent = [_arrAttendingEvents objectAtIndex:indexPath.row];
    
    if (![myEvent.relationship.isWatching boolValue] == true) {
        [sender setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
    }
    [[ZPADefaulZeppatEventInfo sharedObject]onWatchButtonClicked:myEvent.relationship];
    
    [_tableView reloadData];
    

    
}
-(void)textBtnTapped:(UIButton *)sender{
    
    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
    myEvent = [_arrAttendingEvents objectAtIndex:indexPath.row];
    
    ZPADefaulZeppatUserInfo * eventMediatorInfo = [ZPADefaulZeppatUserInfo sharedObject];
    
    id eventHostMediator = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[myEvent.event.hostId longLongValue]];
    
    if ([eventHostMediator isKindOfClass:[ZPADefaulZeppatUserInfo class]]) {
        eventMediatorInfo = eventHostMediator;
    }else{
        
    }
    
    if (eventMediatorInfo.zeppaUserInfo.primaryUnformattedNumber) {
        [self showSmsWithRecepientsNumber:eventMediatorInfo.zeppaUserInfo.primaryUnformattedNumber];
    }else{
        [self sendEmailWithRecipientsMail:eventMediatorInfo.zeppaUserInfo.googleAccountEmail];
    }
    

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
#pragma mark - Private methods
//****************************************************

-(void)showSmsWithRecepientsNumber:(NSString *)phoneNumber{
    
    
    if(![MFMessageComposeViewController canSendText]){
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    NSArray * reciepients =[NSArray arrayWithObject:phoneNumber];
    MFMessageComposeViewController * messageController = [[MFMessageComposeViewController alloc]init];
    
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:reciepients];
    
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)sendEmailWithRecipientsMail:(NSString *)emailId{
    
    NSString * mailSubject = @"";
    NSString * mailBody = @"";
    NSArray * mailRecepients = [NSArray arrayWithObject:emailId];
    
    MFMailComposeViewController * mailController = [[MFMailComposeViewController alloc]init];
    
    mailController.mailComposeDelegate = self;
    
    [mailController setSubject:mailSubject];
    [mailController setMessageBody:mailBody isHTML:NO];
    [mailController setToRecipients:mailRecepients];
    
    [self presentViewController:mailController animated:YES completion:nil];
}


//****************************************************
#pragma mark - UIRefresh Control
//****************************************************
- (void)refreshTable:(UIRefreshControl *)refresh {
    
    
    [_refreshControl endRefreshing];
    _arrAttendingEvents = [[[ZPAZeppaEventSingleton sharedObject]getInterestingEventMediators]mutableCopy];
    [self.tableView reloadData];
}


@end