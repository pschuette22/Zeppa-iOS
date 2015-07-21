//
//  ZPALeftMenuItemCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 27/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPALeftMenuItemCell.h"

@implementation ZPALeftMenuItemCell

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
//    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
//    bgView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    bgView.backgroundColor = [ZPAStaticHelper zeppaThemeColor];
//    self.selectedBackgroundView = bgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
