//
//  PickerView.h
//  jyotish
//
//  Created by Faran on 23/02/15.
//  Copyright (c) 2015 Agicent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerDelegate <NSObject>

-(void)doneBtnTappedOnCustomPicker:(NSString *)string;

@end
@interface ZPACustomPicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong,nonatomic)id<CustomPickerDelegate>delegate;
@property (strong, nonatomic)NSMutableArray *presentingArray;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *pickerTitleLbl;
- (IBAction)selectBtnTapped:(UIButton *)sender;
- (IBAction)cancelBtnTapped:(UIButton *)sender;

@end
