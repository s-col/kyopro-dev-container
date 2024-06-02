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
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev git \
    python3.10 python3.10-venv python3.10-dev python3-pip && \
    update-alternatives --install \
    /usr/bin/gcc gcc /usr/bin/gcc-12 90 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-12 \
    --slave /usr/bin/gcov gcov /usr/bin/gcov-12 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# プリコンパイル済みヘッダを生成
RUN \
    # ファイル出力あり, 最適化なし
    echo '#include <bits/stdc++.h>' >> /tmp/precompile_header.hpp && \
    mkdir -p /usr/local/include/procon_gch/bits/stdc++.h.gch/ && \
    g++-12 -O0 -g3 -Wall -Wextra -std=gnu++23 -fsanitize=undefined,address -fno-omit-frame-pointer \
    -DSCOLDEBUG -DFILEINPUT -DFILEOUTPUT \
    -x c++-header \
    /tmp/precompile_header.hpp \
    -o /tmp/g++12_gnu++23.gch && \
    mv /tmp/g++12_gnu++23.gch /usr/local/include/procon_gch/bits/stdc++.h.gch/g++12_gnu++23.gch && \
    # ファイル出力あり, 最適化あり
    g++-12 -O2 -g3 -Wall -Wextra -std=gnu++23 -DFILEINPUT -DFILEOUTPUT \
    -x c++-header \
    /tmp/precompile_header.hpp \
    -o /tmp/g++12_gnu++23_optim.gch && \
    mv /tmp/g++12_gnu++23_optim.gch /usr/local/include/procon_gch/bits/stdc++.h.gch/g++12_gnu++23_optim.gch && \
    # ファイル出力なし, 最適化なし
    g++-12 -O0 -g3 -Wall -Wextra -std=gnu++23 -fsanitize=undefined,address -fno-omit-frame-pointer -DSCOLDEBUG \
    -x c++-header \
    /tmp/precompile_header.hpp \
    -o /tmp/g++12_gnu++23_stdio.gch && \
    mv /tmp/g++12_gnu++23_stdio.gch /usr/local/include/procon_gch/bits/stdc++.h.gch/g++12_gnu++23_stdio.gch && \
    # ファイル出力なし, 最適化あり
    g++-12 -O2 -g3 -Wall -Wextra -std=gnu++23 \
    -x c++-header \
    /tmp/precompile_header.hpp \
    -o /tmp/g++12_gnu++23_stdio_optim.gch && \
    mv /tmp/g++12_gnu++23_stdio_optim.gch /usr/local/include/procon_gch/bits/stdc++.h.gch/g++12_gnu++23_stdio_optim.gch

# ユーザを作成
ARG USERNAME="procon"
ARG GROUPNAME="procon"
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME
USER $USERNAME

# Rust をインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# パスの設定
ENV PATH="${PATH}:/home/${USERNAME}/.local/bin"

# oj のインストールとエイリアスの設定
RUN pip install online-judge-tools && \
    echo 'alias ojd="rm -rf test/ && oj d"' >> /home/${USERNAME}/.bashrc && \
    echo 'alias ttt='\''/usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P"'\' >> /home/${USERNAME}/.bashrc && \
    echo 'alias python=python3.10' >> /home/${USERNAME}/.bashrc && \
    echo 'export ASAN_OPTIONS=detect_leaks=0' >> /home/${USERNAME}/.bashrc
