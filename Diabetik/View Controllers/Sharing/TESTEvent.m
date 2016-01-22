//
//  NSObject+TESTEvent.m
//  Diabetik
//
//  Created by project on 1/11/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "TESTEvent.h"

@implementation TESTEvent
@synthesize eventAmount, eventDate, eventName, eventNotes;

- (id) initWitheventName: (NSString *) eName andeventAmount: (NSString *) eAmount andeventDate: (NSString *) eDate andeventNotes: (NSString *) eNotes
{
    self = [super init];
    if (self)
    {
        eventName = eName;
        eventAmount = eAmount;
        eventDate = eDate;
        eventNotes = eNotes;
    }
    
    return self;
}

@end

