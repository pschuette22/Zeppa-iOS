//
//  ZPAExtendABidVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAExtendABidVC.h"
#import "ZPAExtendBidCell.h"
#import "UIImageView+WebCache.h"
#import "GTLZeppauserendpointZeppaUserInfo.h"


@interface ZPAExtendABidVC ()

@property (nonatomic, strong)NSMutableArray *arrExtendedUsers;
@property (nonatomic,strong)NSIndexPath *selectedRowIndex;
@property (nonatomic,strong)NSIndexPath *preSelectedIndex;
@end

@implementation ZPAExtendABidVC{
    
    BOOL toggleButtonCheck;
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
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    self.title = NSLocalizedString(@"Extend A Bid", nil);
    
    
    ///Insert Dummy Minglers for now
    self.arrExtendedUsers = [NSMutableArray arrayWithObjects:
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        [ZPAAppData sharedAppData].loggedInUser,
                        nil];

    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrExtendedUsers.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *strExtendBidCellId = @"ZPAExtendBidCell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strMinglerCellId];
    //    cell.textLabel.text = @"test";
    //
    //    return cell;
    
    ZPAExtendBidCell *extendBidCell = [tableView dequeueReusableCellWithIdentifier:strExtendBidCellId];
    extendBidCell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    if (!extendBidCell) {
        NSLog(@"Extend Bid cell is empty");
    }
    
    
    
    ZPAMyZeppaUser *extendUser = [self.arrExtendedUsers objectAtIndex:indexPath.row];
 /*
    NSURL *minglerImageUrl = [NSURL URLWithString:mingler.endPointUser.userInfo.imageUrl];
    [minglerCell.imageView_MinglerProfilePic setImageWithURL:minglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        ///Do anything with image
        
    }];
    */
    
    extendBidCell.lblUsername.text = [NSString stringWithFormat:@"%@ %@",extendUser.endPointUser.userInfo.givenName,extendUser.endPointUser.userInfo.familyName];
    
    
    if ((_selectedRowIndex)
        &&(_selectedRowIndex.row == indexPath.row && _selectedRowIndex.section == indexPath.section)) {
        UIView *view = [[UIView alloc]initWithFrame:(CGRect){0,0,_tableView.frame.size.width,44}];
        view.backgroundColor = [ZPAStaticHelper zeppaThemeColor];
        extendBidCell.backgroundView = view;
        CGRect separterFrame = extendBidCell.separtersView.frame;
        separterFrame.origin.y = 88.0;
        extendBidCell.separtersView.frame = separterFrame;
        
        [extendBidCell.btnDisclosureIndicator setImage:[UIImage imageNamed:@"ic_down_arrow.png"] forState:UIControlStateNormal];
        
    }else{
        
        UIView *view = [[UIView alloc]initWithFrame:(CGRect){0,0,_tableView.frame.size.width,44}];
        view.backgroundColor = [UIColor clearColor];
        extendBidCell.backgroundView = view;
        CGRect separterFrame = extendBidCell.separtersView.frame;
        separterFrame.origin.y = 42.0;
        extendBidCell.separtersView.frame = separterFrame;
        [extendBidCell.btnDisclosureIndicator setImage:[UIImage imageNamed:@"ic_invite_icon.png"] forState:UIControlStateNormal];
    }
        
    return extendBidCell;
    
}


//****************************************************
 #pragma mark - UITableViewDelegate Methods
//****************************************************

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return ((_selectedRowIndex) &&  (_selectedRowIndex.row == indexPath.row && _selectedRowIndex.section == indexPath.section )) ?90 : 44;

}


- (IBAction)btn_inviteTapped:(UIButton *)sender {
    
    ZPAExtendBidCell *clickedCell = (ZPAExtendBidCell *)[[[sender superview] superview] superview];
    _selectedRowIndex = [self.tableView indexPathForCell:clickedCell];
    
    if((_preSelectedIndex) &&  (_preSelectedIndex.row == _selectedRowIndex.row && _preSelectedIndex.section == _selectedRowIndex.section )){
        
        _selectedRowIndex =nil;
        
    }
    _preSelectedIndex = _selectedRowIndex;
    [self.tableView reloadData];
    
}

@end
