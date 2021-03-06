# GCCコンパイラ環境を持つdebianイメージ
# 日本語化も設定済み
FROM        kagalpandh/kacpp-gccdev
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         DEBIAN_FORONTEND=noninteractive
ENV         PYTHON_VERSION=3.9.2
ENV         PYTHON_DEST=Python-${PYTHON_VERSION}
ENV         PYTHON_SRC_FILE=${PYTHON_DEST}.tar.xz
ENV         PYTHON_URL=
COPY        python-source-install.txt  /usr/local/sh/apt-install
# 開発環境インストール
RUN         apt update \
            /usr/local/sh/system/apt-install.sh install gccdev.txt \
            && /usr/local/sh/system/apt-install.sh install python-source-install.txt \

#終了処理
RUN         apt clean && rm -rf /var/lib/apt/lists/*
