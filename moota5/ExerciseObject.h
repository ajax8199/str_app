//
//  ExerciseObject.h
//  StrengthApp
//
//  Created by Jonny Torcivia on 11/18/11.
//  Copyright (c) 2011 Elegance Applications. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseObject : NSObject {
    
    // Exercise information Variables
    NSString *exName;
    NSString *exDescription;
    NSInteger exID;
    
    NSInteger currentReps;
    float currentWeight;
    
    // Sets variables
    NSInteger currentSet;
    NSInteger recSets;
    
    // Reps Variables
    NSInteger exReps;
    NSInteger exDefReps;
    NSInteger exLastReps;
    
    // Weight Variables    
    float exWeight;
    float exDefWeight;
    float exLastWeight;
    
    // Group and Muscle
    NSInteger group;
    NSInteger muscle;
    
    NSString *lastDatePerformed;
    
    NSInteger exLastVolume;
    float totalVolume;
    
    bool cable, barbell, dumbbell, lever, gym, spotter, difficulty, familiarity;

}

//+(id) sharedExerciseObject;
-(id) initWithDictionary:(NSDictionary*)dict;

//
// Set Methods
//
-(void) setExerciseReps:(NSInteger)reps;
-(void) setExerciseWeight:(float)weight;
-(void) setExerciseID:(NSInteger)ident;
-(void) setLastReps:(NSInteger)lreps;
-(void) setLastWeight:(float)lweight;
-(void) setGroup:(NSInteger)grp;
-(void) setMuscle:(NSInteger)mscl;
-(void) setRecSets:(NSInteger)rsets;
-(void) setCurrentWeight:(float)curWeight;
-(void) setCurrentReps:(NSInteger)curReps;

-(void) increaseCurrentExerciseReps:(NSInteger)curRepIncrease;
-(void) decreaseCurrentExerciseReps:(NSInteger)curRepDecrease;

-(NSInteger) returnCurrentReps;
-(float) returnCurrentWeight;

-(void) increaseSetNumber;

//
// Get Methods
//
-(NSInteger) returnID;
-(NSString*) returnName;
-(NSInteger) returnReps;
-(NSInteger) returnLastReps;
-(NSInteger) returnDefReps;
-(float) returnWeight;
-(float) returnLastWeight;
-(float) returnDefWeight;
-(NSString*) returnLastDatePerformed;
-(NSInteger) returnCurrentVolume;
-(NSInteger) returnCurrentSet;
-(float) returnTotalVolume;
-(NSInteger) returnGroup;
-(NSInteger) returnMuscle;
-(NSInteger) returnReccomendedSets;


-(void) increaseTotalVolume:(float)addVolume;

//-(NSInteger) returnExerciseSetNumber;
//-(NSInteger) returnLastSets;
//-(NSInteger) returnLastVolume;
//-(void) setExerciseName:(NSString*)exerName;

@end
