#import <QuartzCore/QuartzCore.h>
#import "DayFlow.h"
#import "MFDatePickerCollectionView.h"
#import "MFDatePickerDayCell.h"
#import "MFDatePickerMonthHeader.h"
#import "MFDatePickerView.h"
#import "NSCalendar+DFAdditions.h"
#import "ZPADateHelper.h"
#import "MBProgressHUD.h"


static NSString * const DFDatePickerViewCellIdentifier = @"dateCell";
static NSString * const DFDatePickerViewMonthHeaderIdentifier = @"monthHeader";

@interface MFDatePickerView () <DFDatePickerCollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, readonly, strong) NSCalendar *calendar;
@property (nonatomic, readonly, assign) MFDatePickerDate fromDate;
@property (nonatomic, readonly, assign) MFDatePickerDate toDate;
@property (nonatomic, readonly, strong) UICollectionView *collectionView;
@property (nonatomic, readonly, strong) UICollectionViewFlowLayout *collectionViewLayout;
@end

@implementation MFDatePickerView
{
    id eventReference;
    NSMutableDictionary *dailyDict;
    NSMutableDictionary *weeklyDict;
    NSMutableDictionary *monthlyDict;
    NSMutableDictionary *yearDict;
    NSInteger dailyCounter;
    NSInteger monthlyCounter;
    NSInteger yearlyCounter;
    NSInteger weeklyCounter;
    MBProgressHUD * progress;
    NSDate * today;
    
    
}

@synthesize calendar = _calendar;
@synthesize fromDate = _fromDate;
@synthesize toDate = _toDate;
@synthesize collectionView = _collectionView;
@synthesize collectionViewLayout = _collectionViewLayout;

- (instancetype) initWithCalendar:(NSCalendar *)calendar {
	
	self = [super initWithFrame:CGRectZero];
	if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(syncCalendar:) name:kzeppacalendarSync object:nil];
        
        [ZPAAppData sharedAppData].dicRecurrenceEventsForMonthFlow =[NSMutableDictionary dictionary];
        
        dailyDict = [NSMutableDictionary dictionary];
        weeklyDict = [NSMutableDictionary dictionary];
        monthlyDict = [NSMutableDictionary dictionary];
		yearDict = [NSMutableDictionary dictionary];
        
       
        
        _calendar = calendar;
        NSDate *now = [_calendar dateFromComponents:[_calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:[NSDate date]]];
        
        today = now;
        
		_fromDate = [self pickerDateFromDate:[_calendar dateByAddingComponents:((^{
			NSDateComponents *components = [NSDateComponents new];
			components.month = -6;
			return components;
		})()) toDate:now options:0]];
		
		_toDate = [self pickerDateFromDate:[_calendar dateByAddingComponents:((^{
			NSDateComponents *components = [NSDateComponents new];
			components.month = 6;
			return components;
		})()) toDate:now options:0]];
		
	}
	[self checkRecurrenceRuleWithDay:_fromDate.day andMonth:_fromDate.month andYear:_fromDate.year];
    
   // [progress hide:YES];
	return self;
	
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kzeppacalendarSync object:nil];
}

- (id) initWithFrame:(CGRect)frame {
	
	self = [self initWithCalendar:[NSCalendar currentCalendar]];
	if (self) {
		self.frame = frame;
	}
	
	return self;
	
}

- (void) layoutSubviews {
	
	[super layoutSubviews];
	
	self.collectionView.frame = self.bounds;
	if (!self.collectionView.superview) {
		[self addSubview:self.collectionView];
	}
	
}

- (void) willMoveToSuperview:(UIView *)newSuperview {
    
	[super willMoveToSuperview:newSuperview];
	
	if (newSuperview && !_collectionView) {
		//	do some initialization!
		UICollectionView *cv = self.collectionView;
		NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:([cv numberOfItemsInSection:(cv.numberOfSections / 2)] / 2) inSection:(cv.numberOfSections / 2)];
		[self.collectionView scrollToItemAtIndexPath:cellIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
	}
    
}

- (UICollectionView *) collectionView {
    
	if (!_collectionView) {
		_collectionView = [[MFDatePickerCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
		_collectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
       // _collectionView.backgroundColor = [UIColor whiteColor];
		_collectionView.dataSource = self;
		_collectionView.delegate = self;
		_collectionView.showsVerticalScrollIndicator = NO;
		_collectionView.showsHorizontalScrollIndicator = NO;
		[_collectionView registerClass:[MFDatePickerDayCell class] forCellWithReuseIdentifier:DFDatePickerViewCellIdentifier];
		[_collectionView registerClass:[MFDatePickerMonthHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DFDatePickerViewMonthHeaderIdentifier];
        
		[_collectionView reloadData];
	}
	
	return _collectionView;
    
}

- (UICollectionViewFlowLayout *) collectionViewLayout {
	
	//	Hard key these things.
	//	44 * 7 + 2 * 6 = 320; this is how the Calendar.app works
	//	and this also avoids the “one pixel” confusion which might or might not work
	//	If you need to decorate, key decorative views in.
	
	if (!_collectionViewLayout) {
        
		_collectionViewLayout = [UICollectionViewFlowLayout new];
		_collectionViewLayout.headerReferenceSize = (CGSize){ self.viewForBaselineLayout.frame.size.width, 64 };
		_collectionViewLayout.itemSize = (CGSize){ 45.5, 64 };
        _collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 2, 0);
		_collectionViewLayout.minimumLineSpacing = 2.0f;
		_collectionViewLayout.minimumInteritemSpacing = 0.0f;
	}
	
	return _collectionViewLayout;
    
}

- (void) pickerCollectionViewWillLayoutSubviews:(MFDatePickerCollectionView *)pickerCollectionView {
	
	//	Note: relayout is slower than calculating 3 or 6 months’ worth of data at a time
	//	So we punt 6 months at a time.
	
	//	Running Time	Self		Symbol Name
	//
	//	1647.0ms   23.7%	1647.0	 	objc_msgSend
	//	193.0ms    2.7%	193.0	 	-[NSIndexPath compare:]
	//	163.0ms    2.3%	163.0	 	objc::DenseMap<objc_object*, unsigned long, true, objc::DenseMapInfo<objc_object*>, objc::DenseMapInfo<unsigned long> >::LookupBucketFor(objc_object* const&, std::pair<objc_object*, unsigned long>*&) const
	//	141.0ms    2.0%	141.0	 	DYLD-STUB$$-[_UIHostedTextServiceSession dismissTextServiceAnimated:]
	//	138.0ms    1.9%	138.0	 	-[NSObject retain]
	//	136.0ms    1.9%	136.0	 	-[NSIndexPath indexAtPosition:]
	//	124.0ms    1.7%	124.0	 	-[_UICollectionViewItemKey isEqual:]
	//	118.0ms    1.7%	118.0	 	_objc_rootReleaseWasZero
	//	105.0ms    1.5%	105.0	 	DYLD-STUB$$CFDictionarySetValue$shim
	
	if (pickerCollectionView.contentOffset.y < 0.0f) {
		[self appendPastDates];
	}
	
	if (pickerCollectionView.contentOffset.y > (pickerCollectionView.contentSize.height - CGRectGetHeight(pickerCollectionView.bounds))) {
		[self appendFutureDates];
	}
	
}

- (void) appendPastDates {
    
	[self shiftDatesByComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.month = -6;
		return dateComponents;
	})())];
    
}

- (void) appendFutureDates {
	
	[self shiftDatesByComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.month = 6;
		return dateComponents;
	})())];
	
}

- (void) shiftDatesByComponents:(NSDateComponents *)components {
	
	UICollectionView *cv = self.collectionView;
	UICollectionViewFlowLayout *cvLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
	
	NSArray *visibleCells = [self.collectionView visibleCells];
	if (![visibleCells count])
		return;
	
	NSIndexPath *fromIndexPath = [cv indexPathForCell:((UICollectionViewCell *)visibleCells[0]) ];
	NSInteger fromSection = fromIndexPath.section;
	NSDate *fromSectionOfDate = [self dateForFirstDayInSection:fromSection];
    UICollectionViewLayoutAttributes *fromAttrs = [cvLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:fromSection]];
	CGPoint fromSectionOrigin = [self convertPoint:fromAttrs.frame.origin fromView:cv];
	
	_fromDate = [self pickerDateFromDate:[self.calendar dateByAddingComponents:components toDate:[self dateFromPickerDate:self.fromDate] options:0]];
	_toDate = [self pickerDateFromDate:[self.calendar dateByAddingComponents:components toDate:[self dateFromPickerDate:self.toDate] options:0]];
    
    [self checkRecurrenceRuleWithDay:_fromDate.day andMonth:_fromDate.month andYear:_fromDate.year];
    //    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    //        [self makeRecurrenceObject:[NSString stringWithFormat:@"%d-%d-%d",_fromDate.day,_fromDate.month,_fromDate.year]];
    //    }];
    
#if 0
	
	//	This solution trips up the collection view a bit
	//	because our reload is reactionary, and happens before a relayout
	//	since we must do it to avoid flickering and to heckle the CA transaction (?)
	//	that could be a small red flag too
	
	[cv performBatchUpdates:^{
		
		if (components.month < 0) {
			
			[cv deleteSections:[NSIndexSet indexSetWithIndexesInRange:(NSRange){
				cv.numberOfSections - abs(components.month),
				abs(components.month)
			}]];
			
			[cv insertSections:[NSIndexSet indexSetWithIndexesInRange:(NSRange){
				0,
				abs(components.month)
			}]];
			
		} else {
			
			[cv insertSections:[NSIndexSet indexSetWithIndexesInRange:(NSRange){
				cv.numberOfSections,
				abs(components.month)
			}]];
			
			[cv deleteSections:[NSIndexSet indexSetWithIndexesInRange:(NSRange){
				0,
				abs(components.month)
			}]];
			
		}
		
	} completion:^(BOOL finished) {
		
		NSLog(@"%s %x", __PRETTY_FUNCTION__, finished);
		
	}];
	
	for (UIView *view in cv.subviews)
		[view.layer removeAllAnimations];
	
#else
	
	[cv reloadData];
	[cvLayout invalidateLayout];
	[cvLayout prepareLayout];
    
#endif
    
	NSInteger toSection = [self.calendar components:NSMonthCalendarUnit fromDate:[self dateForFirstDayInSection:0] toDate:fromSectionOfDate options:0].month;
	UICollectionViewLayoutAttributes *toAttrs = [cvLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:toSection]];
	CGPoint toSectionOrigin = [self convertPoint:toAttrs.frame.origin fromView:cv];
	
	[cv setContentOffset:(CGPoint) {
		cv.contentOffset.x,
		cv.contentOffset.y + (toSectionOrigin.y - fromSectionOrigin.y)
	}];
	
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	
	return [self.calendar components:NSMonthCalendarUnit fromDate:[self dateFromPickerDate:self.fromDate] toDate:[self dateFromPickerDate:self.toDate] options:0].month;
	
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	
	return 7 * [self numberOfWeeksForMonthOfDate:[self dateForFirstDayInSection:section]];
	
}

- (NSDate *) dateForFirstDayInSection:(NSInteger)section {
    
	return [self.calendar dateByAddingComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.month = section;
		return dateComponents;
	})()) toDate:[self dateFromPickerDate:self.fromDate] options:0];
    
}

- (NSUInteger) numberOfWeeksForMonthOfDate:(NSDate *)date {
    
	NSDate *firstDayInMonth = [self.calendar dateFromComponents:[self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date]];
	
	NSDate *lastDayInMonth = [self.calendar dateByAddingComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.month = 1;
		dateComponents.day = -1;
		return dateComponents;
	})()) toDate:firstDayInMonth options:0];
	
	NSDate *fromSunday = [self.calendar dateFromComponents:((^{
		NSDateComponents *dateComponents = [self.calendar components:NSWeekOfYearCalendarUnit|NSYearForWeekOfYearCalendarUnit fromDate:firstDayInMonth];
		dateComponents.weekday = 1;
		return dateComponents;
	})())];
	
	NSDate *toSunday = [self.calendar dateFromComponents:((^{
		NSDateComponents *dateComponents = [self.calendar components:NSWeekOfYearCalendarUnit|NSYearForWeekOfYearCalendarUnit fromDate:lastDayInMonth];
		dateComponents.weekday = 1;
		return dateComponents;
	})())];
	
	return 1 + [self.calendar components:NSWeekCalendarUnit fromDate:fromSunday toDate:toSunday options:0].week;
	
}

- (MFDatePickerDayCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	MFDatePickerDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DFDatePickerViewCellIdentifier forIndexPath:indexPath];
    [cell.imageView clipsToBounds];
	NSDate *firstDayInMonth = [self dateForFirstDayInSection:indexPath.section];
	MFDatePickerDate firstDayPickerDate = [self pickerDateFromDate:firstDayInMonth];
	NSUInteger weekday = [self.calendar components:NSWeekdayCalendarUnit fromDate:firstDayInMonth].weekday;
    
    NSDate *cellDate = [self.calendar dateByAddingComponents:((^{
		NSDateComponents *dateComponents = [NSDateComponents new];
		dateComponents.day = indexPath.item - (weekday - 1);
		return dateComponents;
	})()) toDate:firstDayInMonth options:0];
	MFDatePickerDate cellPickerDate = [self pickerDateFromDate:cellDate];
    cell.backgroundColor = [UIColor whiteColor];
   	cell.date = cellPickerDate;
	cell.enabled = ((firstDayPickerDate.year == cellPickerDate.year) && (firstDayPickerDate.month == cellPickerDate.month));
	cell.selected = [self.selectedDate isEqualToDate:cellDate];
    
    if (cell.enabled == YES) {
        
    
    if ([[[ZPADateHelper sharedHelper]stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"] isEqualToString:[[ZPADateHelper sharedHelper] stringFromDate:cellDate withFormat:@"yyyy-MM-dd"]] ) {
       // cell.backgroundColor = [UIColor darkGrayColor];
        
        
//        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.origin.x+2, cell.frame.origin.y+5, 40, 40)];
//        bgView.backgroundColor = [ZPAStaticHelper zeppaThemeColor];
//        cell.backgroundView = bgView;
        }
    }
	return cell;
	
}

//	We are cheating by piggybacking on view state to avoid recalculation
//	in -collectionView:shouldHighlightItemAtIndexPath:
//	and -collectionView:shouldSelectItemAtIndexPath:.

//	A naïve refactoring process might introduce duplicate state which is bad too.

- (BOOL) collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return ((MFDatePickerDayCell *)[collectionView cellForItemAtIndexPath:indexPath]).enabled;
}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	return ((MFDatePickerDayCell *)[collectionView cellForItemAtIndexPath:indexPath]).enabled;
    
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	MFDatePickerDayCell *cell = ((MFDatePickerDayCell *)[collectionView cellForItemAtIndexPath:indexPath]);
	[self willChangeValueForKey:@"selectedDate"];
	_selectedDate = cell
    ? [self.calendar dateFromComponents:[self dateComponentsFromPickerDate:cell.date]]
    : nil;
	[self didChangeValueForKey:@"selectedDate"];
}

- (void) setSelectedDate:(NSDate *)selectedDate {
	_selectedDate = selectedDate;
	[self.collectionView reloadData];
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
	if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
		
		MFDatePickerMonthHeader *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DFDatePickerViewMonthHeaderIdentifier forIndexPath:indexPath];
		
		NSDateFormatter *dateFormatter = [self.calendar df_dateFormatterNamed:@"calendarMonthHeader" withConstructor:^{
			NSDateFormatter *dateFormatter = [NSDateFormatter new];
			dateFormatter.calendar = self.calendar;
			dateFormatter.dateFormat = [dateFormatter.class dateFormatFromTemplate:@"yyyyLLLL" options:0 locale:[NSLocale currentLocale]];//yyyyLLLL
			return dateFormatter;
		}];
		
		NSDate *formattedDate = [self dateForFirstDayInSection:indexPath.section];
		monthHeader.textLabel.text = [dateFormatter stringFromDate:formattedDate];
		
		return monthHeader;
		
	}
	
	return nil;
    
}

- (NSDate *) dateFromPickerDate:(MFDatePickerDate)dateStruct {
	return [self.calendar dateFromComponents:[self dateComponentsFromPickerDate:dateStruct]];
}

- (NSDateComponents *) dateComponentsFromPickerDate:(MFDatePickerDate)dateStruct {
	NSDateComponents *components = [NSDateComponents new];
	components.year = dateStruct.year;
	components.month = dateStruct.month;
	components.day = dateStruct.day;
	return components;
}

- (MFDatePickerDate) pickerDateFromDate:(NSDate *)date {
	NSDateComponents *components = [self.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
	return (MFDatePickerDate) {
		components.year,
		components.month,
		components.day
        
	};
}

///******************************************************************
#pragma mark RecurrenceEvent
///******************************************************************
-(void)checkRecurrenceRuleWithDay:(long)day andMonth:(long)month andYear:(long)year{
    
    if([ZPAAppData sharedAppData].dicRecurrenceEventsForMonthFlow.count>700){
        [[ZPAAppData sharedAppData].dicRecurrenceEventsForMonthFlow removeAllObjects];
    }
    
    
    for (GTLCalendarEvent *event in [ZPAAppData sharedAppData].arrRecurrenceEvents) {
        
        NSString *freq=nil;
        NSString *byday=nil;
        int interval=1;
        int occurrence=0;
        int until = 0;
        
        NSArray *arr =event.recurrence;
        NSString *rule = [arr firstObject];
        NSArray *rulesArray =[rule componentsSeparatedByString:@";"];
        for (NSString *str in rulesArray) {
            
            if ([str rangeOfString:@"FREQ"].location != NSNotFound) {
                
                freq = [[str componentsSeparatedByString:@"="] lastObject];
            }
            else if ([str rangeOfString:@"INTERVAL"].location != NSNotFound){
                
                interval=[[[str componentsSeparatedByString:@"="] lastObject] intValue];
            }
            else if ([str rangeOfString:@"BYDAY"].location != NSNotFound){
                
                byday = [[str componentsSeparatedByString:@"="] lastObject];
            }
            else if ([str rangeOfString:@"COUNT"].location != NSNotFound){
                
                occurrence =[[[str componentsSeparatedByString:@"="] lastObject] intValue];
            }
            else if ([str rangeOfString:@"UNTIL"].location != NSNotFound){
                
                until =[[[str componentsSeparatedByString:@"="] lastObject] intValue];
            }
            else{
                
            }
        }
        
        
        
        [self accourdingRecurrenceRuleOfOneObjectDay:day andMonth:month andYear:year withFreq:freq withByDay:byday withOccurrence:occurrence withInterval:interval withUntilDate:until withevent:event];
        
    }
    
    
}

-(void)accourdingRecurrenceRuleOfOneObjectDay:(long)day andMonth:(long)month andYear:(long)year withFreq:(NSString *)freq withByDay:(NSString *)byDay withOccurrence:(int)occurrence withInterval:(int)interval withUntilDate:(int )untilDate withevent:(GTLCalendarEvent *)event{
    
    
    
    eventReference=event;
    NSString *untilDateString;
    if(untilDate!=0){
        untilDateString = [NSString stringWithFormat:@"%d-%d-%d",untilDate/10000,(untilDate%10000)/100,(untilDate%100)+1];
    }
    
    //NSDate *endEventDate =[[ZPADateHelper sharedHelper]dateFromString:untilDateString withFormat:@"yyyy-MM-dd"];
    
    
    NSDictionary *dictStartDate = [[event JSON] objectForKey:kZeppaEventsStartDateKey];
    NSString *strStartDateTime = [dictStartDate objectForKey:kZeppaEventsDateTimeKey];
    NSDate *eventStartDate = [[ZPADateHelper sharedHelper]dateFromString:strStartDateTime withFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    
    
    
    
    if ([freq isEqualToString:@"DAILY"]) {
        
        [self dailyRecurrenceEventWithDay:day andMonth:month andYear:year andOccurence:occurrence andInterval:interval andUntilDate:untilDateString withEventStartDate:eventStartDate];
    }
    else if ([freq isEqualToString:@"MONTHLY"]) {
        
        [self monthlyRecurrenceEventWithDay:day andMonth:month andYear:year andOccurence:occurrence andInterval:interval andUntilDate:untilDateString withEventStartDate:eventStartDate];
        
    }
    else if ([freq isEqualToString:@"YEARLY"]) {
        
        [self yearlyRecurrenceEventWithDay:day andMonth:month andYear:year andOccurence:occurrence andInterval:interval andUntilDate:untilDateString withEventStartDate:eventStartDate];
    }
    else{
        ///For Weekly
        
        
        NSArray *arr = [byDay componentsSeparatedByString:@","];
        NSMutableArray *dayArray =[NSMutableArray array];
        for (int i=0; i<arr.count; i++) {
            
            if ([[arr objectAtIndex:i]isEqualToString:@"SU"]){
                [dayArray addObject:@"1"];
                
            }else if ([[arr objectAtIndex:i]isEqualToString:@"MO"]){
                [dayArray addObject:@"2"];
                
            }else if ([[arr objectAtIndex:i]isEqualToString:@"TU"]){
                [dayArray addObject:@"3"];
                
            }else if ([[arr objectAtIndex:i]isEqualToString:@"WE"]){
                [dayArray addObject:@"4"];
                
            }else if ([[arr objectAtIndex:i]isEqualToString:@"TH"]){
                [dayArray addObject:@"5"];
                
            }else if ([[arr objectAtIndex:i]isEqualToString:@"FR"]){
                [dayArray addObject:@"6"];
                
            }else if ([[arr objectAtIndex:i]isEqualToString:@"SA"]){
                [dayArray addObject:@"7"];
                
            }
            
            
        }
        [self makeRecurrenceObjectWithDay:day andMonth:month andYear:year andWeekdayArray:dayArray andOccurence:occurrence andInterval:interval andUntilDate:untilDateString withEventStartDate:eventStartDate];
        
    }
}
-(void)dailyRecurrenceEventWithDay:(long)day andMonth:(long)month andYear:(long)year andOccurence:(int)occurrence andInterval:(int)interval andUntilDate:(NSString *)until  withEventStartDate:(NSDate *)eventStartDate{
    
    NSDateComponents *getDayComponents = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit |NSWeekdayCalendarUnit |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:eventStartDate];
    
    
    NSDate *untilDate =[[ZPADateHelper sharedHelper]dateFromString:until withFormat:@"yyyy-MM-dd"];
    
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setWeekday:getDayComponents.weekday];// set weekday
    [components setHour:getDayComponents.hour];
    [components setMinute:getDayComponents.minute];
    [components setSecond:getDayComponents.second];
     [components setTimeZone:[NSTimeZone localTimeZone]];
    
    for (int i = 1; i <= 12; i++) {
        
        
        if (month>12){
            month-=12;
        }
        [components setMonth:month];
        [components setDay:1];
        
        NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                                          inUnit:NSMonthCalendarUnit forDate:[[NSCalendar currentCalendar]dateFromComponents:components]];
        
        
        ///get no of weeks in month
        // NSRange weekRange = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:[[NSCalendar currentCalendar]dateFromComponents:components]];
        
        
        for (int j=1; j<days.length+1; j++){
            
            
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.year = year;
            dateComponents.month = month;
            dateComponents.day=j;
            [dateComponents setHour:getDayComponents.hour];
            [dateComponents setMinute:getDayComponents.minute];
            [dateComponents setSecond:getDayComponents.second];
            //            dateComponents.weekday = getDayComponents.weekday;
            //            dateComponents.weekdayOrdinal = j;//Nth Sun,Mon,Tue,Wed,Thu,Fri,Sat in Month
            
            dateComponents.timeZone=[NSTimeZone localTimeZone];
            
            
            
            NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
            
            
            if (untilDate && ([untilDate compare:newDate]==NSOrderedAscending || [untilDate compare:newDate]==NSOrderedSame)) {
                
                break;
            }
            
            if ([eventStartDate compare:newDate]==NSOrderedAscending  && dailyDict.count<occurrence-1){
                
                dailyCounter++;
                NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit |NSWeekdayCalendarUnit |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newDate];
               

                if (![dailyDict objectForKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]]) {
                    
                    
                     if (dailyCounter%interval==0) {
                        [dailyDict setObject:eventReference forKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]];
                         [[ZPAAppData sharedAppData].dicRecurrenceEventsForMonthFlow setObject:eventReference forKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]];
                    }
                }
            }
        }
        if (month==12) {
            year++;
            [components setYear:year];
        }
        month++;
    }
    
}
-(void)monthlyRecurrenceEventWithDay:(long)day andMonth:(long)month andYear:(long)year andOccurence:(int)occurrence andInterval:(int)interval andUntilDate:(NSString *)until  withEventStartDate:(NSDate *)eventStartDate{
    
    NSDateComponents *getDayComponents = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit |NSWeekdayCalendarUnit |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond fromDate:eventStartDate];
    
    
    
    NSDate *untilDate =[[ZPADateHelper sharedHelper]dateFromString:until withFormat:@"yyyy-MM-dd"];
    
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setWeekday:getDayComponents.weekday];// Sunday
    [components setHour:getDayComponents.hour];
    [components setMinute:getDayComponents.minute];
    [components setSecond:getDayComponents.second];
    
    for (int i = 1; i <= 12; i++) {
        
        
        if (month>12){
            month-=12;
        }
        [components setMonth:month];
        [components setDay:getDayComponents.day];
        
        
        components.timeZone=[NSTimeZone localTimeZone];
        
        
        
        NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        
        if (untilDate && ([untilDate compare:newDate]==NSOrderedAscending || [untilDate compare:newDate]==NSOrderedSame)) {
            
            break;
        }
        
        if (([eventStartDate compare:newDate]==NSOrderedAscending) && monthlyDict.count<occurrence-1){
            
            monthlyCounter++;
            
            NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit |NSWeekdayCalendarUnit |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newDate];
            
            if (monthlyCounter%interval==0) {
        
            if (![monthlyDict objectForKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]]) {
                [monthlyDict setObject:eventReference forKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]];
                 [[ZPAAppData sharedAppData].dicRecurrenceEventsForMonthFlow setObject:eventReference forKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]];
            }
            
            
            }
            
            
            
        }
        
        if (month==12) {
            year++;
            [components setYear:year];
        }
        month++;
    }
    
    
    
    
}
-(void)yearlyRecurrenceEventWithDay:(long)day andMonth:(long)month andYear:(long)year andOccurence:(int)occurrence andInterval:(int)interval andUntilDate:(NSString *)until  withEventStartDate:(NSDate *)eventStartDate{
    
    
    NSDateComponents *getDayComponents = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit |NSWeekdayCalendarUnit |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond fromDate:eventStartDate];
    
    
    
    
    
    NSDate *untilDate =[[ZPADateHelper sharedHelper]dateFromString:until withFormat:@"yyyy-MM-dd"];
    
    
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setWeekday:getDayComponents.weekday];// Sunday
    [components setHour:getDayComponents.hour];
    [components setMinute:getDayComponents.minute];
    [components setSecond:getDayComponents.second];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    
    for (int i = 1; i <= 12; i++) {
        
        
        if (month>12){
            month-=12;
        }
        [components setMonth:getDayComponents.month];
        [components setDay:getDayComponents.day];
        
        
        
        
        
        NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        
        
        if (untilDate && ([untilDate compare:newDate]==NSOrderedAscending || [untilDate compare:newDate]==NSOrderedSame)) {
            
            break;
        }
        
        if (([eventStartDate compare:newDate]==NSOrderedAscending) && yearDict.count<occurrence-1){
            
            yearlyCounter++;
            NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit |NSWeekdayCalendarUnit |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newDate];
            if (![yearDict objectForKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]]) {
                
                
                if (yearlyCounter%interval==0) {
                    
                
                [yearDict setObject:eventReference forKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]];
                 [[ZPAAppData sharedAppData].dicRecurrenceEventsForMonthFlow setObject:eventReference forKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]];
            }
            
            }
           
            
        }
        if (month==12) {
            year++;
            [components setYear:year];
        }
        month++;
    }
    
}

-(void)makeRecurrenceObjectWithDay:(long)day andMonth:(long)month andYear:(long)year andWeekdayArray:(NSMutableArray *)weekdayArray andOccurence:(int)occurrence andInterval:(int)interval andUntilDate:(NSString *)until  withEventStartDate:(NSDate *)eventStartDate
{
    
    
    NSDateComponents *getDayComponents = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit |NSWeekdayCalendarUnit |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear |NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond fromDate:eventStartDate];
    
    NSDate *untilDate =[[ZPADateHelper sharedHelper]dateFromString:until withFormat:@"yyyy-MM-dd"];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setHour:getDayComponents.hour];
    [components setMinute:getDayComponents.minute];
    [components setSecond:getDayComponents.second];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    
    for (int i = 1; i <= 12; i++) {
        
        
        if (month>12){
            month-=12;
        }
        [components setMonth:month];
        [components setDay:1];
        
        /*NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
         inUnit:NSMonthCalendarUnit
         forDate:[[NSCalendar currentCalendar]dateFromComponents:components]];
         */
        
        ///get no of weeks in month
        NSRange weekRange = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:[[NSCalendar currentCalendar]dateFromComponents:components]];
        
        
        for (int j=1; j<weekRange.length+1; j++){
            weeklyCounter++;
          if(weeklyCounter%interval==0)
            for (int k=0; k<weekdayArray.count; k++) {
                NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                dateComponents.year = year;
                dateComponents.month = month;
                dateComponents.weekday = [[weekdayArray objectAtIndex:k] intValue];
                dateComponents.weekdayOrdinal = j;//Nth Sun,Mon,Tue,Wed,Thu,Fri,Sat in Month
                dateComponents.timeZone =[NSTimeZone localTimeZone];
                
                
                
                NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
                
                
                if (untilDate && ([untilDate compare:newDate]==NSOrderedAscending ||[untilDate compare:newDate]==NSOrderedSame)) {
                    
                    break;
                }
                
                if ([eventStartDate compare:newDate]==NSOrderedAscending  && weeklyDict.count<occurrence-1 ){
                
                   
                    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSWeekOfYearCalendarUnit |NSWeekdayCalendarUnit |NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:newDate];
                    
                   
                        
            
                    if (![weeklyDict objectForKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]]) {
                        [weeklyDict setObject:eventReference forKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]];
                        
                             
                        [[ZPAAppData sharedAppData].dicRecurrenceEventsForMonthFlow setObject:eventReference forKey:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)comps.year,(long)comps.month,(long)comps.day]];
                   
                    
                    }
                    
                    
                }
            }
            
            
            
        }
        if (month==12) {
            year++;
            [components setYear:year];
        }
        month++;
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)syncCalendar:(NSNotification *)notify{
    
    progress = [MBProgressHUD showHUDAddedTo:self.viewForBaselineLayout animated:YES];
    
    [progress show:YES];
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
        
        [self.collectionView reloadData];

        
        [progress hide:YES];
        
    });
}

@end
