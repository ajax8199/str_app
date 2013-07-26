//
//  resultsContainerObject.h
//  FiTek
//
//  Created by Jonny Torcivia on 3/30/12.
//  Copyright (c) 2012 Elegance Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface resultsContainerObject : NSObject

{
    NSNumber* day;
    NSNumber* month;
    NSNumber* year;
    
    NSNumber* volume;
}

- (NSComparisonResult)compareYears: (resultsContainerObject*) aYear;
- (NSComparisonResult)compareMonths:(resultsContainerObject *)aMonth;
- (NSComparisonResult)compareDays: (resultsContainerObject*) aday;

- (id)initWithData:(NSInteger)vol years:(NSInteger)theYear months:(NSInteger)theMonth days:(NSInteger)theDay;
- (void)displayData;
- (bool)compareObjects:(resultsContainerObject*) nextObj;
- (void)addTwoObjects:(resultsContainerObject*) nextObj;

- (int) returnVolume;
- (NSString*) returnDate;


@property (nonatomic, retain) NSNumber* day;
@property (nonatomic, retain) NSNumber* month;
@property (nonatomic, retain) NSNumber* year;
@property (nonatomic, retain) NSNumber* volume;

@end


