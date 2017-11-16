//
//  SSGameSession.h
//  SecretSpy
//
//  Created by User on 11/6/17.
//  Copyright © 2017 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSPlayer.h"


@interface SSGameSession : NSObject

@property (nonatomic, readonly) NSUInteger spyCount;
@property (nonatomic, readonly) NSMutableArray <SSPlayer *> *players;
@property (nonatomic, readonly) NSString *placeWord;
@property (nonatomic, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSUInteger currentPlayerIndex;
@property (nonatomic) NSUInteger timeInterval;


- (NSString *)nextWord;

- (instancetype)initWithPlayersCount:(NSUInteger)playersCount spyCount:(NSUInteger)spyCount timeInMinutes:(NSUInteger)time;

- (void)startTimer;

- (void)pouseGame;

- (NSArray *)finishGame;

- (NSArray *)results;

@end
