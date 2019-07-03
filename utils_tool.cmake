macro(util_add_program_base program_name default_switch append_var)
    string(TOUPPER ${program_name} upper_program_name)
    set(USE_${upper_program_name} "run ${program_name}" ${default_switch})
    if(USE_${upper_program_name})
        find_program(${append_var} NAMES ${program_name})
        if(NOT ${append_var})
            message(FATAL_ERROR "can't find ${program_name}")
        endif()

        cmake_parse_arguments(${program_name}_PARSED "" "" "EXTRA_FLAG;OVERRIDE_FLAG" ${ARGN})
        
        if((${program_name}_PARSED_EXTRA_FLAG) AND (${program_name}_PARSED_OVERRIDE_FLAG))
            message(FATAL_ERROR "EXTRA_FLAG and OVERRIDE_FLAG can't be defined at the same time")
        endif()

        set(${program_name}_program_flag ${ARGN})
        if(${program_name}_PARSED_EXTRA_FLAG)
            list(APPEND ${program_name}_program_flag ${${program_name}_PARSED_EXTRA_FLAG})
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

# util_set_general_code_gen_option(CPP_STANDARD cpp_std EXTRA_COMPILE_FLAG flag1 flag2 EXTRA_LINK_FLAG flag1 flag2)
macro(util_set_general_code_gen_option)
    cmake_parse_arguments(CODE_GEN_PARSED "" "CPP_STANDARD" "EXTRA_COMPILE_FLAG;EXTRA_LINK_FLAG" ${ARGN})

    if(CODE_GEN_PARSED_CPP_STANDARD)
        set(CMAKE_CXX_STANDARD ${CODE_GEN_PARSED_CPP_STANDARD})
    else()
        set(CMAKE_CXX_STANDARD 17)
    endif()

    set(util_compile_flag -Wall
                          -Wextra
                          -Werror
                          -Wnon-virtual-dtor
                          -Wold-style-cast
                          -Woverloaded-virtual
                          -Wsign-conversion
                          -Wconversion
                          -Wduplicated-cond
                          -Wduplicated-branches
                          -Wlogical-op
                          -Wnull-dereference
                          -Wuseless-cast
                          -Wformat=2
                          -Wdouble-promotion
                          -fasynchronous-unwind-tables
                          -fstack-protector
                          -fstack-protector-strong
                          -fPIC
                          -shared
                          -pipe
                          -fsanitize=address
                          -fsanitize=undefined
                          -g
                          -fdiagnostics-color=always
                          -fno-omit-frame-pointer)
    if(CODE_GEN_PARSED_EXTRA_COMPILE_FLAG)
        list(APPEND util_compile_flag ${CODE_GEN_PARSED_EXTRA_COMPILE_FLAG})
    endif()
    set_property(DIRECTORY PROPERTY COMPILE_OPTIONS ${util_compile_flag})

    set(util_link_flag -fsanitize=address -fsanitize=undefined)
    if(CODE_GEN_PARSED_EXTRA_LINK_FLAG)
        list(APPEND util_link_flag ${CODE_GEN_PARSED_EXTRA_LINK_FLAG})
    endif()
    set_property(DIRECTORY PROPERTY LINK_OPTIONS ${util_link_flag})
endmacro()

macro(util_set_external_code_gen_option)
    set_property(DIRECTORY PROPERTY 
                           COMPILE_OPTIONS -g 
                                           -fsanitize=address
                                           -fsanitize=undefined)
    set_property(DIRECTORY PROPERTY 
                           LINK_OPTIONS -fsanitize=address
                                        -fsanitize=undefined)
    # foreach(arg IN ITEMS ${ARGN})
        # set_target_properties(${arg} PROPERTIES CMAKE_CXX_STANDARD 17)
        # set_property(
        # TARGET ${arg}
        # PROPERTY COMPILE_OPTIONS -g 
        #                          -fsanitize=address
        #                          -fsanitize=undefined)
        # set_property(
        # TARGET ${arg}
        # PROPERTY LINK_OPTIONS -fsanitize=address 
        #                       -fsanitize=undefined)
    # endforeach()
endmacro()