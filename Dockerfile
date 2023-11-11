FROM ubuntu:22.04

SHELL [ "/bin/bash", "-c" ]

RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    g++-12 \
    gdb \
    libboost-dev \
    libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git && \
    update-alternatives --install \
    /usr/bin/gcc gcc /usr/bin/gcc-12 90 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-12 \
    --slave /usr/bin/gcov gcov /usr/bin/gcov-12 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile && \
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile && \
    echo 'eval "$(pyenv init -)"' >> ~/.profile && \
    export PYENV_ROOT="$HOME/.pyenv" && \
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init -)" && \
    latest_python=$(pyenv install --list | grep -E '^\s*3.11' | tail -1 | tr -d '[:space:]') && \
    pyenv install $latest_python && \
    pyenv global $latest_python

RUN git clone --recursive https://github.com/s-col/kyopro_ubuntu.git ~/procon

WORKDIR /root/procon

RUN echo 'export ASAN_OPTIONS=detect_leaks=0' >> ~/.bashrc && \
    mkdir -p in_out src include/bits/stdc++.h.gch && \
    touch in_out/{input,output}.txt src/{A,B,C,D,E,F,G,H,I,misc}.cpp && \
    touch make_gch.cpp && \
    echo '#include <bits/stdc++.h>' >> make_gch.cpp && \
    g++-12 -O0 -g3 -Wall -Wextra -std=gnu++23 -fsanitize=undefined,address -fno-omit-frame-pointer \
    -DSCOLDEBUG -DFILEINPUT -DFILEOUTPUT \
    -I/home/scol/dev/kyopro/kyopro_ubuntu/include \
    -I/home/scol/dev/kyopro/kyopro_ubuntu/ac-library \
    -I/home/scol/dev/kyopro/kyopro_ubuntu \
    -x c++-header \
    make_gch.cpp \
    -o include/bits/stdc++.h.gch/g++12_gnu++23.gch && \
    g++-12 -O2 -g3 -Wall -Wextra -std=gnu++23 -DFILEINPUT -DFILEOUTPUT \
    -I/home/scol/dev/kyopro/kyopro_ubuntu/include \
    -I/home/scol/dev/kyopro/kyopro_ubuntu/ac-library \
    -I/home/scol/dev/kyopro/kyopro_ubuntu \
    -x c++-header \
    make_gch.cpp \
    -o include/bits/stdc++.h.gch/g++12_gnu++23_optim.gch && \
    rm make_gch.cpp
