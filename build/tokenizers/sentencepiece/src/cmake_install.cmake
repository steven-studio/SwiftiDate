# Install script for directory: /Users/youzhewei/Desktop/SwiftiDate/mlc-llm/3rdparty/tokenizers-cpp/sentencepiece/src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/Users/youzhewei/Desktop/SwiftiDate/build")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "TRUE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/youzhewei/Desktop/SwiftiDate/build/tokenizers/sentencepiece/src/libsentencepiece.a")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libsentencepiece.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libsentencepiece.a")
    execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libsentencepiece.a")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/youzhewei/Desktop/SwiftiDate/build/tokenizers/sentencepiece/src/libsentencepiece_train.a")
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libsentencepiece_train.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libsentencepiece_train.a")
    execute_process(COMMAND "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libsentencepiece_train.a")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE DIRECTORY FILES "/Users/youzhewei/Desktop/SwiftiDate/build/tokenizers/sentencepiece/src/spm_encode.app" USE_SOURCE_PERMISSIONS)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_encode.app/spm_encode" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_encode.app/spm_encode")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/Users/youzhewei/Desktop/SwiftiDate/build/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_encode.app/spm_encode")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE DIRECTORY FILES "/Users/youzhewei/Desktop/SwiftiDate/build/tokenizers/sentencepiece/src/spm_decode.app" USE_SOURCE_PERMISSIONS)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_decode.app/spm_decode" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_decode.app/spm_decode")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/Users/youzhewei/Desktop/SwiftiDate/build/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_decode.app/spm_decode")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE DIRECTORY FILES "/Users/youzhewei/Desktop/SwiftiDate/build/tokenizers/sentencepiece/src/spm_normalize.app" USE_SOURCE_PERMISSIONS)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_normalize.app/spm_normalize" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_normalize.app/spm_normalize")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/Users/youzhewei/Desktop/SwiftiDate/build/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_normalize.app/spm_normalize")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE DIRECTORY FILES "/Users/youzhewei/Desktop/SwiftiDate/build/tokenizers/sentencepiece/src/spm_train.app" USE_SOURCE_PERMISSIONS)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_train.app/spm_train" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_train.app/spm_train")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/Users/youzhewei/Desktop/SwiftiDate/build/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_train.app/spm_train")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/bin" TYPE DIRECTORY FILES "/Users/youzhewei/Desktop/SwiftiDate/build/tokenizers/sentencepiece/src/spm_export_vocab.app" USE_SOURCE_PERMISSIONS)
  if(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_export_vocab.app/spm_export_vocab" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_export_vocab.app/spm_export_vocab")
    execute_process(COMMAND /usr/bin/install_name_tool
      -add_rpath "/Users/youzhewei/Desktop/SwiftiDate/build/lib"
      "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/bin/spm_export_vocab.app/spm_export_vocab")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE FILE FILES
    "/Users/youzhewei/Desktop/SwiftiDate/mlc-llm/3rdparty/tokenizers-cpp/sentencepiece/src/sentencepiece_trainer.h"
    "/Users/youzhewei/Desktop/SwiftiDate/mlc-llm/3rdparty/tokenizers-cpp/sentencepiece/src/sentencepiece_processor.h"
    )
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/Users/youzhewei/Desktop/SwiftiDate/build/tokenizers/sentencepiece/src/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
