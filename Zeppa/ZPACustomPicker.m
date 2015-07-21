//
//  PickerView.m
//  jyotish
//
//  Created by Faran on 23/02/15.
//  Copyright (c) 2015 Agicent. All rights reserved.
//

#import "ZPACustomPicker.h"
#define TRANCEPARENT_VIEW_TAG 100

@implementation ZPACustomPicker{
    
    NSString *currentValue;
}

- (void)drawRect:(CGRect)rect {

    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    if(_presentingArray == nil){
        [_presentingArray insertObject:@"Empty arry" atIndex:0];
    }
    
    if (_presentingArray.count>0) {
        currentValue = [_presentingArray objectAtIndex:(int)ceil(_presentingArray.count/2)];
   }
    
   [self.pickerView selectRow:(int)ceil(_presentingArray.count/2) inComponent:0 animated:NO];
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *v=[[UIView alloc]
               initWithFrame:CGRectMake(0,0,
                                        [self pickerView:pickerView widthForComponent:component]+150,
                                        [self pickerView:pickerView rowHeightForComponent:component])];
    [v setOpaque:TRUE];
    [v setBackgroundColor:[UIColor whiteColor]];
    UILabel *lbl=nil;
    lbl= [[UILabel alloc]
          initWithFrame:CGRectMake(0,0,
                                   [self pickerView:pickerView widthForComponent:component]+150,
                                   [self pickerView:pickerView rowHeightForComponent:component])];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor clearColor]];
    NSString *ret=@"";
    ret=[_presentingArray objectAtIndex:row];
    [lbl setText:ret];
    [lbl setFont:[UIFont boldSystemFontOfSize:18]];
    [v addSubview:lbl];
    return v;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    currentValue = [_presentingArray objectAtIndex:row];
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
        return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _presentingArray.count;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    if ([touch view].tag ==  TRANCEPARENT_VIEW_TAG) {
        [self removeFromSuperview];
    }
    
}
- (IBAction)selectBtnTapped:(UIButton *)sender {
    
    [_delegate doneBtnTappedOnCustomPicker:currentValue];
}

- (IBAction)cancelBtnTapped:(UIButton *)sender {
    [self removeFromSuperview];
}
@end
