//
//  ZPALeftMenuProfileCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 27/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPALeftMenuProfileCell.h"

@implementation ZPALeftMenuProfileCell

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    self.imageView_Profile.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.imageView_Profile.layer.borderWidth = 1.0f;
    self.imageView_Profile.layer.cornerRadius = 10.0f;
    self.imageView_Profile.layer.masksToBounds = YES;
    
}

@end
