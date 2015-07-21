//
//  ZPASplitViewProtocol.h
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZPASplitViewProtocol <NSObject>

@optional

- (void)movePanelToOriginalPosition:(id)sender;

@required
- (void)movePanelToRight:(id)sender;

@end


