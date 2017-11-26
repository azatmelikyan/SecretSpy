//
//  SCWrapperScrollView.h
//  scrollViewWrapper
//
//  Created by Arman Margaryan on 4/22/15.
//  Copyright (c) 2015 Arman Margaryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCWrapperScrollView : UIScrollView

@property (nonatomic) UIEdgeInsets scrollContainerInsets;

@property (nonatomic, strong) UIScrollView* scrollView;

@property (nonatomic, weak) UIView* scrollContainerView;

//TODO::Temp solution for content update when change 'scrollContainerView'
- (void)updateContentSize;
@end
