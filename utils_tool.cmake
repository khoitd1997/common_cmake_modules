macro(util_add_program_base program_name default_switch default_flag append_var)
string(TOUPPER ${program_name} upper_program_name)
option(USE_${upper_program_name} "run ${program_name}" ${default_switch})
if(USE_${upper_program_name})
    find_program(append_var NAMES ${program_name})
    if(NOT append_var)
        message(FATAL_ERROR "can't find ${program_name}")
    endif()

    set(program_flag ${default_flag})
    cmake_parse_arguments(PARSED "" "EXTRA_FLAG;OVERRIDE_FLAG" "" ${ARGN})

    if((PARSED_EXTRA_FLAG) AND (PARSED_OVERRIDE_FLAG))
        message(FATAL_ERROR "EXTRA_FLAG and OVERRIDE_FLAG can't be defined at the same time")
    endif()
    if(PARSED_EXTRA_FLAG)
        string(APPEND program_flag " " ${PARSED_EXTRA_FLAG})
    endif()
    if(PARSED_OVERRIDE_FLAG)
        set(program_flag ${PARSED_OVERRIDE_FLAG})
    endif()

    list(APPEND ${append_var} ${program_flag})
endif()
endmacro()

# has 2 optional args
# util_add_cppcheck EXTRA_FLAG extra_flag OVERRIDE_FLAG override_flag
function(util_add_cppcheck)
util_add_program_base(cppcheck 
                      OFF 
                      "--enable=all -q --force --suppressions-list=${CMAKE_SOURCE_DIR}/cppcheck_suppression.txt" 
                      CMAKE_CXX_CPPCHECK
                      )

# option(USE_CPPCHECK "Run cppcheck on the source files" OFF)
# if(USE_CPPCHECK)
#     find_program(CMAKE_CXX_CPPCHECK NAMES cppcheck)
#     if(NOT CMAKE_CXX_CPPCHECK)
#         message(FATAL_ERROR "can't find cppcheck")
#     endif()

#     set(cppcheck_flag 
#         "--enable=all"
#         "-q"
#         "--force"
#         "--suppressions-list=${CMAKE_SOURCE_DIR}/cppcheck_suppression.txt")

#     cmake_parse_arguments(PARSED "" "EXTRA_FLAG;OVERRIDE_FLAG" "" ${ARGN})

#     if((PARSED_EXTRA_FLAG) AND (PARSED_OVERRIDE_FLAG))
#         message(FATAL_ERROR "EXTRA_FLAG and OVERRIDE_FLAG can't be defined at the same time")
#     endif()
#     if(PARSED_EXTRA_FLAG)
#         string(APPEND cppcheck_flag " " ${PARSED_EXTRA_FLAG})
#     endif()
#     if(PARSED_OVERRIDE_FLAG)
#         set(cppcheck_flag ${PARSED_OVERRIDE_FLAG})
#     endif()

#     list(APPEND CMAKE_CXX_CPPCHECK ${cppcheck_flag})
# endif()
endfunction()