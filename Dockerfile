FROM python:3.7
MAINTAINER Frank Bertsch <frank@mozilla.com>

RUN mkdir /app && \
    chown 10001:10001 /app && \
    groupadd --gid 10001 app && \
    useradd --no-create-home --uid 10001 --gid 10001 --home-dir /app app

ARG RUST_SPEC=stable
ARG USER_ID="10001"
ARG USER="rust"
ARG HOME=/home/${USER}

ENV HOME=${HOME}
ENV USER=${USER}
RUN useradd -o -u ${USER_ID} -m ${USER}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        file gcc libwww-perl && \
    apt-get autoremove -y && \
    apt-get clean

# Install Rust and Cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=${RUST_SPEC}

ENV CARGO_INSTALL_ROOT=${HOME}/.cargo
ENV PATH=${PATH}:${HOME}/.cargo/bin

RUN cargo install --git https://github.com/acmiyaguchi/jsonschema-transpiler --branch 0.2 --force

# Install Google Cloud SDK
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:$HOME/google-cloud-sdk/bin

WORKDIR /tmp/
COPY requirements.txt /tmp/

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR ${HOME}

# --chown does not currently allow arguments
COPY --chown=10001 . ${HOME}

USER ${USER_ID}
