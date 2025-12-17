// swift-tools-version: 6.1
//
// SPDX-License-Identifier: Unicode-3.0
// Copyright Contributors to the ICU project

import PackageDescription

let package = Package(
    name: "icu",
    platforms: [
        .macOS(.v14),
        .visionOS(.v1),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10)
    ],
    products: [
        .library(
            name: "icuuc",
            targets: ["icuuc"]
        ),
        .library(
            name: "icuin",
            targets: ["icuin"]
        ),
    ],
    targets: [
        .target(
            name: "icuuc",
            path: "icu4c/source/common",
            exclude: [
                "BUILD.bazel",
                "Makefile.in",
            ],
            sources: ["."],
            publicHeadersPath: "unicode",
            cxxSettings: [
                .define("U_COMMON_IMPLEMENTATION"),
                .define("U_STATIC_IMPLEMENTATION"),
                // Header search path for source compilation and module map includes.
                // Headers in unicode/ use #include "unicode/utypes.h" which requires
                // the parent directory (common/) to be in the search path.
                .headerSearchPath("."),
                .headerSearchPath("unicode"),
                .define("_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH", .when(platforms: [.windows])),
                .define("_ALLOW_KEYWORD_MACROS", to: "1", .when(platforms: [.windows])),
                .define("static_assert(_conditional, ...)", to: "", .when(platforms: [.windows])),
            ]
        ),

        .target(
            name: "icuin",
            dependencies: [
                .target(name: "icuuc")
            ],
            path: "icu4c/source/i18n",
            exclude: [
                "BUILD.bazel",
                "Makefile.in",
            ],
            sources: ["."],
            publicHeadersPath: "unicode",
            cxxSettings: [
                .define("U_I18N_IMPLEMENTATION"),
                .define("U_STATIC_IMPLEMENTATION"),
                .headerSearchPath("."),
                .headerSearchPath("unicode"),
                .headerSearchPath("../common"),
                .headerSearchPath("../common/unicode"),
                .define("_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH", .when(platforms: [.windows])),
                .define("_ALLOW_KEYWORD_MACROS", to: "1", .when(platforms: [.windows])),
                .define("static_assert(_conditional, ...)", to: "", .when(platforms: [.windows])),
            ],
            linkerSettings: [
                .linkedLibrary("advapi32", .when(platforms: [.windows]))
            ]
        ),
    ],
    cxxLanguageStandard: .cxx17
)
