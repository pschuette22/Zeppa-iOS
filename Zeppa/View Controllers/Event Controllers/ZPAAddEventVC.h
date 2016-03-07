//
//  ZPAAddEventVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 08/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checkbox.h"



@interface ZPAAddEventVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

// Main View Bases
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_base;
@property (weak, nonatomic) IBOutlet UIView *view_contentView;
@property (weak, nonatomic) IBOutlet UIView *view_infoBaseView;
@property (weak, nonatomic) IBOutlet UIView *view_TagsContainer;
@property (weak, nonatomic) IBOutlet UIView *view_addTagBase;
@property (weak, nonatomic) IBOutlet UIView *view_baseAddInvites;


@property (weak, nonatomic) IBOutlet UITextField *txtEventTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtEventLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textView_Description;
@property (weak, nonatomic) IBOutlet UIView *view_baseStartTime;
@property (weak, nonatomic) IBOutlet UIView *view_baseEndTime;
@property (weak, nonatomic) IBOutlet UIView *view_basePrivacy;
@property (weak, nonatomic) IBOutlet UILabel *lblEventStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEventEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEventPrivacy;
@property (weak, nonatomic) IBOutlet UITextField *txtNewTag;
@property (weak, nonatomic) IBOutlet UIButton *btnAddNewTag;
@property (weak, nonatomic) IBOutlet UIView *view_TagLine;
@property (weak, nonatomic) IBOutlet UIButton *btnAddNewInvitesTapped;
@property (weak, nonatomic) IBOutlet UILabel *lbl_noOfInvites;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet Checkbox *checkBox;

// Privacy picker views and constraints
@property (weak, nonatomic) IBOutlet UIPickerView *privacyPicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privacyPickerHeight;
@property (weak, nonatomic) IBOutlet UIView *view_privacyBase;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privacyBaseHeight;

// Start Time picker views and constraints
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startPickerHeight;
@property (weak, nonatomic) IBOutlet UIView *view_startTimeBase;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBaseHeight;


// End time picker views and constraints
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endPickerHeight;
@property (weak, nonatomic) IBOutlet UIView *view_endTimeBase;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endBaseHeight;


@property NSMutableArray *eventTagIdsArray;


- (IBAction)doneBtnTapped:(UIBarButtonItem *)sender;
// - (IBAction)btnMapLocationTapped:(UIButton *)sender;


- (IBAction) btnSelectLocationTapped:(id)sender;
- (IBAction) btnSelectEventStartTimeTapped:(id)sender;
- (IBAction) btnSelectEventEndTimeTapped:(id)sender;
- (IBAction) btnSelectEventPrivacyTapped:(id)sender;
- (IBAction) btnAddNewTagTapped:(id)sender;

- (IBAction)addInviteesBtn:(UIButton *)sender;
- (IBAction)newButtonAction:(UIButton *)sender;

@end
