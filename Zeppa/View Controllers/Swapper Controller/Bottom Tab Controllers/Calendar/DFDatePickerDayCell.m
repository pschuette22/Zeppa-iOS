#import "DFDatePickerDayCell.h"
#import "ZPADateHelper.h"
#import "DaySlots.h"



@interface DFDatePickerDayCell (){
    BOOL changeHeight;
    NSIndexPath *selectedIndexPath;
}
+ (NSCache *) imageCache;
+ (id) cacheKeyForPickerDate:(MFDatePickerDate)date;
+ (id) fetchObjectForKey:(id)key withCreator:(id(^)(void))block;
@property (nonatomic, readonly, strong) UIImageView *imageView;
@property (nonatomic, readonly, strong) UIView *overlayView;
@end

@implementation DFDatePickerDayCell
{
    
    UIView *currentTimeView;
    DaySlots *day;
    NSUInteger noOfObjectInZeppaCalendar;
}
@synthesize imageView = _imageView;
@synthesize overlayView = _overlayView;

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
//#warning tochange
        self.backgroundColor = [UIColor whiteColor];
        _eventsView= [[UIView alloc]init];
        _eventsView.frame=CGRectMake(0,0, 320, 1700);
        _eventsView.backgroundColor=[UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        //_eventsView.backgroundColor=[UIColor redColor];
        
        noOfObjectInZeppaCalendar=[ZPAAppData sharedAppData].arrSyncedCalendarsEvents.count;
        [self addSubview:_eventsView];
        [self makeTextLable];
	}
	return self;
}
-(void)makeTextLable
{
    for (int i=0; i<24; i++) {
        
        UILabel *label =[[UILabel alloc]init];
        UIView *view = [[UIView alloc]init];
        view.tag=i;
        label.tag=i;
        view.backgroundColor=[UIColor blackColor];
        if (i<=11) {
            label.text=[NSString stringWithFormat:@"%d AM",i];
        }
        else
        {
            label.text=[NSString stringWithFormat:@"%d PM",i-12];
        }
        if ([label.text isEqualToString:@"0 PM"]||[label.text isEqualToString:@"0 AM"]) {
            label.text=([label.text isEqualToString:@"0 PM"])?@"12 PM":@"12 AM";
            
        }
        label.font=[UIFont fontWithName:@"Helvetica" size:14];
        label.textAlignment=NSTextAlignmentLeft;
        label.frame=CGRectMake(10, (_eventsView.frame.size.height/24)*i, 50, 10);
        view.frame=CGRectMake(55, ((_eventsView.frame.size.height/24)*i+5), 320, 0.5);
        [_eventsView addSubview:label];
        [_eventsView addSubview:view];
        
        
    }
    
}
-(void)drawCurrentTime
{
    //****************************************************************
#pragma mark - CurrentTime
    //****************************************************************
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
    if (self.date.day==[components day] && self.date.month==[components month] && self.date.year==[components year])
    {
        float timeHeight =(([components hour])*(_eventsView.frame.size.height/24)+([components minute]*(_eventsView.frame.size.height/24)/60));
        static NSDateFormatter * df = nil;
        if(!df){
            df = [[NSDateFormatter alloc]init];
        }
        [df setDateFormat:@"h:mm a"];
        NSString *depResult = [df stringFromDate:[NSDate date]];
        UILabel *timeLabel=[[UILabel alloc]init];
        timeLabel.text=[NSString stringWithFormat:@"%@",depResult];
        [timeLabel sizeToFit];
        timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
        timeLabel.textColor=[UIColor redColor];
        timeLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        timeLabel.frame=CGRectMake(8,0, timeLabel.frame.size.width, 15);
        
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=[UIColor redColor];
        view.frame=CGRectMake(timeLabel.frame.size.width+5,6, 265, 1.0);
        currentTimeView=[[UIView alloc]init];
        currentTimeView.frame=CGRectMake(0,timeHeight,320,15);
        [currentTimeView addSubview:view];
        [currentTimeView addSubview:timeLabel];
        [_eventsView addSubview:currentTimeView];
        ///
        if ([components minute]>50) {
            for (UIView *view in _eventsView.subviews) {
                if ([view isKindOfClass:[UIView class]])
                {
                    if ((view.tag==[components hour]) )
                    {
                        view.hidden=YES;
                    }
                }
                if ([view isKindOfClass:[UILabel class]])
                {
                    if ((view.tag==[components hour]) )
                    {
                        view.hidden=YES;
                    }
                }
                
            }
        }
        /////////
        if ([components minute]<10) {
            for (UIView *view in _eventsView.subviews) {
                if ([view isKindOfClass:[UIView class]])
                {
                    if ((view.tag==[components hour]) )
                    {
                        view.hidden=YES;
                    }
                }
                if ([view isKindOfClass:[UILabel class]])
                {
                    if ((view.tag==[components hour]) )
                    {
                        view.hidden=YES;
                    }
                }
                
            }
        }
        ////////
    }
}
-(void)removeVerticalView
{
    
    [[_eventsView viewWithTag:100] removeFromSuperview];
    [currentTimeView removeFromSuperview];
    
}

- (void) setDate:(MFDatePickerDate)date {
	_date = date;
	[self setNeedsLayout];
}

- (void) setEnabled:(BOOL)enabled {
	_enabled = enabled;
	[self setNeedsLayout];
}

- (void) setHighlighted:(BOOL)highlighted {
	[super setHighlighted:highlighted];
	[self setNeedsLayout];
}
- (void) setSelected:(BOOL)selected {
	[super setSelected:selected];
	[self setNeedsLayout];
}

- (void) layoutSubviews {
	
	[super layoutSubviews];
	
    self.imageView.alpha = self.enabled ? 1.0f : 1.0f;
    self.imageView.image = [self getImage];
	self.overlayView.hidden = !(self.selected || self.highlighted);
    
}
-(UIImage *)getImage
{
    
    
    if ([[ZPAAppData sharedAppData].dicRecurrenceEventsForDayFlow objectForKey:[NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)_date.year,(unsigned long)_date.month,(unsigned long)_date.day]]) {
        
        NSArray *arr = [[ZPAAppData sharedAppData].dicRecurrenceEventsForDayFlow objectForKey:[NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)_date.year,(unsigned long)_date.month,(unsigned long)_date.day]];
        for (int i=0; i<arr.count; i++) {
            
            
            GTLCalendarEvent *event = [arr objectAtIndex:i];
            
            NSDictionary *dictStartDate = [[event JSON] objectForKey:kZeppaEventsStartDateKey];
            NSString *strStartDateTime = [dictStartDate objectForKey:kZeppaEventsDateTimeKey];
            NSDate *eventStartDate = [[ZPADateHelper sharedHelper]dateFromString:strStartDateTime withFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            
            NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitTimeZone fromDate:eventStartDate];
            
            
            ZPAEvent *eventWrapper = [[ZPAEvent alloc]initWithGoogleEvent:event];
            
            
            NSDate *date =[[ZPADateHelper sharedHelper]dateFromString:[NSString stringWithFormat:@"%lu-%lu-%lu %ld:%ld:%ld",(unsigned long)_date.year,(unsigned long)_date.month,(unsigned long)_date.day,(long)comps.hour,(long)comps.minute,(long)comps.second]  withFormat:@"yyyy-MM-dd HH:mm:ss" andTimeZone:[[NSTimeZone localTimeZone] name]];
            
            
            eventWrapper.startDateTime=date;
#warning faraan synch to change
            if([ZPAAppData sharedAppData].arrSyncedCalendarsEvents.count>noOfObjectInZeppaCalendar){
                [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents removeObjectsInRange:NSMakeRange(noOfObjectInZeppaCalendar, [ZPAAppData sharedAppData].arrSyncedCalendarsEvents.count)];
            }
            [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents addObject:eventWrapper];
            
        }
        
    }
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.window.screen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    static NSDateFormatter * dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [[NSDateFormatter alloc]init];
    }
    UIColor *textColor =[UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:1.0];
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0].CGColor);
    [self removeVerticalView];
    [self drawCurrentTime];
    if ([[[self class]viewsDictonary]objectForKey:[NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)self.date.year,(unsigned long)self.date.month,(unsigned long)self.date.day]]) {
        
        [_eventsView addSubview:[[[self class]viewsDictonary]objectForKey:[NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)self.date.year,(unsigned long)self.date.month,(unsigned long)self.date.day]]];
        
    }else{
        
        day =[[DaySlots alloc]initWithDay:[NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)self.date.year,(unsigned long)self.date.month,(unsigned long)self.date.day] andAllEvents:[ZPAAppData sharedAppData].arrSyncedCalendarsEvents];
        day.tag=100;
        [_eventsView addSubview:day];
        [[[self class]viewsDictonary]setObject:day forKey:[NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)self.date.year,(unsigned long)self.date.month,(unsigned long)self.date.day]];
    }
    CGContextFillRect(context, self.bounds);
    
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByCharWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    CGRect textBounds = (CGRect){ 0.0f, 10.0f, 320.0f, 24.0f };
    
    
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:self.date.day];
    [comps setMonth:self.date.month];
    [comps setYear:self.date.year];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayName =[dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *monthName =[dateFormatter stringFromDate:date];
    
    [[NSString stringWithFormat:@"%@ %@ %lu,%lu",dayName,monthName,(unsigned long)self.date.day,(unsigned long)self.date.year] drawInRect:textBounds withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:textColor}];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}
- (UIView *) overlayView {
	if (!_overlayView) {
		_overlayView = [[UIView alloc] initWithFrame:self.contentView.bounds];
		_overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_overlayView.backgroundColor = [UIColor blackColor];
		_overlayView.alpha = 0.25f;
		[self.contentView addSubview:_overlayView];
	}
	return _overlayView;
}

- (UIImageView *) imageView {
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
		_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:_imageView];
	}
	return _imageView;
}
+ (id)viewsDictonary{
    static NSMutableDictionary *dic = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dic = [[NSMutableDictionary alloc] init];
    });
    return dic;
}
+ (NSCache *) imageCache {
	static NSCache *cache;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cache = [NSCache new];
	});
	return cache;
}

+ (id) cacheKeyForPickerDate:(MFDatePickerDate)date {
	return @(date.day);
}

+ (id) fetchObjectForKey:(id)key withCreator:(id(^)(void))block {
	id answer = [[self imageCache] objectForKey:key];
	if (!answer) {
		answer = block();
		[[self imageCache] setObject:answer forKey:key];
	}
	return answer;
}
@end
