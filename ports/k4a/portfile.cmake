include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)
if(VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    message(FATAL_ERROR "This port does not currently support architecture: ${VCPKG_TARGET_ARCHITECTURE}")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO microsoft/Azure-Kinect-Sensor-SDK
    REF 17b644560ce7b4ee7dd921dfff0ae811aa54ede6
    SHA512 2746eebe5ef66c4b9d2215b6883723fca66dab77d405c662cc2af9364dc7fcd76aade396d23427db5797e0a534764eb2398890930ff3c792d0df8a681ce31462
    HEAD_REF v1.3.0
    PATCHES vcpkg_deps_and_lib_only.patch
)

function(dump_cmake_variables)
    get_cmake_property(_variableNames VARIABLES)
    list (SORT _variableNames)
    foreach (_variableName ${_variableNames})
        if (ARGV0)
            unset(MATCHED)
            string(REGEX MATCH ${ARGV0} MATCHED ${_variableName})
            if (NOT MATCHED)
                continue()
            endif()
        endif()
        message(STATUS "${_variableName}=${${_variableName}}")
    endforeach()
endfunction()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        "-DVCPKG_CURRENT_INSTALLED_DIR=${CURRENT_INSTALLED_DIR}"
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(COPY ${CURRENT_PACKAGES_DIR}/debug/share/k4a/k4aTargets-debug.cmake DESTINATION ${CMAKE_PACKAGES_DIR}/share/k4a/)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/k4a/copyright)
