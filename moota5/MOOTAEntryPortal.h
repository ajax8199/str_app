//
//  MOOTAEntryPortal.h
//  moota5
//
//  Created by Ajax on 5/22/13.
//  Copyright (c) 2013 eleganceapplications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseObject.h"

@interface MOOTAEntryPortal : UIViewController{

    IBOutlet UILabel *LastWeight;
    IBOutlet UILabel *LastReps;
    IBOutlet UILabel *SuggestedWeight;
    IBOutlet UILabel *SuggestedReps;
    IBOutlet UILabel *ActualWeight;
    IBOutlet UILabel *ActualReps;
    IBOutlet UILabel *ExerciseName;
    //IBOutlet UILabel *repsLabel;
    //IBOutlet UILabel *currentLabel;
    //IBOutlet UILabel *lastLabel;
    //IBOutlet UILabel *goalLabel;
    
    IBOutlet UIPickerView *weightPicker;
    
    IBOutlet UITapGestureRecognizer *tap;
    
    
    IBOutlet UIButton *socialmediabarButton;
    IBOutlet UIButton *picktheweight;
    IBOutlet UIButton *nextExerciseButton;
    IBOutlet UIButton *hitGoal;
    IBOutlet UIButton *subtractRep;
    IBOutlet UIButton *addRep;
    //IBOutlet UIButton *currentRepsButton;
    IBOutlet UIButton *recycleButton;
    IBOutlet UIButton *threeButton;
    IBOutlet UIButton *fiveButton;
    IBOutlet UIButton *eightButton;
    IBOutlet UIButton *twelveButton;
    IBOutlet UIButton *fifteenButton;
    IBOutlet UIButton *twentyfiveButton;
    
    
    
    IBOutlet UIImageView *whiteBehindSocialMedia;
    IBOutlet UIImageView *setNumber;
    IBOutlet UIImageView *topMenuBackground;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIImageView *currentDisplayBackground;
    //IBOutlet UIImageView *curRepsBack;
    //IBOutlet UIImageView *curWeigBack;
    //IBOutlet UIImageView *repsButtonBackground;
    IBOutlet UIImageView *goalrepsBackground;
    IBOutlet UIImageView *weightpickerBorder;
    
    
    UIButton *twitbutton;
    UIButton *facebutton;
    UIImageView *socialBackground;
    
    NSArray *pickerData;
    
    int progressAsInt;
    BOOL socialmenushow;
    
    
}

@property (nonatomic, retain) UIButton *twitbutton;
@property (nonatomic, retain) UIButton *facebutton;
@property (nonatomic, retain) UIImageView *socialBackground;
@property (nonatomic, retain) IBOutlet UIImageView *weightpickerBorder;
//@property (nonatomic, retain) IBOutlet UILabel *goalLabel;
@property (nonatomic, retain) IBOutlet UIImageView *goalrepsBackground;
//@property (nonatomic, retain) IBOutlet UILabel *lastLabel;
//@property (nonatomic, retain) IBOutlet UIImageView *repsButtonBackground;
@property (nonatomic, retain) IBOutlet UIButton *threeButton;
@property (nonatomic, retain) IBOutlet UIButton *fiveButton;
@property (nonatomic, retain) IBOutlet UIButton *eightButton;
@property (nonatomic, retain) IBOutlet UIButton *twelveButton;
@property (nonatomic, retain) IBOutlet UIButton *fifteenButton;
@property (nonatomic, retain) IBOutlet UIButton *twentyfiveButton;
//@property (nonatomic, retain) IBOutlet UILabel *repsLabel;
//@property (nonatomic, retain) IBOutlet UIImageView *curRepsBack;
//@property (nonatomic, retain) IBOutlet UIImageView *curWeigBack;
@property (nonatomic, retain) IBOutlet UIImageView *currentDisplayBackground;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundImage;
//@property (nonatomic, retain) IBOutlet UILabel *currentLabel;
@property (nonatomic, retain) IBOutlet UIImageView *topMenuBackground;
@property (nonatomic, retain) IBOutlet UIImageView *setNumber;
@property (nonatomic, retain) IBOutlet UIButton *recycleButton;
@property (nonatomic, retain) IBOutlet UIImageView *whiteBehindSocialMedia;
@property (nonatomic, retain) IBOutlet UIPickerView *weightPicker;
@property (nonatomic, retain) IBOutlet UIButton *picktheweight;
@property (nonatomic, retain) IBOutlet UIButton *hitGoal;
@property (nonatomic, retain) IBOutlet UIButton *subtractRep;
@property (nonatomic, retain) IBOutlet UIButton *addRep;
//@property (nonatomic, retain) IBOutlet UIButton *currentRepsButton;

@property (nonatomic, retain) IBOutlet UITapGestureRecognizer *tap;


@property (nonatomic, retain) IBOutlet UILabel *LastWeight;
@property (nonatomic, retain) IBOutlet UILabel *LastReps;
@property (nonatomic, retain) IBOutlet UILabel *SuggestedWeight;
@property (nonatomic, retain) IBOutlet UILabel *SuggestedReps;
@property (nonatomic, retain) IBOutlet UILabel *ActualWeight;
@property (nonatomic, retain) IBOutlet UILabel *ActualReps;
@property (nonatomic, retain) IBOutlet UIButton *socialmediabarButton;

@property (nonatomic, retain) IBOutlet UILabel *ExerciseName;
@property (nonatomic, retain) IBOutlet UIButton *nextExerciseButton;




-(void) setUpWorkout:(NSInteger)currentExercise;
-(void) setUpSuggestedInfo:(ExerciseObject*)tmpExercise2;
-(void) saveExercise;
-(void) setUI;

-(IBAction) finishWorkout:(id)sender;
-(IBAction) hitYourGoal:(id)sender;
-(IBAction) summonSocialMenuBar:(id)sender;
-(IBAction) turnonface:(id)sender;
-(IBAction) turnontwit:(id)sender;
-(IBAction) alertmessage:(id)sender;
-(IBAction) nextExercise:(id)sender; // Move on to the next exercise if available
-(IBAction) addRep:(id)sender; // Add a rep (or set reps equal to button)
-(IBAction) subtractRep:(id)sender; //Subtract a rep






@end
