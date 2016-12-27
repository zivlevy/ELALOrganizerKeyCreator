//
//  GlobalConst.h
//  FlightOrganaizer
//
//  Created by Ziv Levy on 3/21/13.
//  Copyright (c) 2013 Ziv Levy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBaseURL @"http://84.94.182.244:81/organizerservices/service.asmx"


//flight view

#define kFlightBarColor [helpers r:76 g: 91 b:206 alpha:1.0]
#define kOpenFlightBarColor [helpers r:182 g: 18 b:18 alpha:1.0]
#define KConnectingBarColor [helpers r:18 g: 18 b:18 alpha:0.5]
#define kDeadHeadLabelColor [helpers r:0 g: 149 b:59 alpha:1.0]
#define kStbyBarColor [helpers r:255 g:122 b:122 alpha:1.0]
#define kStbyImmBarColor [helpers r:255 g:100 b:10 alpha:1.0]

//about
#define kSupportEmail @"koren.yuval@gmail.com"
@interface GlobalConst : NSObject

//encryption key
#define kEncryptionKey @"1234567891123456"

@end
