//
//  ZPABaseVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPASplitViewProtocol.h"

@interface ZPARevealSplitMenuBaseVC : UIViewController

@property (nonatomic, assign)id<ZPASplitViewProtocol>splitViewDelegate;

- (IBAction)btnRevealLeftMenuPanelTapped:(UIBarButtonItem *)sender;

@end
