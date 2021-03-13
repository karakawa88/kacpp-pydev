# Python開発環境を持つdebianイメージ
# 日本語化も設定済み
FROM        kagalpandh/kacpp-gccdev AS builder
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         DEBIAN_FORONTEND=noninteractive
ENV         PYTHON_VERSION=3.9.2
ENV         PYTHON_DEST=Python-${PYTHON_VERSION}
ENV         PYTHON_SRC_FILE=${PYTHON_DEST}.tar.xz
ENV         PYTHON_URL=https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_SRC_FILE}
ENV         PYTHON_HOME=/usr/local/${PYTHON_DEST}
ENV         PATH=${PYTHON_HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
ENV         LD_LIBRARY_PATH=${PYTHON_HOME}/lib
COPY        python-source-install.txt  /usr/local/sh/apt-install
# 開発環境インストール
RUN         apt update \
            && /usr/local/sh/system/apt-install.sh install gccdev.txt \
            && /usr/local/sh/system/apt-install.sh install python-source-install.txt \
            && wget ${PYTHON_URL} && tar -Jxvf ${PYTHON_SRC_FILE} && cd ${PYTHON_DEST} \
                &&  ./configure --prefix=/usr/local/${PYTHON_DEST} --with-ensurepip --enable-shared \
                && make && porg -lD "make install"  \
            && /usr/local/sh/system/apt-install.sh uninstall gccdev.txt \
                && apt autoremove -y && apt clean && rm -rf /var/lib/apt/lists/* \
                && cd ../ && rm -rf ${PYTHON_DEST}*
FROM        kagalpandh/kacpp-ja
SHELL       [ "/bin/bash", "-c" ]
WORKDIR     /root
ENV         PYTHON_VERSION=3.9.2
ENV         PYTHON_DEST=Python-${PYTHON_VERSION}
ENV         PYTHON_HOME=/usr/local/${PYTHON_DEST}
ENV         PATH=${PYTHON_HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
ENV         LD_LIBRARY_PATH=${PYTHON_HOME}/lib
COPY        --from=builder /usr/local/${PYTHON_DEST}/ ${PYTHON_HOME}
COPY        python-source-install.txt .
COPY        rcprofile /etc/rc.d
RUN         apt update && \
            cat python-source-install.txt | xargs apt install -y && apt install -y porg && \
#   porgでPythonをパッケージ管理
#             chown -R root.root /usr/local && \
#             find ${PYTHON_HOME} -type f -print | xargs porg -l -p ${PYTHON_DEST} && \
            cd /usr/local && ln -s ${PYTHON_DEST} python && \
            echo "/usr/local/python/lib" >>/etc/ld.so.conf && ldconfig && \
            ${PYTHON_HOME}/bin/pip3 install --upgrade setuptools pip && ${PYTHON_HOME}/bin/pip3 install ez_setup && \
            cd ~/ && apt clean && rm -rf /var/lib/apt/lists/* && rm -f python-source-install.txt
