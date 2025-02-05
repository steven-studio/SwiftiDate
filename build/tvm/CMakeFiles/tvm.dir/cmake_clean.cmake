file(REMOVE_RECURSE
  "libtvm.dylib"
  "libtvm.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/tvm.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
