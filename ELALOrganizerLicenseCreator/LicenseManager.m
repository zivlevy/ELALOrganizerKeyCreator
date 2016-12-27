//
//  LicenseManager.m
//  ELALOrganaizer
//
//  Created by Ziv Levy on 7/28/13.
//  Copyright (c) 2013 Ziv Levy. All rights reserved.
//

#import "LicenseManager.h"
#import "StringEncryption.h"
#import "NSData+Base64.h"
#import "NSDate-Utilities.h"
#import "GlobalConst.h"

@implementation LicenseManager

+(BOOL) isLicenseValid:(NSString *)decryptedLicense
{
    // check that license is Valid
    //check length
    if (decryptedLicense.length!=14) {
        return NO;
    }
    NSString * day = [decryptedLicense substringToIndex:2];
    NSString * month =[decryptedLicense substringWithRange:NSMakeRange (3, 2)];
    NSString * year = [decryptedLicense substringWithRange:NSMakeRange (6, 2)];
    NSString * empID = [decryptedLicense substringWithRange:NSMakeRange (9, 5)];

    //check that all chars are digits
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([[NSString stringWithFormat:@"%@%@%@%@",day,month,year,empID] rangeOfCharacterFromSet:notDigits].location != NSNotFound)
    {
        // not consists only of the digits 0 through 9
        return NO;
    }
    
    // get empID info from user defaults - takes into account that it is 6 digit empID with out the leading "E"
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *storedEmpID = [prefs stringForKey:@"userID"];
    
    // check if empID in storage and license is the same
    BOOL isUser = NO;
    if ([storedEmpID isEqualToString:[NSString stringWithFormat:@"e0%@",empID]]) {
        isUser = YES;
    } 
    
    //return YES only if it's the same user and the license is valid
    return isUser;
}

+(BOOL) isLicenseValidAndUptodate{

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *license = [prefs stringForKey:@"License"];
    
    NSString *  decryptedLicense =[LicenseManager decryptLicense:license];
    
    return [LicenseManager isLicenseValid:decryptedLicense] && [LicenseManager isLicenseUptoDate:decryptedLicense];
}

+(BOOL) isLicenseUptoDate:(NSString *)decryptedLicense
{
    
    if (decryptedLicense.length !=14) {
        return NO;
    }
    NSString * day = [decryptedLicense substringToIndex:2];
    NSString * month =[decryptedLicense substringWithRange:NSMakeRange (3, 2)];
    NSString * year = [decryptedLicense substringWithRange:NSMakeRange (6, 2)];
    
    // convert license to date
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yy"];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    NSDate *licenseValidDate = [df dateFromString:[NSString stringWithFormat:@"%@/%@/%@",day,month,year]];
    
    // check if the license is still valid
    BOOL isDate = [[NSDate date] isEarlierThanDate:licenseValidDate];
    
    return isDate;
}
+ (NSString *) encryptLicense:(NSString *)day month:(NSString *)month year:(NSString*)year empID:(NSString *)empID position:(long)position
{
    //encript request string
    NSString * requestParametersBeforeEncription =[NSString stringWithFormat:@"%@.%@.%@-%@-%li",day,month,year,empID, position];
//    NSString * requestParametersBeforeEncription =[NSString stringWithFormat:@"%@.%@.%@-%@",day,month,year,empID];
	NSString * key = kEncryptionKey;
	
	StringEncryption *crypto = [[StringEncryption alloc] init];
	NSData * secretData = [requestParametersBeforeEncription dataUsingEncoding:NSUTF8StringEncoding];
	CCOptions padding = kCCOptionPKCS7Padding;
	NSData *encryptedData = [crypto encrypt:secretData key:[key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];

    [LicenseManager isLicenseValid:[NSString stringWithFormat:@"%@",[encryptedData base64EncodingWithLineLength:0]]];
    return [NSString stringWithFormat:@"%@",[encryptedData base64EncodingWithLineLength:0]];
}

+(NSString*) decryptLicense:(NSString*) licenseString
{
    NSString * key = kEncryptionKey;
	
	StringEncryption *crypto = [[StringEncryption alloc] init];
    NSData * encriptedData = [NSData dataWithBase64EncodedString:licenseString];
    CCOptions padding = kCCOptionPKCS7Padding;
    NSData *decryptedData = [crypto decrypt:encriptedData key:[key dataUsingEncoding:NSUTF8StringEncoding] padding:&padding];

    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
}

+(NSString *) getValidityString:(NSString *) decryptedLicense
{
    
    if ([LicenseManager isLicenseValid:decryptedLicense]) {
        
        NSString * day = [decryptedLicense substringToIndex:2];
        NSString * month =[decryptedLicense substringWithRange:NSMakeRange (3, 2)];
        NSString * year = [decryptedLicense substringWithRange:NSMakeRange (6, 2)];
        
        if ([LicenseManager isLicenseUptoDate:decryptedLicense]) {
            return [NSString stringWithFormat:@"License is valid until: %@/%@/%@",day,month,year];
        } else {
            return [NSString stringWithFormat:@"License expierd on: %@/%@/%@",day,month,year];
        }
    } else {
        return @"License is not valid !";
    }
}

# pragma mark - Employee ID manager
+(BOOL) isValidEmpID:(NSString *)empID withAlert:(BOOL) withAlert
{
    BOOL isLegalempID = NO;
    if (empID.length >0)
    {
        NSScanner *scanner = [NSScanner scannerWithString:[empID substringFromIndex:1]];
        BOOL  isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if (empID.length==7 && [[empID substringToIndex:1] isEqualToString:@"e"] && isNumeric) {
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

@end
