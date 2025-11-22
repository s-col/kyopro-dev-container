FROM ubuntu:25.04

SHELL ["/bin/bash", "-c"]

# リポジトリを日本のミラーサーバーに変更
RUN sed -i 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list

# タイムアウト防止
RUN echo -e "Acquire::http::Timeout \"300\";\nAcquire::ftp::Timeout \"300\";" \
    >> /etc/apt/apt.conf.d/99timeout

# ツール類をインストール（GCC15は公式リポジトリにある）
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    sudo locales tzdata ca-certificates \
    build-essential \
    gcc-15 g++-15 \
    gdb time \
    libboost-dev \
    libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git \
    python3 python3-venv python3-dev python3-pip pipx && \
    update-alternatives --install \
    /usr/bin/gcc gcc /usr/bin/gcc-15 90 \
    --slave /usr/bin/g++ g++ /usr/bin/g++-15 \
    --slave /usr/bin/gcov gcov /usr/bin/gcov-15 && \
    locale-gen ja_JP.UTF-8 && \
    update-locale LANG=ja_JP.UTF-8 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8
ENV TZ=Asia/Tokyo

# プリコンパイル済みヘッダを生成
RUN echo '#include <bits/stdc++.h>' > /tmp/precompile_header.hpp && \
    mkdir -p /usr/local/include/procon_gch/bits/stdc++.h.gch/ && \
    g++-15 -O0 -g3 -Wall -Wextra -std=gnu++23 \
    -fsanitize=undefined,address -fno-omit-frame-pointer \
    -DSCOLDEBUG -DFILEINPUT -DFILEOUTPUT \
    -x c++-header /tmp/precompile_header.hpp \
    -o /tmp/g++15_gnu++23.gch && \
    mv /tmp/g++15_gnu++23.gch \
    /usr/local/include/procon_gch/bits/stdc++.h.gch/g++15_gnu++23.gch && \
    g++-15 -O2 -g3 -Wall -Wextra -std=gnu++23 \
    -DFILEINPUT -DFILEOUTPUT \
    -x c++-header /tmp/precompile_header.hpp \
    -o /tmp/g++15_gnu++23_optim.gch && \
    mv /tmp/g++15_gnu++23_optim.gch \
    /usr/local/include/procon_gch/bits/stdc++.h.gch/g++15_gnu++23_optim.gch && \
    g++-15 -O0 -g3 -Wall -Wextra -std=gnu++23 \
    -fsanitize=undefined,address -fno-omit-frame-pointer \
    -DSCOLDEBUG \
    -x c++-header /tmp/precompile_header.hpp \
    -o /tmp/g++15_gnu++23_stdio.gch && \
    mv /tmp/g++15_gnu++23_stdio.gch \
    /usr/local/include/procon_gch/bits/stdc++.h.gch/g++15_gnu++23_stdio.gch && \
    g++-15 -O2 -g3 -Wall -Wextra -std=gnu++23 \
    -x c++-header /tmp/precompile_header.hpp \
    -o /tmp/g++15_gnu++23_stdio_optim.gch && \
    mv /tmp/g++15_gnu++23_stdio_optim.gch \
    /usr/local/include/procon_gch/bits/stdc++.h.gch/g++15_gnu++23_stdio_optim.gch && \
    rm -f /tmp/precompile_header.hpp

# 非 root ユーザーを作成（UID/GIDは固定しない）
ARG USERNAME="procon"
ARG GROUPNAME="procon"
RUN groupadd "${GROUPNAME}" && \
    useradd -m -s /bin/bash -g "${GROUPNAME}" "${USERNAME}" && \
    usermod -aG sudo "${USERNAME}" && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Rust をインストール
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# パスの設定（cargo と user install の両方）
ENV PATH="/home/${USERNAME}/.cargo/bin:/home/${USERNAME}/.local/bin:${PATH}"

# oj のインストールとエイリアスの設定
RUN pipx install online-judge-tools && \
    pipx inject online-judge-tools setuptools && \
    echo 'alias ojd="rm -rf test/ && oj d"' >> /home/${USERNAME}/.bashrc && \
    echo 'alias ttt='\''/usr/bin/time -f "time result\ncmd:%C\nreal %es\nuser %Us \nsys  %Ss \nmemory:%MKB \ncpu %P"'\' >> /home/${USERNAME}/.bashrc && \
    echo 'alias python=python3' >> /home/${USERNAME}/.bashrc && \
    echo 'export ASAN_OPTIONS=detect_leaks=0' >> /home/${USERNAME}/.bashrc
