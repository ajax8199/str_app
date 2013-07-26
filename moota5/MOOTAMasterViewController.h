//
//  MOOTAMasterViewController.h
//  moota5
//
//  Created by Ajax on 5/22/13.
//  Copyright (c) 2013 eleganceapplications. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOOTAMasterViewController : UIViewController {
    IBOutlet UIButton *coreWorkout;
    IBOutlet UIButton *upperWorkout;
    IBOutlet UIButton *lowerWorkout;
    IBOutlet UIButton *fullWorkout;
    
    IBOutlet UIButton *tourbutton;
    IBOutlet UIButton *settingsbutton;
}

//@property (nonatomic, retain) IBOutlet UIButton *tourbutton;
//@property (nonatomic, retain) IBOutlet UIButton *settingsbutton;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
//@property (nonatomic, retain) IBOutlet UIButton *coreWorkout;
//@property (nonatomic, retain) IBOutlet UIButton *upperWorkout;
//@property (nonatomic, retain) IBOutlet UIButton *lowerWorkout;
//@property (nonatomic, retain) IBOutlet UIButton *fullWorkout;

-(IBAction)getaworkoutUpper:(id)sender;
-(IBAction)getaworkoutLower:(id)sender;
-(IBAction)getaworkoutCore:(id)sender;
-(IBAction)getaworkoutFull:(id)sender;

@end
