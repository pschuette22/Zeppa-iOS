#import <UIKit/UIKit.h>

@class MFDatePickerCollectionView;
@protocol DFDatePickerCollectionViewDelegate <UICollectionViewDelegate>

- (void) pickerCollectionViewWillLayoutSubviews:(MFDatePickerCollectionView *)pickerCollectionView;

@end

@interface MFDatePickerCollectionView : UICollectionView

@property (nonatomic, assign) id <DFDatePickerCollectionViewDelegate> delegate;

@end
