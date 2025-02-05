file(REMOVE_RECURSE
  "libmlc_llm_module.dylib"
  "libmlc_llm_module.pdb"
)

# Per-language clean rules from dependency scanning.
foreach(lang CXX)
  include(CMakeFiles/mlc_llm_module.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
