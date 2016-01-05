//
//  UserProfile.h
//  Diabetik
//
//  Created by project on 11/28/15.
//  Copyright © 2015 UglyApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (strong, nonatomic) NSString *userToken;
@property (strong, nonatomic) NSString *userFName;
@property (strong, nonatomic) NSString *userLName;

#pragma mark -
#pragma mark Class Methods

-(id)initWithuserFName : (NSString *)uFName anduserLName: (NSString *)uLName anduserToken: (NSString *)uToken;

@end
