//
//  ZPAExtendBidCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 05/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAExtendBidCell.h"

@implementation ZPAExtendBidCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    _selectedRow = NO;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    self.btnDisclosureIndicator.selected = selected;
//    
//    
//    if (selected) {
//        ///Configure subviews for selected state
//        self.lblUsername.textColor = [UIColor whiteColor];
//        
//    }
//    else{
//        self.lblUsername.textColor = [UIColor blackColor];
//    }

    
}

-(void)layoutSubviews
{
    
    self.imageView_UserPic.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.imageView_UserPic.layer.borderWidth = 1.0f;
    self.imageView_UserPic.layer.cornerRadius = 5.0f;
    self.imageView_UserPic.layer.masksToBounds = YES;
    
    
    //text and email button Setting
    
    self.btnEmail.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.btnEmail.layer.borderWidth = 1.0f;
    self.btnEmail.layer.cornerRadius = 3.0f;
    self.btnEmail.layer.masksToBounds = YES;
    
    self.btnTextMessage.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.btnTextMessage.layer.borderWidth = 1.0f;
    self.btnTextMessage.layer.cornerRadius = 3.0f;
    self.btnTextMessage.layer.masksToBounds = YES;
}


@end
