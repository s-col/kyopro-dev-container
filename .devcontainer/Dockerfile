FROM ubuntu:18.04

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND noninteractive

ENV PYTHON_VERSION 3.8.1

ENV HOME /root
ENV PYENV_ROOT $HOME/.pyenv 
ENV PATH $PYENV_ROOT/bin:$PATH

RUN set -x \
    && apt update \
    && apt -y upgrade --no-install-recommends \
    #
    # ロケールの設定(これは要らないかもしれない)
    && apt -y install --no-install-recommends \
    language-pack-ja \
    && update-locale LANG=ja_JP.UTF-8 \
    #
    # g++9 のインストール
    && apt -y install --no-install-recommends \
    build-essential \
    manpages-dev \
    software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt -y install --no-install-recommends \
    gcc-9 \
    g++-9 \
    gdb \
    && update-alternatives --install \
    /usr/bin/gcc gcc /usr/bin/gcc-9 90 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-9 \
    --slave /usr/bin/gcov gcov /usr/bin/gcov-9 \
    #
    # boost のインストール
    && apt -y install --no-install-recommends libboost-all-dev \
    #
    # pyenvのインストール
    && apt -y install --no-install-recommends \
    make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libffi-dev liblzma-dev python-openssl git \
    && git clone https://github.com/pyenv/pyenv.git ~/.pyenv \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc

RUN set -x \
    #
    # pyenv の設定
    && pyenv install ${PYTHON_VERSION} \
    && pyenv global ${PYTHON_VERSION}

RUN set -x \
    #
    # ChromiumとChromium Driverのインストール
    && apt -y install --no-install-recommends \
    chromium-browser \
    chromium-chromedriver

RUN set -x \
    && eval "$(pyenv init -)" \
    #
    # pythonライブラリのインストール
    && pip install -U pip \
    && pip install pylint autopep8 \
    && pip install beautifulsoup4 selenium \
    && pip install numpy matplotlib scipy \
    #
    # Clean up
    && apt autoremove -y \
    && apt clean -y

ENV DEBIAN_FRONTEND dialog