//
//  DatabaseManager.h
//  StrengthApp
//
//  Created by Jonny Torcivia on 11/18/11.
//  Copyright (c) 2011 Elegance Applications. All rights reserved.
//
//                  --===||| DatabaseManager class |||===--
//********************************************************************************
//*
//* This class checks to see if the database name passed in has been created.
//* If not, it attempts to create the basic data version of the SQL database from
//* the included files.
//*
//********************************************************************************

#import <Foundation/Foundation.h>
#import "SQLiteManager.h"
#import "sqlite3.h"



@interface DatabaseManager : NSObject{
	NSString *databaseName; //!< String representing the database name.
	NSString *databasePath; //!< String representing the database path in the file system.
    
    SQLiteManager *dbManager;  // The database manager.  This is a generated class of SQLiteManager
}

// Set Up Singleton
+(id) sharedDatabaseManager;

/*!
 * Verify the database passed in as an argument exists
 */

-(void) verify:(NSString*)database;
-(BOOL) checkAndCreateDatabase;
-(void) rewriteDatabase;

/*!
 * Functions which return various times.
 */
-(NSString*) returnLocalDay;
-(NSString*) returnLocalMonth;
-(NSString*) returnLocalYear;
-(NSString*) returnLocalTime;
-(NSDate*) returnLocalTimeNSDate;



/*
-(void) saveExerciseData:(ExerciseObject*)exercise;
-(void) sendCreateTableSQL:(NSString*)stmt;
-(void) addRowToTable:(NSString*)stmt;
*/

@end
