//
//  EasingsList.m
//  cocos2d easing actions
//
//  Created by Kirill Muzykov on 12/05/14.
//  Copyright (c) 2014 Kirill Muzykov. All rights reserved.
//

#import "EasingsList.h"
#import "EasingDemo.h"

@implementation EasingsList
{
    NSDictionary *_easings;
    int _currentEasing;
}

#define kItemHeight 44

-(instancetype)init
{
    if (self = [super init])
    {
        [self fillEasingsDictionary];
        
        CCTableView* tableView = [[CCTableView alloc] init];
        tableView.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitInsetUIPoints);
        tableView.contentSize = CGSizeMake(1, kItemHeight);
        tableView.rowHeight = kItemHeight;
        tableView.rowHeightUnit = CCSizeUnitUIPoints;
        tableView.dataSource = self;
        
        [self addChild:tableView];
        
        [tableView setTarget:self selector:@selector(selectedRow:)];
    }
    
    return self;
}


-(void)fillEasingsDictionary
{
    _easings = @{@"CCActionEaseBackIn": [CCActionEaseBackIn class],
                 @"CCActionEaseBackInOut": [CCActionEaseBackInOut class],
                 @"CCActionEaseBackOut": [CCActionEaseBackOut class],
                 @"CCActionEaseBounce": [CCActionEaseBounce class],
                 @"CCActionEaseBounceIn": [CCActionEaseBounceIn class],
                 @"CCActionEaseBounceInOut": [CCActionEaseBounceInOut class],
                 @"CCActionEaseBounceOut": [CCActionEaseBounceOut class],
                 @"CCActionEaseElastic": [CCActionEaseElastic class],
                 @"CCActionEaseElasticIn": [CCActionEaseElasticIn class],
                 @"CCActionEaseElasticInOut": [CCActionEaseElasticInOut class],
                 @"CCActionEaseElasticOut": [CCActionEaseElasticOut class],
                 @"CCActionEaseIn": [CCActionEaseIn class],
                 @"CCActionEaseInOut": [CCActionEaseInOut class],
                 @"CCActionEaseInstant": [CCActionEaseInstant class],
                 @"CCActionEaseOut": [CCActionEaseOut class],
                 @"CCActionEaseRate": [CCActionEaseRate class],
                 @"CCActionEaseSineIn": [CCActionEaseSineIn class],
                 @"CCActionEaseSineInOut": [CCActionEaseSineInOut class],
                 @"CCActionEaseSineOut": [CCActionEaseSineOut class]
                 };
}

- (CCTableViewCell*) tableView:(CCTableView*)tableView nodeForRowAtIndex:(NSUInteger) index
{
    CCTableViewCell* cell = [[CCTableViewCell alloc] init];
    cell.contentSizeType = CCSizeTypeMake(CCSizeUnitNormalized, CCSizeUnitUIPoints);
    cell.contentSize = CGSizeMake(1, kItemHeight);
    
    NSString *easingName = [[_easings allKeys] objectAtIndex:index];
    CCLabelTTF *label = [CCLabelTTF labelWithString:easingName fontName:@"HelveticaNeue" fontSize:kItemHeight * 0.4f];
    label.positionType = CCPositionTypeMake(CCPositionUnitUIPoints, CCPositionUnitNormalized, CCPositionReferenceCornerBottomLeft);
    label.position = ccp(20, 0.5f);
    label.anchorPoint = ccp(0, 0.5f);

    [cell addChild:label];
    return cell;
}

- (NSUInteger) tableViewNumberOfRows:(CCTableView*) tableView
{
    return [_easings allKeys].count;
}

- (void) selectedRow:(id)sender
{
    CCTableView* tableView = sender;
    NSString *easingName = [[_easings allKeys] objectAtIndex:tableView.selectedRow];
    Class easingClass = [_easings objectForKey:easingName];
    
    EasingDemo *easingDemo = [[EasingDemo alloc] initWithEasingClass:easingClass andName:easingName];
    [[CCDirector sharedDirector] pushScene:easingDemo];
}

@end
