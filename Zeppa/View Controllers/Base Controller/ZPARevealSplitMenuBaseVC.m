//
//  ZPABaseVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPARevealSplitMenuBaseVC.h"

#define TAG_HIDE_LEFT_MENU              1001
#define TAG_SHOW_LEFT_MENU              1002


@interface ZPARevealSplitMenuBaseVC ()

@end

@implementation ZPARevealSplitMenuBaseVC

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
#pragma mark - Action Methods
//****************************************************


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

@end
