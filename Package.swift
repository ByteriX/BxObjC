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
                .iOS(.v11),
                .tvOS(.v11),
                .watchOS(.v2)],
    products: [
        .library(
            name: "BxCommon",
            targets: ["BxCommon"]),
//        .library(
//            name: "BxObjC/DB",
//            targets: ["BxObjC/DB"]),
        .library(
            name: "BxObjC-Control-Rate",
            targets: ["BxObjC-Control-Rate"]),
        .library(
            name: "BxObjC-Control-TextView",
            targets: ["BxObjC-Control-TextView"]),
        .library(
            name: "BxObjC-Control-ShakeAnimation",
            targets: ["BxObjC-Control-ShakeAnimation"]),
        .library(
            name: "BxObjC-Control-Navigation",
            targets: ["BxObjC-Control-Navigation"]),
        .library(
            name: "BxObjC",
            targets: [
                "BxCommon",
////                //"BxObjC/DB",
//                "BxObjC-Control-Rate",
//                "BxObjC-Control-TextView",
//                "BxObjC-Control-ShakeAnimation",
//                "BxObjC-Control-Navigation",
                "BxObjC"
            ]
        ),
//        .library(
//            name: "BxObjC",
//            targets: [
//                "BxObjC"
//            ]
//        ),
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
//        .target(
//            name: "BxObjC",
//            dependencies: [
//            ],
//            path: "include",
//            //sources: [""],
//            publicHeadersPath: ""
//        ),
        .target(
            name: "BxObjC-Common-Frameworks-HTMLParse",
            path: "iBXCommon/iBXCommon/Frameworks/HTMLParse",
            cSettings: [
                .unsafeFlags(["-w"]), // no more any warnings
                .unsafeFlags(["-fno-objc-arc"])
            ]
        ),
        .target(
            name: "BxObjC-Common-Frameworks-StackBlur",
            path: "iBXCommon/iBXCommon/Frameworks/StackBlur",
            cSettings: [
                .unsafeFlags(["-w"]), // no more any warnings
                .unsafeFlags(["-fno-objc-arc"])
            ]
        ),

        .target(
            name: "BxCommon",
            dependencies: [
                "BxObjC-Common-Frameworks-HTMLParse",
                "BxObjC-Common-Frameworks-StackBlur"
            ],
            path: "iBXCommon/iBXCommon",
            sources: ["Sources"],
            publicHeadersPath: "Sources",
            cSettings: [
                .unsafeFlags(["-w"]), // no more any warnings
                .unsafeFlags(["-fno-objc-arc"]),
                .unsafeFlags(["-fobjc-weak"])
            ]
        ),
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
        .target(
            name: "BxObjC-Control-Rate",
            dependencies: [],
            path: "iBXVcl/iBXVcl/Control/Rate",
            cSettings: [
                .unsafeFlags(["-w"]), // no more any warnings
                .unsafeFlags(["-fno-objc-arc"]),
                .unsafeFlags(["-fobjc-weak"])
            ]
        ),
        .target(
            name: "BxObjC-Control-TextView",
            dependencies: [],
            path: "iBXVcl/iBXVcl/Control/TextView",
            cSettings: [
                .unsafeFlags(["-w"]), // no more any warnings
                .unsafeFlags(["-fno-objc-arc"])
            ]),
        .target(
            name: "BxObjC-Control-ShakeAnimation",
            dependencies: [],
            path: "iBXVcl/iBXVcl/Control/ShakeAnimation"),
        .target(
            name: "BxObjC-Control-Navigation",
            dependencies: ["BxCommon", "BxObjC-Control-ShakeAnimation"],
            path: "iBXVcl/iBXVcl/Control/Navigation"
        ),

            .target(
                name: "BxObjC",
                dependencies: [
                    "BxCommon"
//                    "BxObjC-Common",
//                    //"BxObjC/DB",
//                    "BxObjC-Control-Rate",
//                    "BxObjC-Control-TextView",
//                    "BxObjC-Control-ShakeAnimation",
//                    "BxObjC-Control-Navigation",
                ],
                path: "BxObjC"
                //,
//                sources: [""],
//                publicHeadersPath: ""
            ),
    ]
//    ,
//    swiftLanguageVersions: [.v5]
)
