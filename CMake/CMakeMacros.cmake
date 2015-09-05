# Borrowed from http://stackoverflow.com/a/3323227/445373
function(sm_list_replace container index newvalue)
  list(INSERT ${container} ${index} ${newvalue})
  math(EXPR __INDEX "${index} + 1")
  list(REMOVE_AT ${container} ${__INDEX})
endfunction()

function(sm_append_simple_target_property target property str)
  get_target_property(current_property ${target} ${property})
  if (current_property)
    list(APPEND current_property ${str})
    set_target_properties(${target} PROPERTIES ${property} "${current_property}")
  else()
    set_target_properties(${target} PROPERTIES ${property} ${str})
  endif()
endfunction()

# Borrowed from http://stackoverflow.com/a/7172941/445373
# TODO: Upgrade to cmake 3.x so that this function is not needed.
function(sm_join values glue output)
  string(REPLACE ";" "${glue}" _TMP_STR "${values}")
  set(${output} "${_TMP_STR}" PARENT_SCOPE)
endfunction()

function(sm_add_compile_definition target def)
  sm_append_simple_target_property(${target} COMPILE_DEFINITIONS ${def})
endfunction()

function(sm_add_compile_flag target flag)
  sm_append_simple_target_property(${target} COMPILE_FLAGS ${flag})
endfunction()

function(sm_add_link_flag target flag)
  if (MSVC)
    # Use a modified form of sm_append_simple_target_property.
    get_target_property(current_property ${target} LINK_FLAGS)
    if (current_property)
      set_target_properties(${target} PROPERTIES LINK_FLAGS "${current_property} ${flag}")
    else()
      set_target_properties(${target} PROPERTIES LINK_FLAGS ${flag})
    endif()
  else()
    sm_append_simple_target_property(${target} LINK_FLAGS ${flag})
  endif()
endfunction()

function(disable_project_warnings projectName)
  if (NOT WITH_EXTERNAL_WARNINGS)
    if (MSVC)
      sm_add_compile_flag(${projectName} "/W0")
    elseif(APPLE)
      set_target_properties(${projectName} PROPERTIES XCODE_ATTRIBUTE_GCC_WARN_INHIBIT_ALL_WARNINGS "YES")
    else()
      set_target_properties(${projectName} PROPERTIES COMPILE_FLAGS "-w")
    endif()
  endif()
endfunction()

