#import "MFDatePickerViewController.h"

@implementation MFDatePickerViewController
@synthesize datePickerView = _datePickerView;

- (void) viewDidLoad {
	[super viewDidLoad];
    
//    NSLog(@"MFDate Picker VC Bounds = %@",NSStringFromCGRect(self.view.bounds));
    
    ///Resize frame to adjust bottom tab bar height
    float bottomTabHeight = 50.0f;
    CGRect viewBounds = self.view.bounds;
    viewBounds.size.height -= bottomTabHeight;
    self.view.bounds = viewBounds;

    //    NSLog(@"MFDate Picker VC New Bounds = %@",NSStringFromCGRect(self.view.bounds));
    
	[self.view addSubview:self.datePickerView];
    
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    self.title = NSLocalizedString(@"Calendar", nil);

}

- (MFDatePickerView *) datePickerView {
	if (!_datePickerView) {
		_datePickerView = [MFDatePickerView new];
        _datePickerView.frame = self.view.bounds;
        
        
//		 _datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	}
	return _datePickerView;
}

- (void) viewDidAppear:(BOOL)animated {
    
	[super viewDidAppear:animated];
	[self addObserver:self forKeyPath:@"datePickerView.selectedDate" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:(void *)self];
    
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self removeObserver:self forKeyPath:@"datePickerView.selectedDate" context:(void *)self];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"datePickerView.selectedDate"]) {
		NSDate *toDate = change[NSKeyValueChangeNewKey];
		if ([toDate isKindOfClass:[NSDate class]]) {
			//	toDate might be NSNull
			[self.delegate monthFlowDatePickerViewController:self didSelectDate:toDate];
		}
	}
}

@end
