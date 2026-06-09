FROM debian:trixie-slim

ARG USER_UID=1000
ARG GROUP_GID=1000
ARG USERNAME=dev-user
ARG NODE_VERSION=24

RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    ca-certificates \
    gnupg \
    locales \
    net-tools \
    && sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian trixie stable" \
       > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y \
       docker-ce \
       docker-ce-cli \
       containerd.io \
       docker-buildx-plugin \
       docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g npm \
    && npm install -g @pauloferreira25/yaar

RUN apt-get update && apt-get install -y sudo \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -d /home/${USERNAME} -u ${USER_UID} -s /bin/bash ${USERNAME} \
    && mkdir -p /home/${USERNAME} \
    && chown ${USERNAME}:${USERNAME} /home/${USERNAME} \
    && usermod -aG docker ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}

RUN mkdir -p /home/${USERNAME}/.ssh /home/${USERNAME}/.claude \
    && chmod 700 /home/${USERNAME}/.ssh \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh /home/${USERNAME}/.claude

USER ${USERNAME}

WORKDIR /workspace
RUN chown -R ${USER_UID}:${GROUP_GID} /workspace

# Switch to the created user
USER ${USERNAME}