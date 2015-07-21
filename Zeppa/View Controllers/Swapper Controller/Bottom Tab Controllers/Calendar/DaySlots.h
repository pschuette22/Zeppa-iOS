//
//  DaySlots.h
//  Zeppa
//
//  Created by Dheeraj on 15/10/14.
//  Copyright (c) 2014 Agicent. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EventTappedResponse <NSObject>
@required
-(void)eventButtonTapped:(id)object;
@end

@interface DaySlots : UIView

@property (nonatomic, strong)NSString *strDay;
@property (nonatomic, strong)NSArray *arrEvents;
@property (nonatomic, strong)id<EventTappedResponse> delegate;
-(instancetype)initWithDay:(NSString *)strDay andAllEvents:(NSArray *)arrEvents;
@end
