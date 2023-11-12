FROM ubuntu:22.04

SHELL [ "/bin/bash", "-c" ]

# リポジトリを日本のミラーサーバーに変更
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

# タイムアウト防止
RUN echo -e "Acquire::http::Timeout \"300\";\nAcquire::ftp::Timeout \"300\";" >> /etc/apt/apt.conf.d/99timeout

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    g++-12 \
    gdb \
    time \
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

# Python を Pyenv でインストール
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

# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# ENV PATH="/root/.cargo/bin:${PATH}"

# 競プロで必要な設定などを実行
RUN echo 'alias ttt='\''/usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P"'\' >> ~/.bashrc && \
    echo 'export ASAN_OPTIONS=detect_leaks=0' >> ~/.bashrc && \
    echo '#include <bits/stdc++.h>' >> /tmp/precompile_header.hpp && \
    mkdir -p /usr/local/include/procon_gch/bits/stdc++.h.gch/ && \
    g++-12 -O0 -g3 -Wall -Wextra -std=gnu++23 -fsanitize=undefined,address -fno-omit-frame-pointer \
    -DSCOLDEBUG -DFILEINPUT -DFILEOUTPUT \
    -x c++-header \
    /tmp/precompile_header.hpp \
    -o /usr/local/include/procon_gch/bits/stdc++.h.gch/g++12_gnu++23.gch && \
    echo '#include <bits/stdc++.h>' | \
    g++-12 -O2 -g3 -Wall -Wextra -std=gnu++23 -DFILEINPUT -DFILEOUTPUT \
    -x c++-header \
    /tmp/precompile_header.hpp \
    -o /usr/local/include/procon_gch/bits/stdc++.h.gch/g++12_gnu++23_optim.gch
