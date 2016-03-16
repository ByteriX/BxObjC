/**
 *	@file BxDownloadProgress.m
 *	@namespace iBXData
 *
 *	@details Интерфейс изменения уровня загрузки
 *	@date 08.07.2013
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxObjC
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2016 ByteriX. See http://byterix.com
 */

#import "BxDownloadProgress.h"


BOOL DPisValid(id<BxDownloadProgress> downloadProgress)
{
	return (downloadProgress && [downloadProgress isActive]);
}

float DPgetPosition(id<BxDownloadProgress> downloadProgress)
{
	if (DPisValid(downloadProgress))
		return [downloadProgress getPosition];
	else
		return 0.0;
}

void DPsetPosition(id<BxDownloadProgress> downloadProgress, float value)
{
	if (DPisValid(downloadProgress))
		[downloadProgress setPosition: value];
}

void DPincPosition(id<BxDownloadProgress> downloadProgress, float value)
{
	if (DPisValid(downloadProgress))
		[downloadProgress setPosition: value + [downloadProgress getPosition]];
}

void DPstartFastFull(id<BxDownloadProgress> downloadProgress)
{
	if (DPisValid(downloadProgress))
		[downloadProgress startFastFull];
}
