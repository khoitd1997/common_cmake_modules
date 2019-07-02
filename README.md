# Util CMake Modules

CMake modules useful for many projects

## Structure

- ```CMakeLists.txt```: main cmake file, include other modules to make them available, also set some global variable
- ```utils_lib.cmake```: module dealing with working with library such as fetching external header library
- ```utils_tool.cmake```: module dealing with tooling such as cppcheck, cpplint, test, etc

## Usage

The functions and macros of the modules all have ```utils_``` to avoid naming collision

The best way to use the repo is with ```FetchContent_Declare```, this will make all modules accessible:

```cmake
# inside top CMakeLists.txt
FetchContent_Declare(
  util_cmake_content
  GIT_REPOSITORY https://github.com/khoitd1997/util_cmake_modules.git
  GIT_TAG origin/master)
FetchContent_MakeAvailable(util_cmake_content)
```
