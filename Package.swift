// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

/**
 *	@file Package.swift
 *	@namespace BxObjC
 *
 *	@details Swift packege manager file
 *	@date 02.03.2017
 *	@author Sergey Balalaev
 *
 *	@version last in https://github.com/ByteriX/BxTextField.git
 *	@copyright The MIT License (MIT) https://opensource.org/licenses/MIT
 *	 Copyright (c) 2017 ByteriX. See http://byterix.com
 */

import PackageDescription

let package = Package(
    name: "BxObjC",
    //defaultLocalization: "ru",
    platforms: [.macOS(.v10_11),
                .iOS(.v9),
                .tvOS(.v9),
                .watchOS(.v2)],
    products: [
//        .library(
//            name: "BxObjC_Common",
//            targets: ["BxObjC_Common"]),
//        .library(
//            name: "BxObjC/DB",
//            targets: ["BxObjC/DB"]),
//        .library(
//            name: "BxObjC_Control_Rate",
//            targets: ["BxObjC_Control_Rate"]),
//        .library(
//            name: "BxObjC_Control_TextView",
//            targets: ["BxObjC_Control_TextView"]),
//        .library(
//            name: "BxObjC_Control_ShakeAnimation",
//            targets: ["BxObjC_Control_ShakeAnimation"]),
//        .library(
//            name: "BxObjC_Control_Navigation",
//            targets: ["BxObjC_Control_Navigation"]),
//        .library(
//            name: "BxObjC",
//            targets: [
//                "BxObjC_Common",
//                //"BxObjC/DB",
//                "BxObjC_Control_Rate",
//                "BxObjC_Control_TextView",
//                "BxObjC_Control_ShakeAnimation",
//                "BxObjC_Control_Navigation"
//            ]
//        ),
        .library(
            name: "BxObjC",
            targets: [
                "BxObjC"
            ]
        ),
//        .library(
//            name: "BxObjC-Common-Frameworks-HTMLParse",
//            targets: [
//                "BxObjC-Common-Frameworks-HTMLParse"
//            ]
//        ),
//        .library(
//            name: "BxObjC-Common-Frameworks-StackBlur",
//            targets: [
//                "BxObjC-Common-Frameworks-StackBlur"
//            ]
//        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        //
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BxObjC",
            dependencies: [],
            path: "iBXCommon",
            sources: ["Test"],
            publicHeadersPath: "Test",
            cSettings: [
                .headerSearchPath("Test")
            ]
        ),
//        .target(
//            name: "BxObjC-Common-Frameworks-HTMLParse",
//            path: "iBXCommon/iBXCommon/Frameworks/HTMLParse",
//            cSettings: [
//                .unsafeFlags(["-w"]), // no more any warnings
//                .unsafeFlags(["-fno-objc-arc"])
//            ]
//        ),
//        .target(
//            name: "BxObjC-Common-Frameworks-StackBlur",
//            path: "iBXCommon/iBXCommon/Frameworks/StackBlur",
//            cSettings: [
//                .unsafeFlags(["-w"]), // no more any warnings
//                .unsafeFlags(["-fno-objc-arc"])
//            ]
//        ),
//        .target(
//            name: "BxObjC",
//            dependencies: [
//                "BxObjC-Common-Frameworks-HTMLParse",
//                "BxObjC-Common-Frameworks-StackBlur"
//            ],
//            path: "iBXCommon/iBXCommon/Sources",
//            cSettings: [
//                .unsafeFlags(["-w"]), // no more any warnings
//                .unsafeFlags(["-fno-objc-arc"]),
//                .unsafeFlags(["-fobjc-weak"])
//            ]
//        ),
//        .target(
//            name: "BxObjC_Common",
//            dependencies: [
//                "BxObjC_Common_Frameworks_HTMLParse",
//                "BxObjC_Common_Frameworks_StackBlur"
//            ],
//            path: "iBXCommon/iBXCommon/Sources",
//            cSettings: [
//                .unsafeFlags(["-w"]), // no more any warnings
//                .unsafeFlags(["-fno-objc-arc"]),
//                .unsafeFlags(["-fobjc-weak"])
//            ]
//        ),
//        .target(
//            name: "BxObjC/DB",
//            dependencies: ["BxObjC/Common"],
//            path: "iBXDB/iBXDB",
//            swiftSettings: [
//                .define("SQLITE_CORE", .when(platforms: [.iOS])),
//                .define("SQLITE_UNICODE_ENABLE", .when(platforms: [.iOS])),
//                .define("SQLITE_ENABLE_FTS4", .when(platforms: [.iOS])),
//                .define("SQLITE_ENABLE_FTS4_PARENTHESIS", .when(platforms: [.iOS]))
//            ]
//        ),
//        .target(
//            name: "BxObjC_Control_Rate",
//            dependencies: [],
//            path: "iBXVcl/iBXVcl/Control/Rate",
//            cSettings: [
//                .unsafeFlags(["-w"]), // no more any warnings
//                .unsafeFlags(["-fno-objc-arc"]),
//                .unsafeFlags(["-fobjc-weak"])
//            ]
//        ),
//        .target(
//            name: "BxObjC_Control_TextView",
//            dependencies: [],
//            path: "iBXVcl/iBXVcl/Control/TextView",
//            cSettings: [
//                .unsafeFlags(["-w"]), // no more any warnings
//                .unsafeFlags(["-fno-objc-arc"])
//            ]),
//        .target(
//            name: "BxObjC_Control_ShakeAnimation",
//            dependencies: [],
//            path: "iBXVcl/iBXVcl/Control/ShakeAnimation"),
//        .target(
//            name: "BxObjC_Control_Navigation",
//            dependencies: ["BxObjC_Common", "BxObjC_Control_ShakeAnimation"],
//            path: "iBXVcl/iBXVcl/Control/Navigation"
//        ),
    ]
//    ,
//    swiftLanguageVersions: [.v5]
)
