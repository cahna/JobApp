FROM debian:11-slim as installer
ARG DEBIAN_FRONTEND=noninteractive

ENV HOME=/latex TEXMFHOME=/latex TEXMFVAR=/latex/texmf-var TEXMFCONFIG=/latex/texmf-config 

RUN apt-get update && \
    apt-get --no-install-recommends install -y \
      texlive \
      texlive-luatex \
      gnupg \
      wget \
      xz-utils \
      fonts-liberation \
      fontconfig \
      fonts-croscore \
      fonts-crosextra-carlito && \
    rm -rf /var/lib/apt/lists/* && \
    fc-cache -fsv && \
    mkdir -p /latex/texmf

RUN tlmgr init-usertree && \
    tlmgr option repository ftp://tug.org/historic/systems/texlive/2020/tlnet-final && \
    tlmgr update --all && \
    tlmgr install \
        collection-latex \
        collection-luatex

RUN tlmgr install \
      fontspec \
      opensans \
      titlesec \
      xcolor \
      enumitem \
      arimo && \
    mkdir -p /latex/tex/latex/jobapp

RUN fc-cache -fsv && \
    fmtutil-user --all --no-strict && \
    luaotfload-tool -u

COPY jobapp.sty /latex/tex/latex/jobapp/

RUN mktexlsr

ENV TEXMFCACHE=/tmp
WORKDIR /data
VOLUME ["/data"]

