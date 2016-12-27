//
//  LicenseViewController.h
//  ELALOrganaizer
//
//  Created by Ziv Levy on 7/28/13.
//  Copyright (c) 2013 Ziv Levy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenseViewController : UIViewController
-(BOOL) isValidEmpID:(NSString *)empID withAlert:(BOOL) withAlert;  
@end
