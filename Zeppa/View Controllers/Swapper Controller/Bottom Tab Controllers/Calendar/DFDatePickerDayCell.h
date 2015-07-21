#import <UIKit/UIKit.h>
#import "DayFlow.h"

@interface DFDatePickerDayCell : UICollectionViewCell

@property (nonatomic, readwrite, assign) MFDatePickerDate date;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property(nonatomic,strong)UIView *eventsView;
@property(nonatomic,strong)UIView *baseView;
-(void)removeVerticalView;
@end
