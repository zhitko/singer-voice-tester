cmake_minimum_required(VERSION 3.14)

project(SingerVoiceTester LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.

add_subdirectory(inton-core)

if(ANDROID)
    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")

    set(ANDROID_LIB_DIR "${CMAKE_CURRENT_BINARY_DIR}/inton-core/")

    set(ANDROID_EXTRA_LIBS "${CMAKE_CURRENT_BINARY_DIR}/inton-core/libIntonCore.so")

    LINK_DIRECTORIES("${CMAKE_CURRENT_BINARY_DIR}/inton-core/")
endif()

if(ANDROID)
    find_package(QT NAMES Qt5 COMPONENTS Core Quick LinguistTools QuickControls2 Widgets Charts Multimedia MultimediaWidgets AndroidExtras REQUIRED)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick LinguistTools QuickControls2 Widgets Charts Multimedia MultimediaWidgets AndroidExtras REQUIRED)
else()
    find_package(QT NAMES Qt5 COMPONENTS Core Quick LinguistTools QuickControls2 Widgets Charts Multimedia MultimediaWidgets REQUIRED)
    find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick LinguistTools QuickControls2 Widgets Charts Multimedia MultimediaWidgets REQUIRED)
endif()

set(TS_FILES SingerVoiceTester_en_US.ts)

file(GLOB SOURCES
    src/*.cpp
    src/*/*.cpp
    )
file(GLOB HEADERS
    src/*.h
    src/*/*.h
    )

if(ANDROID)
    add_library(SingerVoiceTester SHARED
      ${SOURCES}
      ${HEADERS}
      qml.qrc
      ${TS_FILES}
    )
else()
    if (WIN32)
        set(WIN32_ON_OFF_SWITCH "WIN32")
    else ()
        set(WIN32_ON_OFF_SWITCH "")
    endif ()
    add_executable(SingerVoiceTester
      ${WIN32_ON_OFF_SWITCH}
      ${SOURCES}
      ${HEADERS}
      qml.qrc
      ${TS_FILES}
    )
endif()

target_compile_definitions(SingerVoiceTester
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)

target_link_libraries(SingerVoiceTester
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick)

if(ANDROID)
    target_link_libraries(SingerVoiceTester
      PRIVATE IntonCore Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::QuickControls2
        Qt${QT_VERSION_MAJOR}::Widgets Qt${QT_VERSION_MAJOR}::Charts Qt${QT_VERSION_MAJOR}::Multimedia
        Qt${QT_VERSION_MAJOR}::MultimediaWidgets Qt${QT_VERSION_MAJOR}::AndroidExtras)
else()
    target_link_libraries(SingerVoiceTester
      PRIVATE IntonCore Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::QuickControls2
        Qt${QT_VERSION_MAJOR}::Widgets Qt${QT_VERSION_MAJOR}::Charts Qt${QT_VERSION_MAJOR}::Multimedia
        Qt${QT_VERSION_MAJOR}::MultimediaWidgets)
endif()

qt5_create_translation(QM_FILES ${CMAKE_SOURCE_DIR} ${TS_FILES})
