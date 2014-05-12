//
//  AppDelegate.m
//  cocos2d easing actions
//
//  Created by Kirill Muzykov on 12/05/14.
//  Copyright Kirill Muzykov 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "AppDelegate.h"
#import "EasingsList.h"

@implementation AppDelegate

// 
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self setupCocos2dWithOptions:@{
		CCSetupShowDebugStats: @(NO),
		CCSetupScreenOrientation: CCScreenOrientationPortrait,
	}];
	
	return YES;
}

-(CCScene *)startScene
{
	//Displaying list of all possible easing actions.
	return [EasingsList node];
}

@end
