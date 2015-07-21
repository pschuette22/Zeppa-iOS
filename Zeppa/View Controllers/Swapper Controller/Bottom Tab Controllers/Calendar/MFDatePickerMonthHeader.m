#import "MFDatePickerMonthHeader.h"

@implementation MFDatePickerMonthHeader
@synthesize textLabel = _textLabel;

- (UILabel *) textLabel {
	if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,10, 320, 30)];
		_textLabel.textAlignment = NSTextAlignmentCenter;
		_textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [_textLabel setBackgroundColor: [UIColor clearColor]];
		_textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        UILabel *sun = [[UILabel alloc] initWithFrame:CGRectMake(0,40, 46,20)];
        [sun setText:@"Sun"];
		[self setting:sun];
        
        UILabel *mon = [[UILabel alloc] initWithFrame:CGRectMake(46,40, 46,20)];
        [mon setText:@"Mon"];
        [self setting:mon];
		      
        UILabel *tue = [[UILabel alloc] initWithFrame:CGRectMake(92,40, 46,20)];
        [tue setText:@"Tue"];
		[self setting:tue];
        
        UILabel *wed = [[UILabel alloc] initWithFrame:CGRectMake(138,40, 46,20)];
        [wed setText:@"Wed"];
        [self setting:wed];
		      
        UILabel *thu = [[UILabel alloc] initWithFrame:CGRectMake(184,40, 46,20)];
        [thu setText:@"Thu"];
        [self setting:thu];
		      
        UILabel *fri = [[UILabel alloc] initWithFrame:CGRectMake(230,40, 46,20)];
        [fri setText:@"Fri"];
		[self setting:fri];
        
        UILabel *sat = [[UILabel alloc] initWithFrame:CGRectMake(276,40, 46,20)];
        [sat setText:@"Sat"];
		[self setting:sat];
        
        
        [self addSubview:_textLabel];
	}
	return _textLabel;
}
-(void)setting:(UILabel *)label
{
    
    label.font = [UIFont fontWithName:@"Helvetica" size:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor=[UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:label];
    
  
}
@end
