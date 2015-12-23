//
//  UserProfile.m
//  Diabetik
//
//  Created by project on 11/28/15.
//  Copyright © 2015 UglyApps. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
@synthesize userId, userName, userPassword;

-(id)initWithUserName : (NSString *)uName anduserPassword: (NSString *)uPass anduserID : (NSString *)uID
{
    self = [super init];
    if(self)
    {
        userId = uID;
        userName = uName;
        userPassword = uPass;
    }
    return self;
}

@end
