cmake_minimum_required(VERSION 3.10.2)

# opencv
set(OpenCV_STATIC ON)
set(OpenCV_DIR C:\\opencv\\OpenCV-android-sdk\\sdk\\native\\jni)

find_package (OpenCV REQUIRED)

add_library( # Sets the name of the library.
        native_opencv
        SHARED
        # Provides a relative path to your source file(s).
        ../ios/Classes/car_detection/detection.cpp
        ../ios/Classes/native_opencv.cpp
        )

target_include_directories(
        native_opencv PRIVATE
        ../ios/Classes/car_detection
)

find_library(log-lib log)

target_link_libraries( # Specifies the target library.
        native_opencv
        ${OpenCV_LIBS}
        ${log-lib}
        )