# The macro choose_msvc_crt() takes a list of possible
# C runtimes to choose from, in the form of compiler flags,
# to present to the user. (MTd for /MTd, etc)
#
# The macro is invoked at the end of the file.
#
# CMake already sets CRT flags in the CMAKE_CXX_FLAGS_* and
# CMAKE_C_FLAGS_* variables by default. To let the user
# override that for each build type:
# 1. Detect which CRT is already selected, and reflect this in
# LLVM_USE_CRT_* so the user can have a better idea of what
# changes they're making.
# 2. Replace the flags in both variables with the new flag via a regex.
# 3. set() the variables back into the cache so the changes
# are user-visible.

### Helper macros: ###
macro(make_crt_regex regex crts)
  set(${regex} "")
  foreach(crt ${${crts}})
    # Trying to match the beginning or end of the string with stuff
    # like [ ^]+ didn't work, so use a bunch of parentheses instead.
    set(${regex} "${${regex}}|(^| +)/${crt}($| +)")
  endforeach(crt)
  string(REGEX REPLACE "^\\|" "" ${regex} "${${regex}}")
endmacro(make_crt_regex)

macro(get_current_crt crt_current regex flagsvar)
  # Find the selected-by-CMake CRT for each build type, if any.
  # Strip off the leading slash and any whitespace.
  string(REGEX MATCH "${${regex}}" ${crt_current} "${${flagsvar}}")
  string(REPLACE "/" " " ${crt_current} "${${crt_current}}")
  string(STRIP "${${crt_current}}" ${crt_current})
endmacro(get_current_crt)

# Replaces or adds a flag to a variable.
# Expects 'flag' to be padded with spaces.
macro(set_flag_in_var flagsvar regex flag)
  string(REGEX MATCH "${${regex}}" current_flag "${${flagsvar}}")
  if("${current_flag}" STREQUAL "")
    set(${flagsvar} "${${flagsvar}}${${flag}}")
  else()
    string(REGEX REPLACE "${${regex}}" "${${flag}}" ${flagsvar} "${${flagsvar}}")
  endif()
  string(STRIP "${${flagsvar}}" ${flagsvar})
  # Make sure this change gets reflected in the cache/gui.
  # CMake requires the docstring parameter whenever set() touches the cache,
  # so get the existing docstring and re-use that.
  get_property(flagsvar_docs CACHE ${flagsvar} PROPERTY HELPSTRING)
  set(${flagsvar} "${${flagsvar}}" CACHE STRING "${flagsvar_docs}" FORCE)
endmacro(set_flag_in_var)


macro(choose_msvc_crt MSVC_CRT)
  if(LLVM_USE_CRT)
    message(FATAL_ERROR
      "LLVM_USE_CRT is deprecated. Use the CMAKE_BUILD_TYPE-specific
variables (LLVM_USE_CRT_DEBUG, etc) instead.")
  endif()

  make_crt_regex(MSVC_CRT_REGEX ${MSVC_CRT})

  foreach(build_type ${CMAKE_CONFIGURATION_TYPES} ${CMAKE_BUILD_TYPE})
    string(TOUPPER "${build_type}" build)
    if (NOT "${LLVM_USE_CRT_${build}}" STREQUAL "")
      if (NOT ${LLVM_USE_CRT_${build}} IN_LIST ${MSVC_CRT})
        message(FATAL_ERROR
          "Invalid value for LLVM_USE_CRT_${build}: ${LLVM_USE_CRT_${build}}. Valid options are one of: ${${MSVC_CRT}}")
      endif()
      set(library "MultiThreaded")
      if ("${LLVM_USE_CRT_${build}}" MATCHES "d$")
        set(library "${library}Debug")
      endif()
      if ("${LLVM_USE_CRT_${build}}" MATCHES "^MD")
        set(library "${library}DLL")
      endif()
      if(${runtime_library_set})
        message(WARNING "Conflicting LLVM_USE_CRT_* options")
      else()
        message(WARNING "The LLVM_USE_CRT_* options are deprecated, use the CMake provided CMAKE_MSVC_RUNTIME_LIBRARY setting instead")
      endif()
      set(CMAKE_MSVC_RUNTIME_LIBRARY "${library}" CACHE STRING "" FORCE)
      message(STATUS "Using VC++ CRT: ${CMAKE_MSVC_RUNTIME_LIBRARY}")
      set(runtime_library_set 1)
    endif()
    foreach(lang C CXX)
      # Clear any potentially manually set options from these variables.
      # Kept as temporary backwards compat (unsure if necessary).
      # TODO: We probably should remove it.
      set_flag_in_var(CMAKE_${lang}_FLAGS_${build} MSVC_CRT_REGEX "")
    endforeach(lang)
  endforeach(build_type)
endmacro(choose_msvc_crt MSVC_CRT)


# List of valid CRTs for MSVC
set(MSVC_CRT
  MD
  MDd
  MT
  MTd)

choose_msvc_crt(MSVC_CRT)

