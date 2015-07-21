//
//  ZPAAddEventVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 08/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Checkbox.h"



@interface ZPAAddEventVC : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_base;
@property (weak, nonatomic) IBOutlet UIView *view_baseTitleAndLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtEventTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtEventLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblMapAddress;
@property (weak, nonatomic) IBOutlet UIView *view_baseBelowLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblDescriptionPlaceholder;
@property (weak, nonatomic) IBOutlet UITextView *textView_Description;
@property (weak, nonatomic) IBOutlet UIView *view_baseEventTimeAndPrivacy;
@property (weak, nonatomic) IBOutlet UIView *view_baseStartTime;
@property (weak, nonatomic) IBOutlet UIView *view_baseEndTime;
@property (weak, nonatomic) IBOutlet UIView *view_basePrivacy;
@property (weak, nonatomic) IBOutlet UILabel *lblEventStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEventEndTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEventPrivacy;
@property (weak, nonatomic) IBOutlet UIView *view_TagsContainer;
@property (weak, nonatomic) IBOutlet UITextField *txtNewTag;
@property (weak, nonatomic) IBOutlet UIView *view_baseTagsFeature;
@property (weak, nonatomic) IBOutlet UIButton *btnAddNewTag;
@property (weak, nonatomic) IBOutlet UIView *view_TagLine;
@property (weak, nonatomic) IBOutlet UIView *view_baseAddInvites;
@property (weak, nonatomic) IBOutlet UIButton *btnAddNewInvitesTapped;
@property (weak, nonatomic) IBOutlet UILabel *lbl_noOfInvites;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet Checkbox *checkBox;
@property NSMutableArray *eventTagIdsArray;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtnTapped;

- (IBAction)doneBtnTapped:(UIBarButtonItem *)sender;
- (IBAction)btnMapLocationTapped:(UIButton *)sender;

- (IBAction)btnSelectEventStartTimeTapped:(id)sender;
- (IBAction)btnSelectEventEndTimeTapped:(id)sender;
- (IBAction)btnSelectEventPrivacyTapped:(id)sender;
- (IBAction)btnAddNewTagTapped:(id)sender;
- (IBAction)cancelBtnTapped:(UIBarButtonItem *)sender;

- (IBAction)addInviteesBtn:(UIButton *)sender;

@end
