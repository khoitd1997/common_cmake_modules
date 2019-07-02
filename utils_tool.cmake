macro(util_add_cppcheck extra_flag override_flag)
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

  if(${ARGC} EQUAL 1)
  string(APPEND cppcheck_flag " " ${extra_flag})
  endif()
  if(${ARGC} EQUAL 2)
  set(cppcheck_flag ${override_flag})
  endif()

  list(
    APPEND CMAKE_CXX_CPPCHECK
           ${cppcheck_flag})
endif()
endmacro()