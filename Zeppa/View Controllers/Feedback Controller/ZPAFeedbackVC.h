//
//  ZPAFeedbackVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPARevealSplitMenuBaseVC.h"

@interface ZPAFeedbackVC : ZPARevealSplitMenuBaseVC<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Base;
@property (weak, nonatomic) IBOutlet UILabel *lblDialogBubble;
@property (weak, nonatomic) IBOutlet UIView *view_StarRatingBackgroundFiller;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_RatingStars;
@property (weak, nonatomic) IBOutlet UISlider *slider_StarRating;
@property (weak, nonatomic) IBOutlet UIButton *btnFeedback;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *txtView_Comment;
@property (weak, nonatomic) IBOutlet UIView *view_SubjectContainer;
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
- (IBAction)btnRateZeppaTapped:(UIButton *)sender;
- (IBAction)rateZeppaSliderValueChanged:(id)sender;
- (IBAction)btnSendFeedbackTapped:(id)sender;

@end
