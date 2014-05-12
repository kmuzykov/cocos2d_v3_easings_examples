//
//  Easings.m
//  cocos2d easing actions
//
//  Created by Kirill Muzykov on 12/05/14.
//  Copyright (c) 2014 Kirill Muzykov. All rights reserved.
//

#import "EasingDemo.h"
#import "cocos2d.h"
#import "cocos2d-ui.h"

#define kMoveTime   3.0f

@implementation EasingDemo
{
    CGPoint _graphOrigin;
    CGPoint _dotStartPos;
    CGPoint _dotEndPos;
    
    float _axisLength;
    float _dotRadius;
    
    CCDrawNode *_point;
    CCDrawNode *_trajectory;
    CCLabelTTF *_easingName;
    
    BOOL _drawTrajectory;
    float _timeRunning;
    CGPoint _prevPoint;
    
    Class _currentEasing;
}

-(instancetype)initWithEasingClass:(Class)easingClass andName:(NSString *)easingName
{
    if (self = [super init])
    {
        [self calculatePoints];
        [self createMovablePoint];
        [self drawAxis];
        [self setupTrajectoryDrawing];

        [self displayEasingName:easingName];
        _currentEasing = easingClass;
        
        [self addBackButton];
    }
    
    return self;
}

-(void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];

    [self runEasing:_currentEasing];
}

-(void)calculatePoints
{
    _graphOrigin = ccp(80.0f, 160.0f);
    _axisLength = 160.0f;
    
    _dotRadius = 8.0f;
    _dotStartPos = ccpAdd(_graphOrigin, ccp(_axisLength + _dotRadius, 0));
    _dotEndPos = ccpAdd(_dotStartPos, ccp(0, _axisLength));
}

-(void)createMovablePoint
{
    _point = [CCDrawNode node];
    [_point drawDot:CGPointZero radius:_dotRadius color:[CCColor redColor]];
    _point.position = _dotStartPos;
    [self addChild:_point];
}

-(void)setupTrajectoryDrawing
{
    _drawTrajectory = YES;
    _timeRunning = 0;
    
    _trajectory = [CCDrawNode node];
    _trajectory.position = _graphOrigin;
    [self addChild:_trajectory];
}

-(void)drawAxis
{
    CCDrawNode *axis = [CCDrawNode node];
    CGPoint axisPoints[3] = {ccp(0, _axisLength), ccp(0, 0), ccp(_axisLength, 0)};
    
    [axis drawSegmentFrom:axisPoints[0] to:axisPoints[1] radius:2.0 color:[CCColor whiteColor]];
    [axis drawSegmentFrom:axisPoints[1] to:axisPoints[2] radius:2.0 color:[CCColor whiteColor]];
    axis.position = _graphOrigin;
    [self addChild:axis];
    
    CCLabelTTF *time = [CCLabelTTF labelWithString:@"time" fontName:@"Helvetica" fontSize:12];
    time.anchorPoint = ccp(1.0f, 1.2f);
    time.position = ccpAdd(_graphOrigin, axisPoints[2]);
    [self addChild:time];
    
    CCLabelTTF *delta = [CCLabelTTF labelWithString:@"delta" fontName:@"Helvetica" fontSize:12];
    delta.anchorPoint = ccp(1.2f, 1.0f);
    delta.position = ccpAdd(_graphOrigin,axisPoints[0]);
    [self addChild:delta];
}

-(void)resetTrajectory
{
    [_trajectory clear];
    _drawTrajectory = YES;
    _timeRunning = 0;
    _prevPoint = CGPointZero;
}

-(void)runEasing:(Class)easingClass
{
    [self resetTrajectory];

    //Returning point to inital position and stopping current action.
    [_point stopAllActions];
    _point.position = _dotStartPos;
    
    CCActionMoveTo *move = [CCActionMoveTo actionWithDuration:kMoveTime position:_dotEndPos];
    //id easedAction = [easingClass actionWithAction:move];
    
    id easedAction;
    if  ([easingClass isSubclassOfClass:[CCActionEaseRate class]])
        easedAction  = [easingClass actionWithAction:move rate:2.0f];
    else
        easedAction  = [easingClass actionWithAction:move];
    
    [_point runAction:easedAction];
    
    CCActionCallBlock *stopTrajectory = [CCActionCallBlock actionWithBlock:^{
        _drawTrajectory = NO;
    }];

    CCActionSequence *sequence = [CCActionSequence actions:easedAction,stopTrajectory, nil];
    
    //Note: Uncomment the code below to repeat the action forever (trajectory is drawn only once)
    //CCActionDelay *delayAtTheStart = [CCActionDelay actionWithDuration:1.0f];
    //CCActionDelay *delayInTheEnd = [CCActionDelay actionWithDuration:1.0f];
    
    //    CCActionCallBlock *returnToStart = [CCActionCallBlock actionWithBlock:^{
    //        _point.position = _dotStartPos;
    //    }];

    //CCActionSequence *sequence = [CCActionSequence actions:easedAction,stopTrajectory, delayInTheEnd,returnToStart,delayAtTheStart, nil];
    //CCActionRepeatForever *repeatForever = [CCActionRepeatForever actionWithAction:sequence];
    
    [_point runAction:sequence];
}

-(void)update:(CCTime)dt
{
    if (_drawTrajectory)
    {
        float position = _point.position.y - _graphOrigin.y;
        _timeRunning += dt;
        float percentTime = (_timeRunning/kMoveTime) * _axisLength;
        
        CGPoint newPoint = ccp(percentTime, position);
        
        [_trajectory drawSegmentFrom:_prevPoint to:newPoint radius:1.0f color:[CCColor greenColor]];
        _prevPoint = newPoint;
    }
}

-(void)displayEasingName:(NSString *)easingName
{
    _easingName = [CCLabelTTF labelWithString:easingName fontName:@"Helvetica" fontSize:22];
    _easingName.positionType = CCPositionTypeNormalized;
    _easingName.position = ccp(0.5f, 0.9f);
    [self addChild:_easingName];
}

-(void)addBackButton
{
    CCButton *btnBack = [CCButton buttonWithTitle:@"Back" fontName:@"Helvetica" fontSize:18];
    btnBack.positionType = CCPositionTypeNormalized;
    btnBack.position = ccp(0.5f, 0.2f);
    [self addChild:btnBack];
    
    btnBack.block = ^(id sender){
        [[CCDirector sharedDirector] popScene];
    };
}

@end
