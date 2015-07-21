//
//  ZPAReportEventVC.h
//  Zeppa
//
//  Created by Dheeraj on 12/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPARepostEventVC : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Base;

//This view contains location and title field
@property (weak, nonatomic) IBOutlet UIView *view_baseTitleAndLocation;

//This view Contains all field except location and title field
@property (weak, nonatomic) IBOutlet UIView *view_baseBelowLocation;
@property (weak, nonatomic) IBOutlet UIView *view_baseEventAndTime;

//This is decription textView
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

//For category tag, Button to add new Tag
@property (weak, nonatomic) IBOutlet UIButton *btn_addNewTag;
@property (weak, nonatomic) IBOutlet UITextField *txt_NewTag;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *view_baseTagsFeature;

@property (weak, nonatomic) IBOutlet UIView *view_TagContainer;
@property (weak, nonatomic) IBOutlet UIView *view_baseInvites;

- (IBAction)addButtonTapped:(UIButton *)sender;

@end
