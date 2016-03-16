/* 
 
 Copyright 2012 Juan-Carlos Mendez (jcmendez@alum.mit.edu)
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License. 
 */

#import "JCMSegmentPageController.h"

@interface SplitLineView : UIView

@end
@implementation SplitLineView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.5f;
    }
    return self;
}

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    CGContextSetLineWidth(context, 1);
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, self.frame.size.height);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextMoveToPoint(context, 2, 0);
    CGContextAddLineToPoint(context, 2, self.frame.size.height);
    CGContextStrokePath(context);
}

@end

static const float TAB_BAR_HEIGHT = 44.0f;

@interface JCMSegmentPageController ()

@property (nonatomic, retain) NSMutableArray * splitLines;
@property (nonatomic, retain) NSMutableArray * splitLabels;

@end

@implementation JCMSegmentPageController {
	UIView *headerContainerView;
  UISegmentedControl *segmentedControl;
	UIView *contentContainerView;
    UIColor *tintColor;
}

@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize delegate = _delegate;
@synthesize headerContainerView, segmentedControl, contentContainerView;

- (id)initWithTintColor:(UIColor *)color {
    self = [self init];
    if (self) {
        tintColor = [color retain];
    }
    return self;
}

- (void)removeAllSegments {
  [segmentedControl removeAllSegments];
}

- (void)addSegments {
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers) {
        [segmentedControl insertSegmentWithTitle:viewController.title atIndex:index animated:NO];
		++index;
	}
}

- (void)reloadTabButtons {
	[self removeAllSegments];
	[self addSegments];
  // TODO -- Do I need this???
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)layoutHeaderView {
	CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, TAB_BAR_HEIGHT);
    segmentedControl.frame = CGRectInset(rect, 5.0, 5.0);
}

/**
 * When the view loads, we set the header, and on it, the segmented control that will control
 * the page being displayed
 */
- (void)viewDidLoad {
	[super viewDidLoad];

	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, TAB_BAR_HEIGHT);
	headerContainerView = [[[UIView alloc] initWithFrame:rect] autorelease];
	headerContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    CGRect segmentedControlRect = CGRectIntegral(CGRectInset(rect, 5.0, 5.0));
    segmentedControl = [[[UISegmentedControl alloc] initWithFrame:segmentedControlRect] autorelease];
    segmentedControl.backgroundColor = [UIColor clearColor];
    segmentedControl.momentary = NO;
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventValueChanged];
    if (tintColor) {
        [segmentedControl setTintColor:tintColor];
    }
    [headerContainerView addSubview:segmentedControl];
	[self.view addSubview:headerContainerView];
	rect.origin.y = TAB_BAR_HEIGHT;
	rect.size.height = self.view.bounds.size.height - TAB_BAR_HEIGHT;
	contentContainerView = [[[UIView alloc] initWithFrame:rect] autorelease];
	contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:contentContainerView];
    
    if (self.splitAllControllers) {
        segmentedControl.hidden = YES;
        CGFloat width = truncf(contentContainerView.frame.size.width / self.viewControllers.count);
        self.splitLines = [NSMutableArray arrayWithCapacity: self.viewControllers.count];
        self.splitLabels = [NSMutableArray arrayWithCapacity: self.viewControllers.count];
        for (int i = 0; i < self.viewControllers.count - 1; i++) {
            SplitLineView * line = [[SplitLineView alloc] initWithFrame: CGRectMake((i + 1) * width - 1, 0, 2, self.view.frame.size.height)];
            //line.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview: line];
            [self.splitLines addObject: line];
            [line release];
        }
        int index = 0;
        for (UIViewController * viewController in _viewControllers) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8 + width * index, 8, width-16, 28)];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            label.shadowOffset = CGSizeMake(0, 1);
            label.font = [UIFont boldSystemFontOfSize:17];
            label.text = viewController.title;
            [self.splitLabels addObject: label];
            [headerContainerView addSubview: label];
            [label release];
        }
    }

	[self reloadTabButtons];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	[self layoutHeaderView];
    if (self.splitAllControllers) {
        CGSize size = CGSizeMake(truncf(contentContainerView.frame.size.width / self.viewControllers.count), contentContainerView.frame.size.height);
        int index = 0;
        for (UIViewController * controller in self.viewControllers) {
            controller.view.frame = CGRectMake(index * size.width, 0.0f, size.width, size.height);
            [controller viewWillLayoutSubviews];
            if (index < self.splitLines.count) {
                SplitLineView * line = self.splitLines[index];
                line.frame = CGRectMake((index + 1) * size.width - 1, 0, 2, self.view.frame.size.height);
            }
            UILabel *label = self.splitLabels[index];
            label.frame = CGRectMake(8 + size.width * index, 8, size.width-16, 28);
            index++;
        }
    } else {
        [self.selectedViewController viewWillLayoutSubviews];
    }
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
    //[self.selectedViewController viewDidLayoutSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Only rotate if all child view controllers agree on the new orientation.
	for (UIViewController *viewController in self.viewControllers) {
		if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
			return NO;
	}
	return YES;
}

- (void)setViewControllers:(NSArray *)newViewControllers {
	//NSAssert([newViewControllers count] >= 2, @"JCMSegmentPageController requires at least two view controllers");

	UIViewController *oldSelectedViewController = self.selectedViewController;
    
    for (UIView * view in [[contentContainerView.subviews copy] autorelease]) {
        [view removeFromSuperview];
    }

	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers) {
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
        /*if ([viewController isViewLoaded]) {
            [viewController viewDidUnload];
        }*/
	}

    [_viewControllers autorelease];
	_viewControllers = [newViewControllers copy];
    
    if ([newViewControllers count] < 2) {
        return;
    }

	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;

	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers) {
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}

	if ([self isViewLoaded]){
		[self reloadTabButtons];
    }
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex {
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void) autoresizeController: (UIViewController*) controller
{
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated {
	//NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
    if (newSelectedIndex >= [self.viewControllers count]) {
        return;
    }

    
    if (self.splitAllControllers) {
        CGSize size = CGSizeMake(truncf(contentContainerView.frame.size.width / self.viewControllers.count), contentContainerView.frame.size.height);
        int index = 0;
        for (UIViewController * controller in self.viewControllers) {
            controller.view.frame = CGRectMake(index * size.width, 0.0f, size.width, size.height);
            [self autoresizeController: controller];
            [contentContainerView insertSubview: controller.view atIndex: 0];
            index++;
        }
        return;
    }
    
	if ([self.delegate respondsToSelector:@selector(segmentPageController:shouldSelectViewController:atIndex:)]) {
		UIViewController *toViewController = [self.viewControllers objectAtIndex:newSelectedIndex];
		if (![self.delegate segmentPageController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}

	if (![self isViewLoaded]) {
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex) {
		UIViewController *fromViewController = nil;
		UIViewController *toViewController = nil;

		NSUInteger oldSelectedIndex = _selectedIndex;
        if (_selectedIndex != NSNotFound) {
			fromViewController = self.selectedViewController;
		}
		_selectedIndex = newSelectedIndex;

		if (_selectedIndex != NSNotFound) {
      [segmentedControl setSelectedSegmentIndex:_selectedIndex];
			toViewController = self.selectedViewController;
		}

		if (toViewController == nil) { // don't animate
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil) { // don't animate
			toViewController.view.frame = contentContainerView.bounds;
            [self autoresizeController: toViewController];
			[contentContainerView addSubview:toViewController.view];

			if ([self.delegate respondsToSelector:@selector(segmentPageController:didSelectViewController:atIndex:)])
				[self.delegate segmentPageController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		} else if (animated) {
			CGRect rect = contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;

            
			toViewController.view.frame = rect;
            [self autoresizeController: toViewController];
			headerContainerView.userInteractionEnabled = NO;

			[self transitionFromViewController:fromViewController
				toViewController:toViewController
				duration:0.3
				options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
				animations:^ {
					CGRect rect = fromViewController.view.frame;
					if (oldSelectedIndex < newSelectedIndex)
						rect.origin.x = -rect.size.width;
					else
						rect.origin.x = rect.size.width;

					fromViewController.view.frame = rect;
					toViewController.view.frame = contentContainerView.bounds;
				}
				completion:^(BOOL finished) {
					headerContainerView.userInteractionEnabled = YES;

					if ([self.delegate respondsToSelector:@selector(segmentPageController:didSelectViewController:atIndex:)])
						[self.delegate segmentPageController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
				}];
		} else { // not animated
			[fromViewController.view removeFromSuperview];

			toViewController.view.frame = contentContainerView.bounds;
            [self autoresizeController: toViewController];
			[contentContainerView addSubview:toViewController.view];

			if ([self.delegate respondsToSelector:@selector(segmentPageController:didSelectViewController:atIndex:)])
				[self.delegate segmentPageController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController {
	if (self.selectedIndex != NSNotFound)
		return [self.viewControllers objectAtIndex:self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController {
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UISegmentedControl *)sender {
	[self setSelectedIndex:sender.selectedSegmentIndex animated:YES];
}


- (void)viewDidUnload {
	headerContainerView = nil;
	contentContainerView = nil;
	segmentedControl = nil;
    self.splitLines = nil;
    self.splitLabels = nil;
    [super viewDidUnload];
}

- (void)dealloc {
    
    self.splitLabels = nil;
    self.splitLines = nil;
    self.delegate = nil;
    self.viewControllers = nil;
    //[_viewControllers release];
    headerContainerView = nil;
	contentContainerView = nil;
	segmentedControl = nil;
    [super dealloc];
}

@end
