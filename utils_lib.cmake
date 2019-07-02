include(FetchContent)

# util_add_external_header_lib DEST_DIR src_dir INCLUDE_DIR incl_dir
function(util_add_external_header_lib
         lib_name
         repo_link
         repo_tag)
    cmake_parse_arguments(PARSED "" "DEST_DIR;INCLUDE_DIR" "" ${ARGN})

    if(PARSED_DEST_DIR)
        FetchContent_Declare(${lib_name}_content
        GIT_REPOSITORY ${repo_link}
        GIT_TAG ${repo_tag}
        SOURCE_DIR ${PARSED_DEST_DIR})
    else()
        FetchContent_Declare(${lib_name}_content
                            GIT_REPOSITORY ${repo_link}
                            GIT_TAG ${repo_tag})
    endif()
    if(NOT ${lib_name}_content_POPULATED)
        FetchContent_Populate(${lib_name}_content)
        add_library(${lib_name} INTERFACE)
        if(DEFINED PARSED_INCLUDE_DIR)
            # check if was passed in variable value or name of variable
            if(DEFINED ${PARSED_INCLUDE_DIR})
                target_include_directories(
                    ${lib_name} SYSTEM
                    INTERFACE ${${PARSED_INCLUDE_DIR}})
            else()
                target_include_directories(
                    ${lib_name} SYSTEM
                    INTERFACE ${PARSED_INCLUDE_DIR})
            endif()
        else()
            target_include_directories(
                ${lib_name} SYSTEM
                INTERFACE ${${lib_name}_content_SOURCE_DIR}/include)
        endif()
    endif()
endfunction()

function(util_add_external_lib
         lib_name
         repo_link
         repo_tag)
    FetchContent_Declare(${lib_name}_content
    GIT_REPOSITORY ${repo_link}
    GIT_TAG ${repo_tag})
    FetchContent_MakeAvailable(${lib_name}_content)
endfunction()
