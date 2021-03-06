# Build the app
FROM ocaml/opam2:alpine

WORKDIR /app

# TODO - work out why this is necessary
RUN cd /home/opam/opam-repository && git pull && cd /app

COPY exe.opam .
RUN opam switch create 4.06.1 &&\
    eval $(opam env)
RUN opam pin -yn exe .
RUN opam update
ENV OPAMSOLVERTIMEOUT=3600
RUN opam install --deps-only exe
# TODO - figure out exactly why chown necessary
# (taken from here https://medium.com/@bobbypriambodo/lightweight-ocaml-docker-images-with-multi-stage-builds-f7a060c7fce4)
# TODO - work out why the `eval` and `dune build` have to be in the same RUN step
# TODO - see if there is a better solution to copying depexts to production than this one
# (taken from same blog post)
# TODO - determine whether removing the egrep and sed from that post in the depext command was correct
# RUN sudo chown -R opam:nogroup . && opam depext -ln app > depexts
COPY . .
# RUN eval $(opam env) && sudo chown -R opam:nogroup . && dune external-lib-deps --missing @install && dune build @install
RUN dune build @all
# RUN eval $(opam env) && sudo chown -R opam:nogroup . && dune build @install && opam depext -ln app > depexts

# Create the production image
FROM alpine
WORKDIR /app
COPY --from=0 /app/_build/default/pp_exe/pp.exe main.exe

CMD ./main.exe
