# kacpp-pydev Python開発環境Dockerイメージ

## 概要
Pythonをソースからインストールして設定したDockerイメージ。
Pythonのソースは3.10.8である。
debian:bullseye-slimイメージを基に作成されている。

## 使い方
```shell
docker image pull kagalpandh/kacpp-pydev
docker run -dit --name kacpp-pydev kagalpandh/kacpp-pydev
```

## 説明
Pythonをソースからインストールしてある。
インストール場所は/usr/local/Python-{PYTHON_VERSION}である。
Pythonをコンパイルする際にgccなどを使用するがこのイメージにはGCC開発環境は
インストールされていない。


##構成
Pythonのインストール場所は/usr/local/Python-${PYTHON_VERSION}である。
これをPYTHON_HOMEという環境変数で参照できここに/usr/local/pythonでリンクが貼ってある。
PATHもとうしてある(/usr/local/Python-{VERSION}/bin)。

##ベースイメージ
kagalpandh/kacpp-base

# その他
DockerHub: [kagalpandh/kacpp-pydev](https://hub.docker.com/repository/docker/kagalpandh/kacpp-pydev)<br />
GitHub: [karakawa88/kacpp-ja](https://github.com/karakawa88/kacpp-pydev)

