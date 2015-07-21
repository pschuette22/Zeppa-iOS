//
//  ZPAUserInfoCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 07/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAUserInfoCell.h"

@implementation ZPAUserInfoCell

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

- (IBAction)btnEditProfilePicTapped:(UIButton *)sender {
}


-(void)layoutSubviews
{
    self.view_ProfilePicContainer.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.view_ProfilePicContainer.layer.borderWidth = 1.0f;
    self.view_ProfilePicContainer.layer.cornerRadius = 10.0f;
    self.view_ProfilePicContainer.layer.masksToBounds = YES;
}
@end
