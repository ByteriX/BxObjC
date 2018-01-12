# Copyright

Library iByteriX

ByteriX, 2013-2018. All right reserved.

# Versions

## 1.2.1 (12.01.2018)
* added correct checking of iOS/SDK supporting
* backward supporting iOS 10 SDK
* fixed issues with extendedEdgesBounds for iOS 11

## 1.2.0 (17.11.2017)
##### Bug fixes
* changed working with extendedEdgesBounds for iOS 11
* supporting iPhone X
* fixed navigationBar for safeAreaInsets

## 1.1.34 (27.09.2017)
##### Bug fixes
* fix BxWebDocViewController for iOS 11
* removed reference to remaned extension for Navigation

## 1.1.33 (17.09.2017)
##### Improvment
* supporting iOS 11
* added UIImage extensions for creating painted images
* fixed background image for Navigation on iOS 11
* better animation for Vcl: Navigation
* refactoring BxNavigationBar

## 1.1.32 (11.09.2017)
##### Improvment
* seporated Controls from Vcl: Navigation

## 1.1.31 (10.09.2017)
##### Improvment
* seporated Controls from Vcl: ShakeAnimation

## 1.1.30 (10.09.2017)
##### Improvment
* seporated Controls from Vcl: Rate, TextView

## 1.1.27 (02.08.2017)
##### Bug fix
* fixed BxTextView update placeholderColor

## 1.1.26 (01.08.2017)
##### Bug fix
* fixed BxTextView placeholder

## 1.1.25 (21.07.2017)
##### Bug fix
* fixed mistake in the word isNormalShowingDisabledCell

## 1.1.24 (11.06.2017)
##### Improvment
* Fix warnings about import of "BxUtils.h" and "BxUIUtils.h"

## 1.1.23 (04.06.2017)
##### Bug fixes
* fix navigation panel & backgroung which is changing isNavigationBarHidden
* added cases with a changing isNavigationBarHidden to the example

## 1.1.22 (31.05.2017)
##### Bug fixes
* fix navigation panel & backgroung animation from transiton

## 1.1.21 (10.05.2017)
##### Improvment
* Common: fix nonnull in Color constructors
* fix all warning dependency with iOS 7/8 deprecation
* fix all projects warning

## 1.1.20.1 (08.05.2017)
##### Improvment
* Common: instancetype to nonnull instancetype
* in Swift code expression let color = UIColor.color(withHex:0x000000)! has changed to let color = UIColor(hex:0x000000)

## 1.1.20 (08.05.2017)
##### Improvment
* Common: change id to instancetype for UIColor
* update all settings
* remove wantsFullScreenLayout from BxWebDocViewController
* transport MBProgressHUD to pods

## 1.1.19 (24.01.2017)
##### Bug fixes
* VCL: BxNavigationBar fix problem with changing scroll from an external approch

## 1.1.18 (17.01.2017)
##### Bug fixes
* VCL: BxNavigationBar fix problem with canceling gusture when the scroll didn't change

## 1.1.17 (20.12.2016)
##### Bug fixes
* VCL: BxNavigationBar fix problems with scrollLimitation

## 1.1.16 (20.12.2016)
##### Improvment
* VCL: add scrollLimitation property to BxNavigationBar
* VCL: BxOldInputTableController: firstly initialize value of variantPicker (the same way as dataPicker)
* VCL: BxOldInputTableController: disabled cell is not selected & transparent

## 1.1.15 (17.12.2016)
##### Improvment
* VCL: Refactoring scrollEffects in BxNavigationBar
* VCL: Create the BxNavigationBarShakeXEffect class with different logic

## 1.1.14 (16.12.2016)
##### Features
* VCL: add scrollMotionEffects to BxNavigationBar
* VCL: add navigationBackgroundWithController to BxNavigationController

## 1.1.13 (12.12.2016)
##### Bug fixes
* VCL: fix horizontal scroll in BxNavigationBar

## 1.1.12 (12.12.2016)
##### Bug fixes
* VCL: fix a scrollable feature in BxNavigationBar

## 1.1.11 (12.12.2016)
##### Features
* Remove something compilator warnings
* Fix google geocoding
* VCL: sharing interface of BxNavigationBar, BxNavigationController
* VCL: add to BxNavigationBar a scrollable feature

## 1.1.10 (09.12.2016)
##### Improvment
* VCL: BxOldInputController open field: mainScroll

## 1.1.9 (07.12.2016)
##### Improvment
* VCL: BxOldInputController open fields: datePicker, variantPicker

## 1.1.8 (30.11.2016)
##### Bug fixes
* VCL: fix bug with the height of variants picker from the BxOldInputController component

## 1.1.7 (17.11.2016)
##### Bug fixes
* Map: request authorization when we use Application

## 1.1.6 (16.11.2016)
##### Enhancements
* fork of FMDB to BxFMDB
* XMLDictionary move to external pod

## 1.1.3 (15.11.2016)
##### Enhancements
* new ReadMe

## 1.1.2 (15.11.2016)
##### Enhancements
* new Change log

## 1.1.1 (15.11.2016)
##### Enhancements
* seporate all frameworks to sub-pods

## 1.0.33 (14.11.2016)
##### Features
* include BxDb

## 1.0.31 (22.10.2016)
##### Bug fixes
* localized Location message

## 1.0.30 (21.10.2016)
##### Enhancements
* add geocodingUrlFrom method to the Google geocoding for a customization

## 1.0.29 (19.09.2016)
##### Bug fixes
* support of iOS 10 and fix background of the navigation panel

## 1.0.28 (21.05.2016)
##### Bug fixes
* BxDownloadStream & BxDownloadStreamWithResume : fix major security bug from stopping load data

## 1.0.27 (09.05.2016)
##### Bug fixes
* BxOldInputTableController crush fixed with the nullable currentFieldName in the didChangedValue method

## 1.0.26 (05.05.2016)
##### Bug fixes
* BxOldInputTableController: a disabled cell not hidden if you wanted

## 1.0.25 (29.04.2016)
##### Enhancements
* BxOldInputTableController: to disable a list on the keyboard from a variant field

## 1.0.24 (10.04.2016)
##### Bug fixes
* add refresh to BxOldInputTableController

## 1.0.23 (07.04.2016)
##### Refactoring
* To open protected properties from BxOldInputTableController

## 1.0.21 (04.04.2016)
##### Enhancements
* To add the mock and the sevice logger information

## 1.0.20 (04.04.2016)
##### Enhancements
* To add the mock of a loading data to a web services

## 1.0.0 (16.03.2016)
##### Started
* To transfer this library to open source code

# Installation

pod 'BxObjC'

or

pod 'BxObjC/Common'

pod 'BxObjC/Data'

pod 'BxObjC/DB'

pod 'BxObjC/Map'

pod 'BxObjC/Vcl'
