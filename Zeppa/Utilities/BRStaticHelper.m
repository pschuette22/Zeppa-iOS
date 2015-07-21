//
//  BRStaticHelper.m
//  Bravo
//
//  Created by Dheeraj on 23/12/14.
//  Copyright (c) 2014 Agicent. All rights reserved.
//

#import "BRStaticHelper.h"
//#import "Reachability.h"

@implementation BRStaticHelper{
    

    ///All Variable is used to maintain ContextoffSet.
    UIView *containerBaseView;
    NSInteger currentTag;
    NSInteger preTag;
    NSInteger nextTag;

    
}
+(BRStaticHelper *)sharedObject{
  
    static BRStaticHelper *object;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        object =[[BRStaticHelper alloc]init];
    });
    return object;
}
//****************************************************
#pragma mark - ContentOffsect Method
//****************************************************
-(void)setContentOffSetof:(id)view insideInView:(id)baseView withLastFieldTagValue:(NSInteger)lastTag
{
    containerBaseView = baseView;
    UIView *tempView = view;
    currentTag = tempView.tag;
    preTag = tempView.tag-1;
    nextTag = tempView.tag+1;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIToolbar *keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 35)];
    
    keyboardToolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *previous=[[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousTextField)];
    
    if (tempView.tag==1) {
        [previous setEnabled:NO ];
        
    }
    UIBarButtonItem*next=[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField)];
    
    if (tempView.tag==lastTag) {
        [next setEnabled:NO ];
        
    }
    
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                previous,next,
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                
                                nil]];
    if ([tempView isKindOfClass:[UITextField class]]) {
        
        UITextField *textField = (UITextField *)tempView;
        textField.inputAccessoryView = keyboardToolBar;
    }
    if ([tempView isKindOfClass:[UITextView class]]) {
        
        
        UITextView *textView = (UITextView *)tempView;
        textView.inputAccessoryView = keyboardToolBar;
    }
    
        
    NSInteger contentValue;
    
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        contentValue = 120;
    }else{
        
        contentValue = 30;
    }
    CGRect rect = [view bounds];
    rect = [view convertRect:rect toView:baseView];
    CGPoint point = rect.origin ;
    point.x = 0;
    if (point.y>contentValue) {
        point.y-= contentValue;
        [baseView setContentOffset:point animated:YES];
    }
}
- (void)nextTextField {
    
    UITextField *textFieldCurrent = (UITextField*)[containerBaseView viewWithTag:currentTag];
    UITextField *textFieldNext = (UITextField*)[containerBaseView viewWithTag:nextTag];
    [textFieldCurrent resignFirstResponder];
    [textFieldNext becomeFirstResponder];
}
-(void)previousTextField
{
    UITextField *textFieldCurrent = (UITextField*)[containerBaseView viewWithTag:currentTag];
    UITextField *textFieldPrevious = (UITextField*)[containerBaseView viewWithTag:preTag];
    [textFieldCurrent resignFirstResponder];
    [textFieldPrevious becomeFirstResponder];
}
-(void)resignKeyboard {
    
    UIScrollView *scrollView = (UIScrollView *)containerBaseView;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSInteger distance = scrollView.contentOffset.y+screenRect.size.height-scrollView.contentSize.height;
    if (distance>0) {
        CGPoint newPoint = CGPointMake(scrollView.contentOffset.x,scrollView.contentOffset.y-distance);
        [scrollView setContentOffset:newPoint animated:YES];
    }
    [scrollView endEditing:YES];
}
//****************************************************
#pragma mark - checkAllFieldHasValue Method
//****************************************************
+(BOOL)checkAllFieldHasValue:(NSString *)firstArg, ...{
    
    if ([firstArg isEqualToString:@""] || [firstArg isEqualToString:@"Select"]) {
        
        return YES;
    }
    va_list args;
    va_start(args, firstArg);
    id arg = nil;
    
    while ((arg = va_arg(args,id))) {
        
        if ([arg isEqualToString:@""] || [arg isEqualToString:@"Select"]) {
            return YES;
        }
        
    }
    va_end(args);
    return NO;
}//****************************************************
#pragma mark - CheckEmptyTextField Method
//****************************************************
+(BOOL)checkEmptyTextField:(UITextField *)firstArg, ...
{
    if([firstArg.text isEqualToString:@""] || [firstArg.text isEqualToString:@"Select"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@" Please Enter %@",firstArg.placeholder] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [ alert show];
        return YES;

    }
    va_list args;
    va_start(args, firstArg);
    UITextField *arg=nil;
    
    while ((arg = va_arg(args, id))) //for (UITextField *arg = firstArg; arg != nil; arg = va_arg(args, UITextField*))
    {
        //UITextField *arg1=(UITextField *)arg;
        if([arg.text isEqualToString:@""] || [arg.text isEqualToString:@"Select"])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@" Please Enter %@",arg.placeholder] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [ alert show];
            return YES;
        }
    }
    va_end(args);
    return NO;
    
}

////****************************************************
//#pragma mark - Reachability Method
////****************************************************
//
//+ (BOOL)isInternetConnected
//{
//    
//    Reachability *internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
//    
//    NetworkStatus status = [internetReachableFoo currentReachabilityStatus];
//    
//    
//    switch (status) {
//        case NotReachable:
//            return NO;
//            break;
//            
//        case ReachableViaWiFi:
//            return YES;
//            break;
//            
//        case ReachableViaWWAN:
//            return YES;
//            break;
//            
//        default:
//            break;
//    }
//    return YES;
//}
@end
