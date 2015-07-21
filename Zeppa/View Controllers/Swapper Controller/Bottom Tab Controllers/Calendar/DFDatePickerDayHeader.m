//
//  DFDatePickerDayHeader.m
//  Zeppa
//
//  Created by Milan Agarwal on 17/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "DFDatePickerDayHeader.h"

@implementation DFDatePickerDayHeader

@synthesize textLabel = _textLabel;

- (UILabel *) textLabel {
	if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10, 320, 30)];
		_textLabel.textAlignment = NSTextAlignmentCenter;
        UIColor *textColor =[UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:1.0];
        _textLabel.textColor = textColor;
		_textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [_textLabel setBackgroundColor: [UIColor clearColor]];
		_textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_textLabel];
	}
	return _textLabel;
}

@end
