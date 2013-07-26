//
//  resultsContainerObject.m
//  FiTek
//
//  Created by Jonny Torcivia on 3/30/12.
//  Copyright (c) 2012 Elegance Applications. All rights reserved.
//

#import "resultsContainerObject.h"

@implementation resultsContainerObject

@synthesize day;
@synthesize month;
@synthesize year;
@synthesize volume;

- (id)initWithData:(NSInteger)vol years:(NSInteger)theYear months:(NSInteger)theMonth days:(NSInteger)theDay {
    self.day = [[NSNumber alloc] initWithInt:theDay];
    self.year = [[NSNumber alloc] initWithInt:theYear];
    self.month = [[NSNumber alloc] initWithInt:theMonth];
    self.volume = [[NSNumber alloc] initWithInt:vol];
    
    return self;
}

- (NSComparisonResult)compareYears: (resultsContainerObject*) aYear {
    //return [self.year compare: aYear.year];
    return [aYear.year compare:self.year];
}
- (NSComparisonResult)compareMonths:(resultsContainerObject *)aMonth {
    //return [self.month compare: aMonth.month];
    return [aMonth.month compare:self.month];
}
- (NSComparisonResult)compareDays: (resultsContainerObject*) aDay {
    //    return [self.day compare: aDay.day];
    return [aDay.day compare:self.day];
}

- (int) returnVolume {
    return [self.volume intValue];
}

- (NSString*) returnDate {
    NSString* theDate = [[NSString alloc] initWithFormat:@"%d/%d/%d", [self.month intValue], [self.day intValue], [self.year intValue]];
    return theDate;
}


- (bool)compareObjects:(resultsContainerObject*) nextObj
{
    //NSLog(@"Compare Objects");
    if ([self.year intValue] == [nextObj.year intValue] && [self.month intValue] == [nextObj.month intValue] && [self.day intValue] == [nextObj.day intValue]) {
        return true;
    }
    return false;
}

- (void)addTwoObjects:(resultsContainerObject*) nextObj
{
    //NSLog(@"Add two objects: %d, %d", [self.volume intValue], [nextObj.volume intValue]);
    self.volume = [[NSNumber alloc] initWithInt:[self.volume intValue] + [nextObj.volume intValue]];
    //NSLog(@"Add two objects: %d, %d", [self.volume intValue], [nextObj.volume intValue]);
}

- (void)displayData {
    NSLog(@"Year: %@", self.year);
    NSLog(@"Month: %@", self.month);
    NSLog(@"Day: %@", self.day);
    NSLog(@"Volume: %@", self.volume);
}

@end
