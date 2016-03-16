/**
 *	@file BxAbstractDataSet.h
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

#import <Foundation/Foundation.h>
#import "BxDataCasher.h"

@class BxAbstractDataSet;

/**
 *	Протокол для делегации событий происходящих с наборами данных @ref AbstractDataSet
 */
@protocol BxAbstractDataSetDelegate<NSObject>
@required
//! Начало згрузки набора данных
- (void) dataSetDelegateStartUpdate:(BxAbstractDataSet *)dataSet;
//! Возникновение ошибки при загрузки набора данных
- (void) dataSetDelegate: (BxAbstractDataSet *)dataSet
				   error: (NSInteger)errorCode
            errorMessage: (NSString*) errorMessage;
//! Событие окончания формирования (загрузки/обновления) набора данных
- (void) dataSetDelegate:(BxAbstractDataSet *)dataSet dataLoaded:(NSDictionary *)data;
@optional
//! Начало обновления набора данных, загружаемых не из кеша
- (void) dataSetDelegateStartRefresh:(BxAbstractDataSet *)dataSet;
//! Уровень загрузки данных с сервера: 0.0 ... 1.0
- (void) dataSetDelegate:(BxAbstractDataSet *)dataSet progress: (float) progress;
//! Событие окончания формирования, но пока еще в рамках потока загрузки
- (void) dataSetDelegate:(BxAbstractDataSet *)dataSet dataLoading:(NSDictionary *)allData;
//! Событие обновления данных, загруженных не из кеша. Если объявление отсутствует то равносильно возврату allData
- (NSDictionary *) dataSetDelegate:(BxAbstractDataSet *)dataSet dataRefresh:(NSDictionary *)allData;
//! Событие обновления данных, при попытке изменения данных с объектом id. В нем можно вызывать исключения (NSException)
- (NSDictionary *) dataSetDelegate:(BxAbstractDataSet *)dataSet editedData:(NSDictionary *)allData withObject: (id) object;
@end

//! Абстрактное хранилище данных
@interface BxAbstractDataSet : NSObject {
@protected
	//! позиция при загрузке данных
	float _progressPosition;
    //! механизм синхронизации
	NSLock * _updateLock;
}
//! Владелец, на которого делегируются действия
@property (nonatomic, assign) id<BxAbstractDataSetDelegate> target;
//! данные были загружанны из кеша
@property (nonatomic, readonly) BOOL isCashLoaded;
//! доступ к данным
@property (nonatomic, readonly) NSDictionary * data;
//! менеджер работы с кешем для данного набора данных
@property (nonatomic, retain) BxDataCasher * dataCasher;
// В текущий момент обращения производится загрузка данных
@property (nonatomic, readonly) BOOL isLoading;
//! Данные были загруженны
@property (nonatomic, readonly) BOOL isLoaded;
//! В истине при обновлении данных в обход кеша
@property (readonly) BOOL isRefreshing;
//! В истине после обновления данных в обход кеша
@property (readonly) BOOL isRefreshed;
//! Загрузка была приостанавлена
@property (readonly) BOOL isCancel;


- (id) initWithTarget: (id<BxAbstractDataSetDelegate>) target;

//! обновление данных с полной перезагрузкой и использованием кеша
- (void) update;
//! Прерывание процесса получения данных (должен исполняться не в главном потоке)
- (void) cancel;
//! Отдает команду на прерывание процесса получения данных (тоже не из главного потока)
- (void) toCancel;

//! Выставляет флаг, чтобы при следующем открытии набор данных перезагружался
- (void) setUpdatedStatus;

//! обновление данных с полной перезагрузкой и обновлением кеша
- (void) updateWithRefresh;

//! синхронный с главным потоком вызов, который способен ожидать завершение получения данных в главном потоке даже
- (void) updateAndWaitInMainThread;

//! производит измененения данных с сохранением в кеш, при этом должно быть определено событие в котором эти изменения и фиксируются
- (void) editDataWithObject: (id) object;
//! удаление под определенным индексом
- (void) deleteAtIndex: (int) index;

//! Для внутреннего использования установки уровня загрузки данных
- (void) setProgress: (float) position;

//! Для внутреннего использования изменения уровня загрузки данных
- (void) incProgress: (float) position;

//! private
- (NSDictionary *) loadData;

//! private
- (void) loadDataThread: (NSNumber*) isRawRefresh;

//! принудительное обновление кеша из измененных данных
- (void) saveToCash;

//! Загружается не в главном потоке, чтобы ожидать загрузки данных
- (void) waitingLoading;

@end

@interface BxAbstractDataSet (private)

- (void) prepareLoadingData;

@end