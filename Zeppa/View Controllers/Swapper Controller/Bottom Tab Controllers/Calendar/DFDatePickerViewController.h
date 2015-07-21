#import <UIKit/UIKit.h>
#import "DFDatePickerView.h"
#import "ZPARevealSplitMenuBaseVC.h"
#import "DaySlots.h"
//@class DFDatePickerViewController;
//@protocol DFDatePickerViewControllerDelegate
//
//- (void) dayFlowDatePickerViewController:(DFDatePickerViewController *)controller didSelectDate:(NSDate *)date;
//
//@end

@interface DFDatePickerViewController : ZPARevealSplitMenuBaseVC <EventTappedResponse>

@property (nonatomic, readonly, strong) DFDatePickerView *datePickerView;
//@property (nonatomic, readwrite, weak) id<DFDatePickerViewControllerDelegate> delegate;
@property (nonatomic, readwrite, strong) NSDate *date;
+(NSDate *)presentDate;
@end
