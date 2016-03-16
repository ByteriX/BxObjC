/**
 *	@file BxAbstractDataSet.m
 *	@namespace iBXData
 *
 *	@details Абстрактное хранилище данных
 *	@date 10.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxAbstractDataSet.h"

@implementation BxAbstractDataSet

- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target
{
    self = [self init];
	if ( self ){
		self.target = target;
		_updateLock = [[NSLock alloc] init];
	}
	return self;
}

- (NSDictionary *) loadData
{
	[NSException raise: @"NotImplementException"
                format: @"AbstractDataSet method (loadData) is not implement"];
	return nil;
}

- (void) startOnMainThread
{
	[self.target dataSetDelegateStartUpdate: self];
}

- (void) dataLoadedOnMainThread
{
    _isRefreshed = _isRefreshing;
	_isLoaded = !self.isCancel;
    if ([self.target respondsToSelector:@selector(dataSetDelegate:dataLoaded:)])
        [self.target dataSetDelegate: self dataLoaded: self.data];
	[self setProgress: 1.0f];
}

- (void) errorOnMainThread: (NSException *) e
{
    _isLoading = NO;
	if ([e isKindOfClass: BxException.class]) {
		BxException * ee = (BxException *) e;
		[self.target dataSetDelegate: self error: ee.error.code errorMessage: ee.reason];
	} else {
		[self.target dataSetDelegate: self error: 0 errorMessage: e.reason];
	}
}

- (void) completionOfDataLoading: (NSDictionary *) loadedData
{
    [_data autorelease];
	_data = [loadedData retain];
	if ([self.target respondsToSelector: @selector(dataSetDelegate:dataLoading:)]) {
		[self.target dataSetDelegate: self dataLoading: self.data];
	}
	_isLoading = NO;
	[self performSelectorOnMainThread: @selector(dataLoadedOnMainThread)
						   withObject:nil waitUntilDone: YES];
}

- (NSDictionary *) loadDataWithRefresh
{
	if ([self.target respondsToSelector: @selector(dataSetDelegateStartRefresh:)]) {
		[self.target dataSetDelegateStartRefresh: self];
	}
	NSDictionary * result = [self loadData];
	if (result) {
		if ([self.target respondsToSelector: @selector(dataSetDelegate:dataRefresh:)]) {
			return [self.target dataSetDelegate: self dataRefresh: result];
		} else {
			return result;
		}
	}
	return nil;
}

- (void) prepareLoadingData
{
    _isCancel = NO;
	_isLoading = YES;
	_isLoaded = NO;
    _isRefreshed = NO;
}

- (void) finishLoadingData
{
    _isLoading = NO;
    _isRefreshing = NO;
}

- (void) loadDataThread: (NSNumber*) isRawRefresh
{
	[_updateLock lock];
    [self prepareLoadingData];
	_isRefreshing = [isRawRefresh boolValue];
	//NSLog(@"Start %d", [NSThread currentThread], nil);
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	@try {
		[self setProgress: 0.0f];
		[_data autorelease];
		_data = nil;
		[self performSelectorOnMainThread: @selector(startOnMainThread)
							   withObject:nil waitUntilDone: YES];
		_isCashLoaded = NO;
		NSDictionary * loadedData = nil;
		if (_dataCasher){
			if (!_isRefreshing) {
				loadedData = [_dataCasher loadData];
			}
			if (loadedData){
				_isCashLoaded = YES;
			} else {
				loadedData = [self loadDataWithRefresh];
                if (loadedData) {
                    [_dataCasher saveData: loadedData];
                }
			}
		} else {
			loadedData = [self loadDataWithRefresh];
		}
		[self completionOfDataLoading: loadedData];
	}
	@catch (NSException * e) {
		NSDictionary * loadedData = nil;
		if (_dataCasher && (!_isRefreshing)) {
			loadedData = [_dataCasher anywayLoadData];
			if (loadedData){
				_isCashLoaded = YES;
			}
		}
		if (loadedData) {
			[self completionOfDataLoading: loadedData];
		} else {
			[self performSelectorOnMainThread: @selector(errorOnMainThread:)
								   withObject: e waitUntilDone: YES];
		}
	}
	@finally {
		[pool release];
		//NSLog(@"Stop %d", [NSThread currentThread], nil);
        [self finishLoadingData];
		[_updateLock unlock];
	}
}

- (void) update
{
	[NSThread detachNewThreadSelector: @selector(loadDataThread:) toTarget: self withObject: [NSNumber numberWithBool: NO]];
}

- (void) updateWithRefresh
{
	[NSThread detachNewThreadSelector: @selector(loadDataThread:) toTarget: self withObject: [NSNumber numberWithBool: YES]];
}

- (void) cancel
{
    if (!_isLoading) {
        return;
    }
    NSLog(@"Action cancel dataSet loading");
	[self toCancel];
	[_updateLock lock];
	[_updateLock unlock];
}

- (void) toCancel
{
    if (!_isLoading) {
        return;
    }
    NSLog(@"DataSet loading to cancel");
    _isCancel = YES;
}

- (void) setUpdatedStatus
{
	_isLoaded = NO;
}

- (void) editDataWithObjectThread: (id) object
{
	[_updateLock lock];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	@try {
		NSDictionary * oldData = _data;
		NSDictionary * result = [self.target dataSetDelegate: self editedData: oldData withObject: object];
		if (!result) {
			[BxException raise: @"NotCorrectException" format: @"Набор данных при изменении не может быть пустым"];
		}
		if (_dataCasher && result) {
			[_dataCasher saveData: result];
		}
		_data = [result retain];
		[oldData autorelease];
		[self setUpdatedStatus];
	}
	@catch (NSException * e) {
		[self performSelectorOnMainThread: @selector(errorOnMainThread:)
							   withObject: e waitUntilDone: YES];
	}
	@finally {
		[pool release];
		[_updateLock unlock];
	}
}

- (void) editDataWithObject: (id) object
{
	if (_target && [_target respondsToSelector: @selector(dataSetDelegate:editedData:withObject:)]) {
		[NSThread detachNewThreadSelector: @selector(editDataWithObjectThread:) toTarget: self withObject: object];
	} else {
		[BxException raise: @"NotImplementedException" format: @"Не определено событие изменения для набора данных"];
	}
}

- (void) deleteAtIndex: (int) index
{
	[NSException raise:@"NotImplementException" format:@"deleteAtIndex is not implement in DataSet"];
}

- (void) setProgress: (float) position{
	if (position < 0.0f){
		_progressPosition = 0.0f;
	} else if (position > 1.0f) {
		_progressPosition = 1.0f;
	} else {
		_progressPosition = position;
	}
	if ([_target respondsToSelector: @selector(dataSetDelegate: progress:)])
	{
		if (position > - 0.01 && position < 1.01)
			[_target dataSetDelegate: self progress: _progressPosition];
	}
}

- (void) incProgress: (float) position
{
	[self setProgress: _progressPosition + position];
}

- (void) saveToCashThread
{
	[_updateLock lock];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	@try {
        if (_data) {
            [_dataCasher saveData: _data];
        }
	}
	@catch (NSException * e) {
		[self performSelectorOnMainThread: @selector(errorOnMainThread:)
                               withObject: e waitUntilDone: YES];
	}
	@finally {
		[pool release];
		[_updateLock unlock];
	}
}

- (void) saveToCash
{
	if (_dataCasher) {
		[NSThread detachNewThreadSelector: @selector(saveToCashThread) toTarget: self withObject: nil];
	}
}

- (void) waitingLoading
{
    if (!_isLoading) {
        [_updateLock lock];
        [_updateLock unlock];
    }
}

- (void) waitForCompletion:(NSTimeInterval)timeoutSecs {
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow: timeoutSecs];
    while (_isLoading) {
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    }
}

- (void) updateAndWaitInMainThread
{
    _isLoading = YES;
    [self update];
    [self waitForCompletion: 60.0];
}

- (void) toDeallocOnThread
{
    
}

//! @override
- (void) dealloc
{
    self.target = nil;
	[self toCancel];
    [_updateLock lock];
    [_updateLock unlock];
    [_updateLock autorelease];
    _updateLock = nil;
	self.dataCasher = nil;
	[_data autorelease];
    _data = nil;
	[super dealloc];
}

@end
