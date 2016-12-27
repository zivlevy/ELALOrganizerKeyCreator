//
//  LicenseViewController.m
//  ELALOrganaizer
//
//  Created by Ziv Levy on 7/28/13.
//  Copyright (c) 2013 Ziv Levy. All rights reserved.
//

#import "LicenseViewController.h"
#import "LicenseManager.h"
#import "helpers.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface LicenseViewController ()<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtDay;
@property (weak, nonatomic) IBOutlet UITextField *txtMonth;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtEmpID;
@property (weak, nonatomic) IBOutlet UITextField *txtEncrypted;
@property (weak, nonatomic) IBOutlet UIButton *btnEncrypt;
@property (weak, nonatomic) IBOutlet UIButton *btnMail;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segPosition;

@property (weak, nonatomic) IBOutlet UILabel *lblLicense;

@end

@implementation LicenseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [helpers createColoredButton:self.btnEncrypt color:@"orangeButton"];
    [helpers createColoredButton:self.btnMail color:@"greenButton"];
    self.btnMail.enabled=false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)encrypt:(id)sender {
    // clears fields
    self.txtEncrypted.text = @"";
    self.lblLicense.text=@"";
    self.btnMail.enabled = false;
    
    //check that emp ID is legal
    if (![self isValidEmpID:self.txtEmpID.text withAlert:true]) {
        return;
    }
    //check that date is legal
    if (![self isDigit:self.txtDay.text] || [self.txtDay.text intValue]<1 || [self.txtDay.text intValue]>31 || self.txtDay.text.length!=2)
    {
        [self dateErrorMessage:@"Day"];
        return;
    }
    if (![self isDigit:self.txtMonth.text] || [self.txtMonth.text intValue]<1 || [self.txtMonth.text intValue]>12 || self.txtMonth.text.length!=2)
    {
        [self dateErrorMessage:@"Month"];
        return;
    }
    if (![self isDigit:self.txtYear.text] || [self.txtYear.text intValue]<14 || [self.txtYear.text intValue]>99 || self.txtYear.text.length!=2)
    {
        [self dateErrorMessage:@"Year"];
        return;
    }
    
    
    //encrypt
     self.txtEncrypted.text = [LicenseManager encryptLicense:self.txtDay.text month:self.txtMonth.text year:self.txtYear.text empID:self.txtEmpID.text position:_segPosition.selectedSegmentIndex+1];
    //set lable
    self.lblLicense.text = [LicenseManager decryptLicense:self.txtEncrypted.text];
    //copy to clipboard
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.txtEncrypted.text;
    
    self.btnMail.enabled = true;
}
- (IBAction)btnMail_clicked:(id)sender {
    //check that there is license
    
    //send mail
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"ELAL Organizer license"];
    [controller setMessageBody:[NSString stringWithFormat:@"Your ELALOrganizer License no is: \n \n %@ \n \n The license is valid until %@/%@/%@ \n Enjoy, \n The ELALOrganizer team.", self.txtEncrypted.text, self.txtDay.text,self.txtMonth.text,self.txtYear.text] isHTML:false];
    
    if (controller)
        [self presentViewController:controller animated:YES completion:^{
            
        }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(BOOL) isValidEmpID:(NSString *)empID withAlert:(BOOL) withAlert
{
    BOOL isLegalempID = NO;
    if (empID.length >0)
    {
        NSScanner *scanner = [NSScanner scannerWithString:[empID substringFromIndex:0]];
        BOOL  isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if (empID.length==5 && isNumeric) {
            isLegalempID=YES;
        }
    }
    if (!isLegalempID && withAlert) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Employee ID has an error - try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    return YES;
}

-(BOOL) isDigit:(NSString *)str
{
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:str];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    if (!valid) // Not numeric
        return false;
    return true;
}

-(void) dateErrorMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@ has an error - try again.", message] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end
