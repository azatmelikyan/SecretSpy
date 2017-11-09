//
//  SSGameSession.m
//  SecretSpy
//
//  Created by User on 11/6/17.
//  Copyright © 2017 User. All rights reserved.
//

#import "SSGameSession.h"

@interface SSGameSession ()

@property (nonatomic, readwrite) NSUInteger spyCount;
@property (nonatomic, readwrite) NSMutableArray <SSPlayer *> *players;
@property (nonatomic, readwrite) NSString *placeWord;
@property (nonatomic, readwrite) NSDate *startTime;
@property (nonatomic, readwrite) NSUInteger currentPlayerIndex;
@property (nonatomic, readwrite) NSUInteger playersCount;

@end

@implementation SSGameSession

- (instancetype)initWithPlayersCount:(int)playersCount spyCount:(int)spyCount {
    self = [super init];
    if (self) {
        self.players = [NSMutableArray new];
        self.playersCount = playersCount;
        self.spyCount = spyCount;
        self.currentPlayerIndex = 0;
        self.placeWord = @"Madagaskar";//TODO remove
        [self setup];
    }
    return self;
}

- (void)setup {
    NSMutableArray *spyIndexes = [NSMutableArray new];
    int r;
    while (spyIndexes.count < self.spyCount) {
        r = arc4random() % self.playersCount;
        if (![spyIndexes containsObject:@(r)]) {
            [spyIndexes addObject:@(r)];
        }
    }
    for (int i = 0; i < self.playersCount; i++) {
        SSPlayer *player = [[SSPlayer alloc] init];
        player.isSpy = [spyIndexes containsObject:@(i)];
        self.players[i] = player;
    }
}

- (NSString *)nextWord {
    if (self.currentPlayerIndex >= self.playersCount) {
        return nil;
    }
    if (self.players[self.currentPlayerIndex++].isSpy) {
        return @"Spy";
    } else {
        return self.placeWord;
    }
}

- (void)startTimer {
    self.startTime = [NSDate date];
}

- (void)pouseGame {
    
}

- (void)finishGame {
    
}

- (NSArray *)results {
    NSMutableArray *spys = [NSMutableArray new];
    [self.players enumerateObjectsUsingBlock:^(SSPlayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSpy) {
            [spys addObject:obj];
        }
    }];
    return spys;
}

@end
