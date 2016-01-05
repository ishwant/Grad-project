//
//  UserProfile.m
//  Diabetik
//
//  Created by project on 11/28/15.
//  Copyright © 2015 UglyApps. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
@synthesize userToken, userFName, userLName;

-(id)initWithuserFName : (NSString *)uFName anduserLName: (NSString *)uLName anduserToken: (NSString *)uToken
{
    self = [super init];
    if(self)
    {
        userFName = uFName;
        userLName = uLName;
        userToken = uToken;
    }
    return self;
}

@end
