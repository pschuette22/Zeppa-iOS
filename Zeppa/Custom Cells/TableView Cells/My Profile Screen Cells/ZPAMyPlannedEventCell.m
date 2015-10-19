//
//  ZPAMyPlannedEventCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 28/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAMyPlannedEventCell.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPAZeppaEventSingleton.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"

@implementation ZPAMyPlannedEventCell

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
    self.view_BasePlannedEvent.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.view_BasePlannedEvent.layer.borderWidth = 1.0f;
    
    self.imageView_EventHostProfilePic.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.imageView_EventHostProfilePic.layer.borderWidth = 1.0f;
    self.imageView_EventHostProfilePic.layer.cornerRadius = 5.0f;
    self.imageView_EventHostProfilePic.layer.masksToBounds = YES;
    
}
-(void)configureCellUsingZeppaEvent:(ZPAMyZeppaEvent *)zeppaEvent{
    
    
    ZPAMyZeppaUser *user = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[zeppaEvent.event.hostId longLongValue]];
    
    NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
    [_imageView_EventHostProfilePic setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    _lblEventHostName.text = [NSString stringWithFormat:@"%@ %@",user.endPointUser.userInfo.givenName,user.endPointUser.userInfo.familyName];
    _lblEventTitle.text = zeppaEvent.event.title;
   // _imageView_ConflictIndicator = zeppaEvent.;
    NSString * durationString = [[ZPADateHelper sharedHelper]getEventTimeDuration:zeppaEvent.event.start withEndTime:zeppaEvent.event.end];
    
    _lblEventDescription.text = zeppaEvent.event.descriptionProperty;
    [_btnEventDuration setTitle:durationString forState:UIControlStateNormal];
    
    [_btnEventLocation setTitle:zeppaEvent.event.displayLocation forState:UIControlStateNormal];
    
   // [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_ConflictIndicator];
    
    _imageView_ConflictIndicator.image = [UIImage imageNamed:@"small_circle_blue.png"];
}

/////**********************************************
//#pragma mark - Private Methods
/////**********************************************
//-(NSString *)changeTimeAndFindTimeInterval:(NSNumber *)inputTime{
//    
//    NSTimeInterval interval;
//    NSString * timeToDisplayString;
//    
//    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
//    
//    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
//    
//    [dateformate setDateFormat:@"dd/MM/YYYY"];
//    
//    NSString * todayStr= [dateformate stringFromDate:[NSDate date]];
//    
//    NSString * tommorowStr = [dateformate stringFromDate:tomorrow];
//    
//    long long currentTimeInMills = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
//    
//    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentTimeInMills/1000];
//    
//    
//    double inputChangedTime = [inputTime doubleValue];
//    
//    
//    NSDate * inputDate = [NSDate dateWithTimeIntervalSince1970:inputChangedTime/1000];
//    
//    NSDate *inputTempDate = [[ZPADateHelper sharedHelper]dateFromDate:inputDate withFormat:@"yyyy-MM-dd HH:mm"];
//    
//    NSDate *currTempDate = [[ZPADateHelper sharedHelper]dateFromDate:currentDate withFormat:@"yyyy-MM-dd HH:mm"];
//    
//    NSString *inputStr = [dateformate stringFromDate:inputDate];
//    
//    //NSString *endDateStr= [[ZPADateHelper sharedHelper]stringFromDate:endDate withFormat:@"dd-MM-yyyy hh:mm a"];
//    
//    interval = [currTempDate timeIntervalSinceDate:inputTempDate];
//    int hours = (int)interval / 3600;
//    int minutes = (interval - (hours*3600)) / 60;
//    
//    minutes = minutes + (hours*60);
//    
//    if ([inputStr isEqualToString:todayStr]) {
//        
//        if (minutes >=0 ) {
//            
//            if (minutes<1) {
//                timeToDisplayString = [NSString stringWithFormat:@"Right Now"];
//            }else if (minutes<3){
//                timeToDisplayString = [NSString stringWithFormat:@"A few moments ago"];
//            }else if (minutes<30){
//                timeToDisplayString = [NSString stringWithFormat:@"%d minutes ago",minutes];
//            }else{
//                timeToDisplayString = [[ZPADateHelper sharedHelper]stringFromDate:inputDate withFormat:@" hh:mm a"];
//            }
//            
//        }else{
//            minutes *= -1;
//            if (minutes<1) {
//                timeToDisplayString = [NSString stringWithFormat:@"Right Now"];
//            }else if (minutes<3){
//                timeToDisplayString = [NSString stringWithFormat:@"A few moments from now"];
//            }else if (minutes<30){
//                timeToDisplayString = [NSString stringWithFormat:@"%d minutes from now",minutes];
//            }else{
//                timeToDisplayString = [[ZPADateHelper sharedHelper]stringFromDate:inputDate withFormat:@" hh:mm a"];
//            }
//        }
//    }else if([inputStr isEqualToString:tommorowStr]){
//        
//        timeToDisplayString = [NSString stringWithFormat:@"Tomorrow %@",[[ZPADateHelper sharedHelper]stringFromDate:inputDate withFormat:@"hh:mm a"]];
//        
//    }else{
//        timeToDisplayString = [[ZPADateHelper sharedHelper]stringFromDate:inputDate withFormat:@"MM/dd/yyyy hh:mm a"];
//    }
//     return timeToDisplayString;
//}
//-(void)setConflictIndicatorOnImageView:(UIImageView *)image{
//    
//    if (relationship.getIsAttending().booleanValue()) {
//        conflictStatus = ConflictStatus.ATTENDING;
//        setConflictImageDrawable(image);
//        return;
//    } else if (conflictStatus != ConflictStatus.UNKNOWN) {
//        setConflictImageDrawable(image);
//    } else {
//        image.setVisibility(View.GONE);
//    }
//    
//    new DetermineAndSetConflictStatus(context, image).execute();
//    
//}
//
//private void setConflictImageDrawable(ImageView image) {
//    switch (conflictStatus.ordinal()) {
//        case 0:
//            image.setImageResource(R.drawable.conflict_blue);
//            break;
//        case 1:
//            image.setImageResource(R.drawable.conflict_green);
//            break;
//        case 2:
//            image.setImageResource(R.drawable.conflict_yellow);
//            break;
//        case 3:
//            image.setImageResource(R.drawable.conflict_red);
//            break;
//        default:
//            image.setVisibility(View.GONE);
//            return;
//    }
//    
//    image.setVisibility(View.VISIBLE);
//}
@end
