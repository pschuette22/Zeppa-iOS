//
//  ZPACommonMinglersCell.m
//  Zeppa
//
//  Created by Faran on 08/05/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPACommonMinglersCell.h"

@implementation ZPACommonMinglersCell

- (void)awakeFromNib {
    // Initialization code
    _imageView_CommonMinglersImage.layer.cornerRadius = 5.0;
    _imageView_CommonMinglersImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
