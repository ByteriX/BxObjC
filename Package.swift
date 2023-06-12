// swift-tools-version: 5.4
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
    defaultLocalization: "ru",
    platforms: [.iOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BxObjC/Common",
            targets: ["BxObjC/Common"]),
        .library(
            name: "BxObjC/DB",
            targets: ["BxObjC/DB"]),
        .library(
            name: "BxObjC/Control/Rate",
            targets: ["BxObjC/Control/Rate"]),
        .library(
            name: "BxObjC/Control/TextView",
            targets: ["BxObjC/Control/TextView"]),
        .library(
            name: "BxObjC/Control/ShakeAnimation",
            targets: ["BxObjC/Control/ShakeAnimation"]),
        .library(
            name: "BxObjC/Control/Navigation",
            targets: ["BxObjC/Control/Navigation"]),
//        .library(
//            name: "BxObjC",
//            targets: ["BxObjC/Common", "BxObjC/DB", "BxObjC/Control/Rate", "BxObjC/Control/TextView", "BxObjC/Control/ShakeAnimation", "BxObjC/Control/Navigation"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        //
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BxObjC/Common",
            dependencies: [],
            path: "iBXCommon/iBXCommon"),
        .target(
            name: "BxObjC/DB",
            dependencies: ["BxObjC/Common"],
            path: "iBXDB/iBXDB",
            swiftSettings: [
                .define("SQLITE_CORE", .when(platforms: [.iOS])),
                .define("SQLITE_UNICODE_ENABLE", .when(platforms: [.iOS])),
                .define("SQLITE_ENABLE_FTS4", .when(platforms: [.iOS])),
                .define("SQLITE_ENABLE_FTS4_PARENTHESIS", .when(platforms: [.iOS]))
            ]
        ),
        .target(
            name: "BxObjC/Control/Rate",
            dependencies: [],
            path: "iBXVcl/iBXVcl/Control/Rate"),
        .target(
            name: "BxObjC/Control/TextView",
            dependencies: [],
            path: "iBXVcl/iBXVcl/Control/TextView",
            cSettings: [
                .unsafeFlags(["-fno-objc-arc"]) // ADDING THE FLAG
            ]),
        .target(
            name: "BxObjC/Control/ShakeAnimation",
            dependencies: [],
            path: "iBXVcl/iBXVcl/Control/ShakeAnimation"),
        .target(
            name: "BxObjC/Control/Navigation",
            dependencies: ["BxObjC/Common", "BxObjC/Control/ShakeAnimation"],
            path: "iBXVcl/iBXVcl/Control/Navigation"),
    ],
    swiftLanguageVersions: [.v5]
)
