#import <UIKit/UIKit.h>
#import "DayFlow.h"
@interface MFDatePickerDayCell : UICollectionViewCell
@property (nonatomic, readwrite, assign) MFDatePickerDate date;
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property(nonatomic,strong)NSMutableDictionary *EventDateDictionary;
@property (nonatomic, readonly, strong) UIImageView *imageView;
@end
