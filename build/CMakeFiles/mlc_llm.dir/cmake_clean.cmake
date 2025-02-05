file(REMOVE_RECURSE
  "libmlc_llm.dylib"
  "libmlc_llm.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/mlc_llm.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
