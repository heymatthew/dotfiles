#!/usr/bin/env julia

using Pkg

# Jupyter notebook integration
# https://juliapackages.com/p/ijulia
Pkg.add("IJulia")          # Integration with Jupyter notebooks

# Vim's Ale linting integration
# https://github.com/dense-analysis/ale/blob/master/ale_linters/julia/languageserver.vim
Pkg.add("LanguageServer")
Pkg.add("StaticLint")
Pkg.add("SymbolServer")
