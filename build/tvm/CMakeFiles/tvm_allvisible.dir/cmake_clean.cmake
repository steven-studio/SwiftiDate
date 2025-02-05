file(REMOVE_RECURSE
  "libtvm_allvisible.dylib"
  "libtvm_allvisible.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/tvm_allvisible.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
