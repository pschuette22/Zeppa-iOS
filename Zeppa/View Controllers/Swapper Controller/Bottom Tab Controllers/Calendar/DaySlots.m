//
//  DaySlots.m
//  Zeppa
//
//  Created by Dheeraj on 15/10/14.
//  Copyright (c) 2014 Agicent. All rights reserved.
//

#import "DaySlots.h"
#import "ZPAAppData.h"
#import "ZPADateHelper.h"
#import "ZPAEventDetailVC.h"
#import "ZPAZeppaEventSingleton.h"


@implementation DaySlots
{
    
    UIButton *eventVerticalView;
    NSMutableArray *slotArray;
    NSMutableArray *allDayEventFrameArray;
    NSMutableArray *verticalViewArray;
    NSMutableArray *finalArray;
    int count;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithDay:(NSString *)strDay andAllEvents:(NSArray *)arrEvents
{
    
    if (self = [super init]) {
        
        self.strDay = strDay;
        self.arrEvents = arrEvents;
        self.frame=CGRectMake(0,0, 320,1700);
        self.backgroundColor=[UIColor clearColor];
        // self.backgroundColor=[UIColor greenColor];
        slotArray=[[NSMutableArray alloc]init];
        allDayEventFrameArray=[[NSMutableArray alloc]init];
        verticalViewArray =[[NSMutableArray alloc]init];
        finalArray=[[NSMutableArray alloc]init];
        for (ZPAEvent *event in arrEvents) {
            int year = [[[[[ZPADateHelper sharedHelper] stringFromDate:event.startDateTime withFormat:@"yyyy-MM-dd"]componentsSeparatedByString:@"-"] objectAtIndex:0] intValue];
            int month = [[[[[ZPADateHelper sharedHelper] stringFromDate:event.startDateTime withFormat:@"yyyy-MM-dd"]componentsSeparatedByString:@"-"] objectAtIndex:1] intValue];
            int day = [[[[[ZPADateHelper sharedHelper] stringFromDate:event.startDateTime withFormat:@"yyyy-MM-dd"]componentsSeparatedByString:@"-"] objectAtIndex:2] intValue];
            int startDateHour = [[[[[ZPADateHelper sharedHelper] stringFromDate:event.startDateTime withFormat:@"HH:mm:ss"]componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
            int startDateMint = [[[[[ZPADateHelper sharedHelper] stringFromDate:event.startDateTime withFormat:@"HH:mm:ss"]componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
            int endDateHour = [[[[[ZPADateHelper sharedHelper] stringFromDate:event.endDateTime withFormat:@"HH:mm:ss"]componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
            int endDateMint = [[[[[ZPADateHelper sharedHelper] stringFromDate:event.endDateTime withFormat:@"HH:mm:ss"]componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
            if ([[[strDay componentsSeparatedByString:@"-"]objectAtIndex:0] intValue]==year && [[[strDay componentsSeparatedByString:@"-"]objectAtIndex:1] intValue]==month && [[[strDay componentsSeparatedByString:@"-"]objectAtIndex:2] intValue]==day) {
                if(event.eventType==CalendarEventTypeGoogle){
                    GTLCalendarEvent *eventGoogle =(GTLCalendarEvent *)event.event;
                    NSString *title = eventGoogle.summary;
                    NSString *decription =eventGoogle.location;
                    
                    
                    if (decription == nil || decription == (id)[NSNull null]) {
                        decription=@"";
                    }
                    if (event.isAllDay) {
                        [self addSubview:[self eventViewShowWithHour:startDateHour minute:startDateMint durationWithHours:23 durationMinuter:50 withTitle:title andDescription:decription]];
                    }else{
                        [self addSubview:[self eventViewShowWithHour:startDateHour minute:startDateMint durationWithHours:abs((endDateHour-startDateHour) )durationMinuter:(endDateMint-startDateMint) withTitle:title andDescription:decription]];
                    }
                }else if (event.eventType==CalendarEventTypeiOS){
                    EKEvent *ekEvent=(EKEvent *)event.event;
                    NSString *title = ekEvent.title;
                    NSString *decription =ekEvent.location;
                    if (decription == nil || decription == (id)[NSNull null]) {
                        decription=@"";
                    }
                    if (event.isAllDay) {
                        [self addSubview:[self eventViewShowWithHour:startDateHour minute:startDateMint durationWithHours:23 durationMinuter:50 withTitle:title andDescription:decription]];
                    }else{
                        [self addSubview:[self eventViewShowWithHour:startDateHour minute:startDateMint durationWithHours:abs((endDateHour-startDateHour) )durationMinuter:(endDateMint-startDateMint) withTitle:title andDescription:decription]];
                    }
                    
                }
                
            }
            
            
        }
        
        [self checkCondition];
    }
    return self;
    
}
//-(NSMutableArray *)sortArray:(NSMutableArray *)arr bySortDescriptorKey:(NSString *)key withAscendingOrder:(BOOL)value
//{
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:value];
//    //     NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
//
//    [arr sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
//
//    return arr;
//
//}
-(UIView *)eventViewShowWithHour:(NSInteger)hour minute:(NSInteger)mint durationWithHours:(NSInteger)durationHours durationMinuter:(NSInteger)durationMinute withTitle:(NSString *)title andDescription:(NSString *)description
{
    ///if user can't set endtime or duration then it willbe set 1 hour.(it's default duration)
    if (durationHours==0) {
        durationHours=1;
    }
    float height =((hour)*(self.frame.size.height/24)+(mint*(self.frame.size.height/24)/60))+5;
    float newDurationMinute=(durationMinute*(self.frame.size.height/23)/60);
    eventVerticalView=[[UIButton alloc]init];
    eventVerticalView.backgroundColor=[UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:0.2];
    eventVerticalView.frame=CGRectMake(55, height, 265, (self.frame.size.height/24)*durationHours+newDurationMinute);
    [eventVerticalView addTarget:self action:@selector(eventVerticalViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor colorWithRed:33/255.0 green:142/255.0 blue:217/255.0 alpha:1.0] CGColor];
    upperBorder.frame = CGRectMake(0, 0, 3.0f,CGRectGetHeight(eventVerticalView.frame));
    [eventVerticalView.layer addSublayer:upperBorder];
    eventVerticalView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    eventVerticalView.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    eventVerticalView.titleLabel.numberOfLines=3;
    eventVerticalView.titleLabel.font=[UIFont fontWithName:@"Helvetica" size:14];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",title,description]];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:14] range:NSMakeRange(title.length,description.length+1)];
    [eventVerticalView setAttributedTitle:string forState:UIControlStateNormal];
    [eventVerticalView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [verticalViewArray addObject:eventVerticalView];
    return eventVerticalView;
}
-(void)checkCondition{
    for (int k=0; k<verticalViewArray.count; k++) {
        
        if ([[verticalViewArray objectAtIndex:k] frame].origin.y<12) {
            
            
            [allDayEventFrameArray addObject:[verticalViewArray objectAtIndex:k]];
        }
    }
    
    if (verticalViewArray.count!=0 &&[[verticalViewArray objectAtIndex:0] frame].origin.y<12) {
        
        [self isAllDayEvent];
        
    }else if(verticalViewArray.count!=0){
        
        [self everyDayEvent];
    }
}

-(void)isAllDayEvent{
    
    
    NSMutableArray *temp =[[NSMutableArray alloc]init];
    for (int i=0; i<verticalViewArray.count; i++){
        for (int j=0; j<allDayEventFrameArray.count; j++) {
            [temp addObject:[allDayEventFrameArray objectAtIndex:j]];
        }
        for (NSInteger k=allDayEventFrameArray.count; k<verticalViewArray.count; k++) {
            UIView *view1=(UIView *)[temp lastObject];
            UIView *view2 =(UIView *)[verticalViewArray objectAtIndex:k];
            if (view2.frame.origin.y>=view1.frame.origin.y && view2.frame.origin.y<=view1.frame.origin.y+view1.frame.size.height) {
//                if ([[verticalViewArray objectAtIndex:k] tag]==0) {
//                    [temp addObject:view2];
//                    [[verticalViewArray objectAtIndex:k] setTag:1];
//                }
            }
        }
        [self makeFramewithArrayWithAllDayEvent:temp];
        [temp removeAllObjects];
    }
    [self updateFrame];
}
-(void)everyDayEvent{
    
    
    NSMutableArray *temp =[[NSMutableArray alloc]init];
    for (int i=0; i<verticalViewArray.count; i++){
        UIView  *view = [verticalViewArray objectAtIndex:i];
        [temp addObject:view];
        for (int j=i+1; j<verticalViewArray.count; j++) {
            UIView *view1=(UIView *)[temp lastObject];
            UIView *view2 =(UIView *)[verticalViewArray objectAtIndex:j];
            if (view2.frame.origin.y>=view1.frame.origin.y && view2.frame.origin.y<=view1.frame.origin.y+view1.frame.size.height) {
//                if ([[verticalViewArray objectAtIndex:j] tag]==0) {
//                    [temp addObject:view2];
//                    [[verticalViewArray objectAtIndex:j] setTag:1];
//                }
            }
        }
        [self makeFramewithArray:temp];
        [temp removeAllObjects];
    }
}
-(void)makeFramewithArrayWithAllDayEvent:(NSMutableArray *)array{
    
    float width=265/array.count;
    
    if (array.count>allDayEventFrameArray.count) {
        [slotArray addObject:[array mutableCopy]];
        for (int i=0; i<array.count; i++) {
            UIView *view =[array objectAtIndex:i];
            view.frame=CGRectMake(i*width+55, view.frame.origin.y, width, view.frame.size.height);
        }
    }
}

-(void)makeFramewithArray:(NSMutableArray *)array{
    
    float width=265/array.count;
    if (array.count>1) {
        for (int i=0; i<array.count; i++) {
            UIView *view =[array objectAtIndex:i];
            view.frame=CGRectMake(i*width+55, view.frame.origin.y, width, view.frame.size.height);
        }
    }
}
-(void)updateFrame{
    
    int maxSlotNo=0;
    if (slotArray.count!=0) {
        
        for (NSInteger k=0; k<slotArray.count; k++) {
            NSMutableArray * arr =[slotArray objectAtIndex:k];
            maxSlotNo=MAX(maxSlotNo, (int)arr.count);
        }
        
        
        for (int k=0; k<slotArray.count; k++) {
            NSMutableArray * arr =[slotArray objectAtIndex:k];
            float width =265/maxSlotNo;
            
            for (int j=0; j<allDayEventFrameArray.count; j++) {
                UIButton *view =[arr objectAtIndex:j];
                view.frame=CGRectMake(width*j+55, view.frame.origin.y,width, view.frame.size.height);
            }
            
            float availableWidth =(265-allDayEventFrameArray.count*width)/(arr.count-allDayEventFrameArray.count);
            for (NSInteger l=allDayEventFrameArray.count; l<arr.count; l++) {
                UIButton *view =[arr objectAtIndex:l];
                view.frame=CGRectMake(width*l+55, view.frame.origin.y, availableWidth, view.frame.size.height);
                
                
            }
        }
    }else{
        float width =265/allDayEventFrameArray.count;
        for (int l=0; l<allDayEventFrameArray.count; l++) {
            UIButton *view =[allDayEventFrameArray objectAtIndex:l];
            view.frame=CGRectMake(width*l+55, view.frame.origin.y, width, view.frame.size.height);
        }
        
    }
}
-(void)eventVerticalViewTapped:(UIButton *)sender{

    UILabel *label;
    
    
    NSString *str=[NSString stringWithFormat:@"%.2f",(sender.frame.origin.y+85)/70];
    NSArray *arr=[str componentsSeparatedByString:@"."];
    int hour=[[arr firstObject] intValue];
    int mint =(([[arr lastObject] intValue]*60)/100);
    [ZPALogHelper log:[NSString stringWithFormat:@"%d",hour] fromClass:self];
    [ZPALogHelper log:[NSString stringWithFormat:@"%d",mint] fromClass:self];

    for (UIView *view in sender.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            label =(UILabel *)view;
            [ZPALogHelper log:label.text fromClass:self];

        }
    }
    
    NSString *eventTitle = [[label.text componentsSeparatedByString:@"\n"]firstObject];
    
    
    for (ZPAMyZeppaEvent *zeppaEvent in [ZPAZeppaEventSingleton sharedObject].zeppaEvents) {
        if ([zeppaEvent.event.title isEqualToString:eventTitle]) {
            [[ZPAAppDelegate sharedObject].swapperClassRef eventButtonTapped:zeppaEvent];
        }
    }
    
    
    
    
    
        
}
@end
