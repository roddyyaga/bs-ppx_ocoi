#!/bin/sh
opam switch create . ocaml-base-compiler.4.06.1 --no-install &&
eval $(opam env) &&
opam pin add -yn exe . &&
echo 'Pinned\n' &&
opam install --deps-only . &&
rm pp_exe/pp.exe &&
dune build @all &&
mv _build/default/pp_exe/pp.exe pp_exe/pp.exe
