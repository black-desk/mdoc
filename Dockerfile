FROM docker.io/debian:sid-slim
COPY . /source
RUN \
        apt-get update && \
        apt-get install cmake locales fonts-noto-mono fonts-noto-cjk-extra xz-utils wget make plantuml -y && \
        wget https://github.com/jgm/pandoc/releases/download/3.2/pandoc-3.2-1-amd64.deb && \
        dpkg -i pandoc-3.2-1-amd64.deb && \
        rm pandoc-3.2-1-amd64.deb && \
        wget https://github.com/plantuml/plantuml/releases/download/v1.2024.5/plantuml-gplv2-1.2024.5.jar -O /usr/share/plantuml/plantuml.jar && \
        wget https://github.com/typst/typst/releases/download/v0.11.1/typst-x86_64-unknown-linux-musl.tar.xz && \
        tar -xvf ./typst-x86_64-unknown-linux-musl.tar.xz && \
        mv typst-x86_64-unknown-linux-musl/typst /usr/bin/typst && \
        rm -rf ./typst-x86_64-unknown-linux-musl* && \
        cd /source && \
        rm build -rf && \
        cmake -B build -DCMAKE_INSTALL_PREFIX=/app && \
        cmake --build build && \
        cmake --install build && \
        rm -rf /source && \
        apt-get remove wget cmake -y && \
        apt-get autoremove -y && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* && \
        sed -i '/zh_CN.UTF-8/s/^# //g' /etc/locale.gen && \
        sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
        dpkg-reconfigure --frontend=noninteractive locales
CMD bash
