#import <UIKit/UIKit.h>

@interface MFDatePickerView : UIView

- (instancetype) initWithCalendar:(NSCalendar *)calendar;

@property (nonatomic, readwrite, strong) NSDate *selectedDate;
@end
