macro(util_add_program_base program_name default_switch append_var)
    string(TOUPPER ${program_name} upper_program_name)
    set(USE_${upper_program_name} "run ${program_name}" ${default_switch})
    if(USE_${upper_program_name})
        find_program(${append_var} NAMES ${program_name})
        if(NOT ${append_var})
            message(FATAL_ERROR "can't find ${program_name}")
        endif()

        cmake_parse_arguments(${program_name}_PARSED "" "EXTRA_FLAG;OVERRIDE_FLAG" "" ${ARGN})
        
        if((${program_name}_PARSED_EXTRA_FLAG) AND (${program_name}_PARSED_OVERRIDE_FLAG))
            message(FATAL_ERROR "EXTRA_FLAG and OVERRIDE_FLAG can't be defined at the same time")
        endif()

        set(${program_name}_program_flag ${ARGN})
        if(${program_name}_PARSED_EXTRA_FLAG)
            string(APPEND ${program_name}_program_flag " " ${${program_name}_PARSED_EXTRA_FLAG})
        endif()
        if(${program_name}_PARSED_OVERRIDE_FLAG)
            set(${program_name}_program_flag ${${program_name}_PARSED_OVERRIDE_FLAG})
        endif()

        list(APPEND ${append_var} ${${program_name}_program_flag})
    endif()
endmacro()

# has 2 optional args
# util_add_cppcheck EXTRA_FLAG extra_flag OVERRIDE_FLAG override_flag
macro(util_add_cppcheck)
    util_add_program_base(cppcheck 
                          OFF 
                          CMAKE_CXX_CPPCHECK
                          "--enable=all"
                          "-q"
                          "--force"
                          "--suppressions-list=${util_cmake_dir}/cppcheck_suppression.txt")
endmacro()

# has 2 optional args
# util_add_cpplint EXTRA_FLAG extra_flag OVERRIDE_FLAG override_flag
macro(util_add_cpplint)
    util_add_program_base(cpplint 
                          OFF 
                          CMAKE_CXX_CPPLINT
                          "--filter=-legal/copyright, -whitespace/line_length, -whitespace/ending_newline, -build/c++11, -runtime/references, -whitespace/indent"
                          "--quiet")
endmacro()

macro(util_check_and_enable_test)
    option(RUN_TEST "Run unit test as part of build" OFF)
    if(RUN_TEST)
        enable_testing()
    endif()
endmacro()