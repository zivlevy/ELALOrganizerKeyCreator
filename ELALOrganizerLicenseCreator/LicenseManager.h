//
//  LicenseManager.h
//  ELALOrganaizer
//
//  Created by Ziv Levy on 7/28/13.
//  Copyright (c) 2013 Ziv Levy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LicenseManager : NSObject

+(BOOL) isLicenseValidAndUptodate; // check if the stored license is valid
+(BOOL) isLicenseValid:(NSString *)licenseString;
+(BOOL) isLicenseUptoDate:(NSString *)decryptedLicense;
+ (NSString *) encryptLicense:(NSString *)day month:(NSString *)month year:(NSString*)year empID:(NSString *)empID position:(long)position;
+(NSString *) decryptLicense:(NSString*) licenseString;
+(NSString *) getValidityString:(NSString *) licenseString;

+(BOOL) isValidEmpID:(NSString *)empID withAlert:(BOOL) withAlert; //checks that Employee ID is valid
@end
