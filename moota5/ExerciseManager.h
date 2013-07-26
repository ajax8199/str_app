//
//  ExerciseManager.h
//  StrengthApp
//
//  Created by Jonny Torcivia on 11/18/11.
//  Copyright (c) 2011 Elegance Applications. All rights reserved.
//
//  Selects and returns the weight training exercises for the trainee.

#import <Foundation/Foundation.h>
#import "SQLiteManager.h"

@class ExerciseObject;

@interface ExerciseManager : NSObject {
    // Database strings
	NSString *databaseName;
	NSString *databasePath;
    
    SQLiteManager *dbManager;  // The database manager
    SQLiteManager *resultsManager; // The results database
    NSMutableArray *workoutExercises; // The array of exercise objects that make up the determined workout
    NSInteger exerciseNumber;
    NSArray *combinedExercises;
}

// Set Up Singleton
+(id) sharedExerciseManager;

//
// Set Methods
//
-(void) setUpWorkout;
-(void) selectExercises:(NSInteger)workoutTarget;
-(void) setNewUpperBodyWorkout;
-(void) setNewLowerBodyWorkout;
-(void) setNewCoreWorkout;
-(void) setNewFullBodyWorkout;
-(void) setDatabase;
-(void) setExerciseNumber:(NSInteger)exNumber;

-(void) pullExercise:(int)group selMuscle:(int)muscle;
-(void) pullExercisebyID:(NSInteger)exerciseIDNumber;
-(void) updateExerciseReps:(NSInteger) reps;
-(void) updateExerciseWeight:(float) weight;

//
// Return Methods
//
-(NSMutableArray*) returnExercises;
-(ExerciseObject*) returnSpecificExercise:(NSInteger)exerciseIndex;
-(NSInteger) returnExerciseNumber;
-(NSInteger) returnNumberOfExercises;
-(NSInteger) returnExerciseID;

-(NSString*) returnLocalDay;
-(NSString*) returnLocalMonth;
-(NSString*) returnLocalYear;

-(NSArray*) returnCulmativeResults:(NSInteger) workoutGroup specificMuscle:(NSInteger)muscleGroup;

-(void) combineLikeExercises;
-(NSArray*) returnCombinedExercises;

-(void) swapExercise;

-(NSString*) returnExerciseHelp;


@end
