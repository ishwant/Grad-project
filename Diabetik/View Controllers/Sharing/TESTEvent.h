//
//  NSObject+TESTEvent.h
//  Diabetik
//
//  Created by project on 1/11/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TESTEvent : NSObject

@property (nonatomic, strong) NSString * eventName;
@property (nonatomic, strong) NSString * eventAmount;
@property (nonatomic, strong) NSString * eventDate;
@property (nonatomic, strong) NSString * eventNotes;

//Methods

- (id) initWitheventName: (NSString *) eName andeventAmount: (NSString *) eAmount andeventDate: (NSString *) eDate andeventNotes: (NSString *) eNotes;

@end