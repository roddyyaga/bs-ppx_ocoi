#!/bin/sh
opam switch create . ocaml-base-compiler.4.06.1 --no-install &&
eval $(opam env) &&
opam pin add -yn exe . &&
opam install --deps-only -y . &&
rm pp_exe/pp.exe
dune build @all --root . &&
mv _build/default/pp_exe/pp.exe pp_exe/pp.exe
