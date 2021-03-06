# Python開発環境を持つdebianイメージ
# 日本語化も設定済み
FROM        kagalpandh/kacpp-gccdev
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         DEBIAN_FORONTEND=noninteractive
ENV         PYTHON_VERSION=3.9.2
ENV         PYTHON_DEST=Python-${PYTHON_VERSION}
ENV         PYTHON_SRC_FILE=${PYTHON_DEST}.tar.xz
ENV         PYTHON_URL=https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_SRC_FILE}
COPY        python-source-install.txt  /usr/local/sh/apt-install
# 開発環境インストール
RUN         apt update \
            /usr/local/sh/system/apt-install.sh install gccdev.txt \
            && /usr/local/sh/system/apt-install.sh install python-source-install.txt \
            && wget ${PYTHON_URL} && tar -Jxvf ${PYTHON_SRC_FILE} && cd ${PYTHON_DEST} \
                &&  ./configure --prefix=/usr/local/${PYTHON_DEST} --with-ensurepip --enable-shared \
                && make && make install \
            && /usr/local/sh/system/apt-install.sh uninstall gccdev.txt \
                && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/* \
                && cd ../ && rm -rf ${PYTHON_DEST}
RUN         cd /usr/local && ln -s ${PYTHON_DEST} python
COPY        rcprofile /etc/rc.d
#終了処理
#RUN         apt clean && rm -rf /var/lib/apt/lists/*
