#import "MFDatePickerDayCell.h"
#import "ZPADateHelper.h"
@interface MFDatePickerDayCell ()
+ (NSCache *) imageCache;
+ (id) cacheKeyForPickerDate:(MFDatePickerDate)date;
+ (id) fetchObjectForKey:(id)key withCreator:(id(^)(void))block;

@property (nonatomic, readonly, strong) UIView *overlayView;
@property (nonatomic, readonly, strong) UIView *dotView;
@property CGSize imageSize;
@end

@implementation MFDatePickerDayCell

@synthesize imageView = _imageView;
@synthesize overlayView = _overlayView;

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
        
    }
#warning  to chagne arr
    if (!_EventDateDictionary) {
        _EventDateDictionary =[[NSMutableDictionary alloc]init];
        for (ZPAEvent *event in [ZPAAppData sharedAppData].arrSyncedCalendarsEvents) {
            
            int year = [[[[[ZPADateHelper sharedHelper]stringFromDate:event.startDateTime withFormat:@"yyyy-MM-dd"]  componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
            
            int month = [[[[[ZPADateHelper sharedHelper]stringFromDate:event.startDateTime withFormat:@"yyyy-MM-dd"]  componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
            int day = [[[[[ZPADateHelper sharedHelper]stringFromDate:event.startDateTime withFormat:@"yyyy-MM-dd"]  componentsSeparatedByString:@"-"] objectAtIndex:2] intValue];
            [_EventDateDictionary setObject:event forKey:[NSString stringWithFormat:@"%d-%d-%d",year,month,day]];
            
        }
        
    }
    return self;
}

- (void) setDate:(MFDatePickerDate)date {
	_date = date;
    [self setNeedsLayout];
}

-(void) setEnabled:(BOOL)enabled {
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
    
    self.imageView.alpha = self.enabled ? 1.0f : 0.25f;
    
    NSDateComponents *comp =[[NSDateComponents alloc]init];
    [comp setDay:self.date.day];
    [comp setMonth:self.date.month];
    [comp setYear:self.date.year];
    
    
    if ([_EventDateDictionary objectForKey:[NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)_date.year,(unsigned long)_date.month,(unsigned long)_date.day]] || [[ZPAAppData sharedAppData].dicRecurrenceEventsForMonthFlow objectForKey:[NSString stringWithFormat:@"%lu-%lu-%lu",(unsigned long)_date.year,(unsigned long)_date.month,(unsigned long)_date.day]]) {
        
        if ([[ZPADateHelper sharedHelper]isCurrentDateTodayInDateComponent:comp]) {
            self.imageView.image = [[self class] fetchTodayObjectForKey:[[self class] cacheKeyForPickerDate:self.date] withCreator:^{
                
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.window.screen.scale);
                CGContextRef context = UIGraphicsGetCurrentContext();
                UIColor *textColor;
                textColor=[UIColor blackColor];
                //CGContextSetFillColorWithColor(context, [UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:1.0].CGColor);
                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextFillRect(context, self.bounds);
                
                NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
                textStyle.lineBreakMode = NSLineBreakByCharWrapping;
                textStyle.alignment = NSTextAlignmentCenter;
                
                UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
                CGRect textBounds = (CGRect){ 0.0f, 10.0f, 44.0f, 24.0f };
                
                
                [[NSString stringWithFormat:@"%lu", (unsigned long)self.date.day] drawInRect:textBounds withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:textColor}];
                
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(45.5, 64), NO, 0.0f);
                UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(8.5, 2, 35, 35)];
                [[UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:0.5] setFill];
                [ovalPath fill];
                UIImage *dotImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                // merging dot image with date image.
                UIImage * newImage =[self drawImage:dotImage inImage:image];
                
                // Draw a Dot Image.
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(45.5, 64), NO, 0.0f);
                UIBezierPath *ovalPath1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.imageView.frame.size.width/2, 40, 8, 8)];
                [[UIColor lightGrayColor] setFill];
                [ovalPath1 fill];
                UIImage *dotImageWithCirlce = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                // merging dot image with date image.
                UIImage * newImageWithCircle =[self drawImage:dotImageWithCirlce inImage:newImage];
                

                
                return newImageWithCircle;
                
            }];
            
        }else{

        
        self.imageView.image = [[self class] fetchEventObjectForKey:[[self class] cacheKeyForPickerDate:self.date] withCreator:^{
            
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.window.screen.scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            UIColor *textColor;
            textColor=[UIColor blackColor];
           // CGContextSetFillColorWithColor(context,[UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:1.0].CGColor);
            
          // CGContextSetFillColorWithColor(context, [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

            
            
            CGContextFillRect(context, self.bounds);
            
            NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            textStyle.lineBreakMode = NSLineBreakByCharWrapping;
            textStyle.alignment = NSTextAlignmentCenter;
            
            
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
            CGRect textBounds = (CGRect){ 0.0f, 10.0f, 44.0f, 24.0f };
            
            
            [[NSString stringWithFormat:@"%lu", (unsigned long)self.date.day] drawInRect:textBounds withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:textColor}];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // Draw a Dot Image.
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(45.5, 64), NO, 0.0f);
            UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.imageView.frame.size.width/2, 40, 8, 8)];
            [[UIColor lightGrayColor] setFill];
            [ovalPath fill];
            UIImage *dotImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // merging dot image with date image.
            UIImage * newImage =[self drawImage:dotImage inImage:image];
            
//                _dotView = [[UIView alloc]initWithFrame:CGRectMake(self.imageView.frame.size.width/2-4, self.imageView.frame.size.height-25, 8, 8)];
//                
//                [_dotView setBackgroundColor:[UIColor lightGrayColor]];
//                
//                _dotView.layer.cornerRadius = _dotView.bounds.size.width/2;
//                _dotView.layer.masksToBounds = YES;
//                _dotView.alpha= 0.5;
//                [self.imageView addSubview:_dotView];
//          //  }
            
            return newImage;
            
        }];
        }
    }
    
    
    else if ([[ZPADateHelper sharedHelper]isCurrentDateSundayInDateComponent:comp]) {
        self.imageView.image = [[self class] fetchSunObjectForKey:[[self class] cacheKeyForPickerDate:self.date] withCreator:^{
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.window.screen.scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            UIColor *textColor;
            textColor=[UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:1.0];
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            

            
            CGContextFillRect(context, self.bounds);
            
            NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            textStyle.lineBreakMode = NSLineBreakByCharWrapping;
            textStyle.alignment = NSTextAlignmentCenter;
            
            
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
            CGRect textBounds = (CGRect){ 0.0f, 10.0f, 44.0f, 24.0f };
            
            
            [[NSString stringWithFormat:@"%lu", (unsigned long)self.date.day] drawInRect:textBounds withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:textColor}];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            return image;
            
        }];
        
    }
    else if ([[ZPADateHelper sharedHelper]isCurrentDateTodayInDateComponent:comp]) {
        self.imageView.image = [[self class] fetchTodayObjectForKey:[[self class] cacheKeyForPickerDate:self.date] withCreator:^{
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.window.screen.scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            UIColor *textColor;
            textColor=[UIColor blackColor];
            //CGContextSetFillColorWithColor(context, [UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:1.0].CGColor);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillRect(context, self.bounds);
            
            NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            textStyle.lineBreakMode = NSLineBreakByCharWrapping;
            textStyle.alignment = NSTextAlignmentCenter;
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
            CGRect textBounds = (CGRect){ 0.0f, 10.0f, 44.0f, 24.0f };
            
            
            [[NSString stringWithFormat:@"%lu", (unsigned long)self.date.day] drawInRect:textBounds withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:textColor}];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(45.5, 64), NO, 0.0f);
            UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(8.5, 2, 35, 35)];
            [[UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:0.5] setFill];
            [ovalPath fill];
            UIImage *dotImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // merging dot image with date image.
            UIImage * newImage =[self drawImage:dotImage inImage:image];

            return newImage;
            
        }];
        
    }
    else
    {
        
        self.imageView.image = [[self class] fetchObjectForKey:[[self class] cacheKeyForPickerDate:self.date] withCreator:^{
            
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, self.window.screen.scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            UIColor *textColor;
            textColor=[UIColor blackColor];
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            

            
            CGContextFillRect(context, self.bounds);
            
            NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
            textStyle.lineBreakMode = NSLineBreakByCharWrapping;
            textStyle.alignment = NSTextAlignmentCenter;
            
            
            
            UIFont *font = [UIFont fontWithName:@"Helvetica" size:16];
            CGRect textBounds = (CGRect){ 0.0f, 10.0f, 44.0f, 24.0f };
            
            
            [[NSString stringWithFormat:@"%lu", (unsigned long)self.date.day] drawInRect:textBounds withAttributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:textStyle, NSForegroundColorAttributeName:textColor}];
            
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            _imageSize = [image size];
            
            
            return image;
            
        }];
    }
	self.overlayView.hidden = !(self.selected || self.highlighted);
    
}
- (UIView *) overlayView {
	if (!_overlayView) {
		_overlayView = [[UIView alloc] initWithFrame:self.contentView.bounds];
		_overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
		_overlayView.backgroundColor = [UIColor whiteColor];
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

+ (NSCache *) imageCache {
	static NSCache *cache;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cache = [NSCache new];
	});
	return cache;
}

+ (NSCache *) imageCacheForEvent {
	static NSCache *eventCache;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		eventCache = [NSCache new];
	});
	return eventCache;
}
+ (NSCache *) imageCacheForSun {
	static NSCache *sunCache;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sunCache = [NSCache new];
	});
	return sunCache;
}
+ (NSCache *) imageCacheForToday {
    static NSCache *todayCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        todayCache = [NSCache new];
    });
    return todayCache;
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
+ (id) fetchSunObjectForKey:(id)key withCreator:(id(^)(void))block {
	id answer = [[self imageCacheForSun] objectForKey:key];
	if (!answer) {
		answer = block();
		[[self imageCacheForSun] setObject:answer forKey:key];
	}
	return answer;
}
+ (id) fetchEventObjectForKey:(id)key withCreator:(id(^)(void))block {
	id answer = [[self imageCacheForEvent] objectForKey:key];
	if (!answer) {
		answer = block();
		[[self imageCacheForEvent] setObject:answer forKey:key];
	}
	return answer;
}
+ (id) fetchTodayObjectForKey:(id)key withCreator:(id(^)(void))block {
    id answer = [[self imageCacheForToday] objectForKey:key];
    if (!answer) {
        answer = block();
        [[self imageCacheForToday] setObject:answer forKey:key];
    }
    return answer;
}

//int total=(int)_colors.count;
//
//int startTag;
//
//if (total>=9) {
//    startTag=1;
//}else{
//    startTag=9-((total-1)/3)*3-2;
//}
//int tagOffset=startTag;
//
//self.alpha=1.0;
//CGContextRef context = UIGraphicsGetCurrentContext();
//CGContextClearRect(context, self.bounds);
//_context=context;
//for (int i=0;i<total;i++) {
//    
//    UIColor *colorForDot=[_colors objectAtIndex:i];
//    
//    CGPoint pointForDot=[self getPointForTag:tagOffset];
//    [self drawCircleWithConext:context color:colorForDot andOrigin:pointForDot];
//    
//    if (total%3!=0) {
//        if (tagOffset==startTag+total%3-1) {
//            tagOffset+=3-total%3;
//        }
//    }
//    tagOffset++;
//}
//}
//
-(void)drawCircleWithConext:(CGContextRef) context color:(UIColor *)color andOrigin:(CGPoint)point{
    CGRect borderRect = CGRectMake(self.imageView.frame.size.width/2-4, self.imageView.frame.size.height-25, 8, 8);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 2.0);
    CGContextFillEllipseInRect (context, borderRect);
    CGContextFillPath(context);
}

-(UIImage*) drawImage:(UIImage*) fgImage
              inImage:(UIImage*) bgImage
//              atPoint:(CGPoint)  point
{
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake( 0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake( self.imageView.frame.origin.x-4, self.imageView.frame.origin.y, fgImage.size.width, fgImage.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
