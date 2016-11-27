//
//  GoBoard.m
//  goscore-rust
//
//  Created by Caleb Jones on 11/27/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

#import "RawGoBoard.h"
#include "goscore.h"

@interface RawGoBoard()
@property char* buffer;
@end

@implementation RawGoBoard
- (instancetype)initWithBuffer:(NSArray*)buffer width:(size_t)width height:(size_t)height {
    self = [self initWithWidth:width height:height];
    for (int i = 0; i < self.width * self.height; ++i) {
        self.buffer[i] = [buffer[i] charValue];
    }
    return self;
}

- (instancetype)initWithWidth:(size_t)width height:(size_t)height {
    self = [super init];
    self.width = width;
    self.height = height;
    self.buffer = malloc(self.width * self.height);
    for (int i = 0; i < self.width * self.height; ++i) {
        self.buffer[i] = 0;
    }
    return self;
}

- (instancetype)init {
    return [self initWithWidth:0 height:0];
}

- (void)guessDeadStones {
    guess_dead_stones(self.buffer, self.width, self.height);
}

- (void)scoreStones {
    score_stones(self.buffer, self.width, self.height);
}


- (int)scoreSumsWithKomi:(uint)komi blackScore:(uint *)black whiteScore:(uint *)white {
    return score_sums(self.buffer, self.width, self.height, komi, black, white);
}

- (char)rawValueAtRow:(uint)row column:(uint)column {
    return self.buffer[row * self.width + column];
}

- (void)setRawValueAtRow:(uint)row column:(uint)column value:(char)value {
    self.buffer[row * self.width + column] = value;
}

- (void)dealloc {
    free(self.buffer);
}

@end
