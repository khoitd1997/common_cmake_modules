# has 2 optional args
# util_add_cppcheck EXTRA_FLAG extra_flag OVERRIDE_FLAG override_flag
function(util_add_cppcheck)
option(USE_CPPCHECK "Run cppcheck on the source files" OFF)
if(USE_CPPCHECK)
    find_program(CMAKE_CXX_CPPCHECK NAMES cppcheck)
    if(NOT CMAKE_CXX_CPPCHECK)
        message(FATAL_ERROR "can't find cppcheck")
    endif()

    set(cppcheck_flag 
        "--enable=all"
        "-q"
        "--force"
        "--suppressions-list=${CMAKE_SOURCE_DIR}/cppcheck_suppression.txt")

    set(options)
    set(oneValueArgs EXTRA_FLAG OVERRIDE_FLAG)
    set(multiValueArgs)
    cmake_parse_arguments(util_add_cppcheck "${options}" "${oneValueArgs}"
    "${multiValueArgs}" ${ARGN})

    if(EXTRA_FLAG AND OVERRIDE_FLAG)
        message(FATAL_ERROR "EXTRA_FLAG and OVERRIDE_FLAG can't be defined at the same time")
    endif()
    if(EXTRA_FLAG)
        string(APPEND cppcheck_flag " " ${EXTRA_FLAG})
    endif()
    if(OVERRIDE_FLAG)
        set(cppcheck_flag ${OVERRIDE_FLAG})
    endif()

    list(APPEND CMAKE_CXX_CPPCHECK ${cppcheck_flag})
endif()
endfunction()