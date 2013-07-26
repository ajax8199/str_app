//
//  TraineeManager.h
//  StrengthApp
//
//  Created by Jonny Torcivia on 11/18/11.
//  Copyright (c) 2011 William & Mary Law. All rights reserved.
//
//  Records and saves the Trainee preferences, settings, and exercises completed.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "sqlite3.h"

@class ExerciseDetails;
@class ExerciseObject;
@class SQLiteManager;

@interface TraineeManager : NSObject {
    NSString *databaseName;
	NSString *databasePath;
    SQLiteManager *dbManager;  // The database manager
    
    //SQLiteManager *resultsManager; // The results database
    //NSInteger exerciseNumber;

    
    NSMutableArray *workoutExercises; // The array of exercise objects that make up the determined workout
    
    NSArray *combinedExercises; // Probably not needed with core data...
    
    //Information on current exercise
    ExerciseObject *CurrentExercise;
    NSInteger CurrentExerciseIndex;
    
    NSInteger WorkoutType;

    // Workout options
    
    bool Tech_Circuit;
    bool Tech_HIIT;
    bool Tech_Supersets;
    
    // Workout amenities
    
       
    bool haveGym;   // Access to a standard equiped gym 
                    // haveGym flag will set Barbell, Dumbbell, Lever, and Cable to true.  
    bool Barbell;   // Access to barbell weights (standard set)
    bool Dumbbell;  // Access to dumbbell weights (standard set)
    bool Lever;     // Access to a series of standard weight equipment (such as nautilus, etc.)
    bool Spotter;   // Have a spotter/workout partner
    bool Cable;     // Access to a typical gym cable system
    
    bool twitter;   // Sharing with twitter, on/off
    bool facebook;  // Sharing with facebook on/off
    
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


+(id) sharedTraineeManager;

-(void)setFacebook:(BOOL)fb;
-(void)setTwitter:(BOOL)tw;
-(BOOL)returnFacebook;
-(BOOL)returnTwitter;
-(bool)defineWorkout:(NSMutableArray*) excerciseList wrkType:(NSInteger)workoutType;


//-(void)setManagedObjectCtx:(NSManagedObjectContext *)managedObjectContextPtr;

-(NSArray*)returnLastWorkoutofType:(NSInteger) exerciseType;

-(ExerciseObject*) pullExercisebyID:(NSInteger)exerciseIDNumber;
-(ExerciseObject*) returnCurrentExercise;
-(ExerciseObject*) returnExercise: (NSInteger) indx;
-(NSMutableArray*) returnWorkout;

-(void) loadNewExercise:(ExerciseObject*)exercise;
-(void) clearExercises;
-(void) setWorkoutType:(NSInteger)workoutType;

-(void) generateWorkout:(NSInteger)workoutType;

-(void) saveExercise;
-(BOOL) moveToNextExercise;
-(BOOL) checkLastRepsWeight;

//-(void) generateWorkout:(NSInteger)workoutType saveContext:(NSManagedObjectContext*)managedContext;

-(NSInteger) returnWorkoutType;
-(void) setGym:(bool)gymBool;

-(NSString*) returnSQLString;
-(NSString*) dataFilePath;
-(NSDictionary*) returnOptions;

-(void) setInitialOptions;
-(bool) checkifchecked:(NSString*)optn;

-(void) changeOption:(NSString*)optn YESorNO:(bool)optnbool;

@end
