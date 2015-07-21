#import <UIKit/UIKit.h>
#import "MFDatePickerView.h"
#import "ZPARevealSplitMenuBaseVC.h"

@class MFDatePickerViewController;
@protocol MFDatePickerViewControllerDelegate

- (void) monthFlowDatePickerViewController:(MFDatePickerViewController *)controller didSelectDate:(NSDate *)date;

@end

@interface MFDatePickerViewController : ZPARevealSplitMenuBaseVC

@property (nonatomic, readonly, strong) MFDatePickerView *datePickerView;
@property (nonatomic, readwrite, weak) id<MFDatePickerViewControllerDelegate> delegate;

@end
