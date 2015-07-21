#import "MFDatePickerCollectionView.h"

@implementation MFDatePickerCollectionView
@dynamic delegate;

- (void) layoutSubviews {
	
	[self.delegate pickerCollectionViewWillLayoutSubviews:self];
	[super layoutSubviews];
		
}

@end
