find_path(OMNIORB_INCLUDE omniORB4/omniORB.h ${CMAKE_CURRENT_LIST_DIR}/include)
  
find_path(OMNIORB_LIB omniORB4.lib ${CMAKE_CURRENT_LIST_DIR}/lib/amd64_win64)
find_program(OMNIORB_IDL omniidl.exe ${CMAKE_CURRENT_LIST_DIR}/bin/x86_win32) #TODO: Why is it ´not using the one in 64 bit folder?
  
add_definitions( -D__x86__ -D__NT__ -D__OSVERSION__=4 -D__WIN32__ )
if(${AZI_STATIC_LIBS})
  add_definitions(-D _WINSTATIC)
  set(OmniOrb_LIBRARIES optimized ${OMNIORB_LIB}/omniORB4.lib optimized ${OMNIORB_LIB}/omnithread.lib optimized ${OMNIORB_LIB}/omniDynamic4.lib debug ${OMNIORB_LIB}/omniORB4d.lib debug ${OMNIORB_LIB}/omnithreadd.lib debug ${OMNIORB_LIB}/omniDynamic4d.lib Ws2_32.lib)
else(${AZI_STATIC_LIBS})
  set(OmniOrb_LIBRARIES optimized ${OMNIORB_LIB}/omniORB4_rt.lib optimized ${OMNIORB_LIB}/omnithread_rt.lib optimized ${OMNIORB_LIB}/omniDynamic4_rt.lib debug ${OMNIORB_LIB}/omniORB4_rtd.lib debug ${OMNIORB_LIB}/omnithread_rtd.lib debug ${OMNIORB_LIB}/omniDynamic4_rtd.lib)
endif(${AZI_STATIC_LIBS})
    
include_directories( ${OMNIORB_INCLUDE} ${CMAKE_CURRENT_BINARY_DIR} )

#
# OmniIdl( output_files input1.idl input2.idl ... )
#
MACRO( OmniIdl _outlist )
  foreach( f ${ARGN} )
    string( REGEX REPLACE "(.*/)?([^/]+)\\.idl" "\\2SK.cc" _idl_result ${f} )
    string( REGEX REPLACE "(.*/)?([^/]+)\\.idl" "\\2.hh" _idl_result_h ${f} )
    add_custom_command( OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${_idl_result} ${CMAKE_CURRENT_BINARY_DIR}/${_idl_result_h}
      COMMAND ${OMNIORB_IDL} -bcxx -C${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/${f}
      DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${f} )
    set( ${_outlist} ${${_outlist}} ${_idl_result} ${_idl_result_h} )
    # conversion from 'size_t' to 'int', possible loss of data
    set_source_files_properties( ${_idl_result} PROPERTIES COMPILE_FLAGS /wd4267 )
    #set( ${_outlist} ${${_outlist}} ${CMAKE_CURRENT_BINARY_DIR}/${_idl_result} ${CMAKE_CURRENT_BINARY_DIR}/${_idl_result_h} )
  endforeach( f )
  include_directories( ${CMAKE_CURRENT_BINARY_DIR} )
ENDMACRO( OmniIdl )

macro(AziOmniOrb)
endmacro(AziOmniOrb)
