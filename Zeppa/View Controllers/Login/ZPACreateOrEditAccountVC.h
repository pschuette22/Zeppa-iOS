//
//  ZPACreateOrEditAccountVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 29/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//



typedef enum {
    
    VCDisplayModeCreateAccount,
    VCDisplayModeEditAccount
    
}VCDisplayMode;

@protocol ZPACreateOrEditAccountVCDelegate <NSObject>

@optional
-(void)didFinishCreatingNewUser:(ZPAMyZeppaUser *)user;
-(void)didFinishUpdatingUser:(ZPAMyZeppaUser *)user;

@end


@interface ZPACreateOrEditAccountVC : UIViewController

@property (nonatomic, strong)ZPAMyZeppaUser *user;

///VCDisplayMode enum type to distinuish between create or edit mode
@property (nonatomic, assign)VCDisplayMode vcDisplayMode;

@property (nonatomic, assign)id<ZPACreateOrEditAccountVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_Loading;
@property (weak, nonatomic) IBOutlet UITextField *giveName_Txt;
@property (weak, nonatomic) IBOutlet UITextField *familyName_Txt;
@property (weak, nonatomic) IBOutlet UITextField *contactNo_Txt;
@property (weak, nonatomic) IBOutlet UITextField *email_Txt;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIView *view_TagContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;


- (IBAction)btnCancelTapped:(UIBarButtonItem *)sender;
- (IBAction)btnDoneTapped:(UIBarButtonItem *)sender;

@end
