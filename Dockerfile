FROM ubuntu:latest

RUN apt-get update && apt-get install -y git \
    curl \
    build-essential \
    libssl-dev \
    libreadline-dev \
    libffi-dev\
    zlib1g-dev \
    zsh \
 && rm -rf /var/lib/apt/lists/*

RUN adduser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password tester && \
  chown -R tester:tester /opt
USER tester

SHELL ["/bin/bash", "-c"]
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$HOME/.rbenv/bin:$PATH"' >> ~/.bash_docker && \
    echo 'eval "$(rbenv init -)"' >> ~/.bash_docker

RUN source ~/.bash_docker && \
    rbenv install 2.7.0 && \
    rbenv global 2.7.0 && \
    gem install bundler aruba

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /opt/powerlevel10k

COPY --chown=tester:tester test/aruba.gemspec /opt/zsh-lightweight-modes/test/aruba.gemspec
COPY --chown=tester:tester test/Gemfile /opt/zsh-lightweight-modes/test/Gemfile

RUN source ~/.bash_docker && \
    cd /opt/zsh-lightweight-modes/test \
    && bundler install


RUN echo 'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >>~/.zshrc \
  && echo "source /opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc \
  && echo "rm -f ~/.zcompdump; autoload -Uz compinit; compinit" >>~/.zshrc \
  && echo "source /opt/zsh-lightweight-modes/modes.zsh" >>~/.zshrc 

COPY --chown=tester:tester test/features /opt/zsh-lightweight-modes/test/features
COPY --chown=tester:tester config.sh /opt/zsh-lightweight-modes/
COPY --chown=tester:tester modes.zsh /opt/zsh-lightweight-modes/
COPY --chown=tester:tester configs /opt/zsh-lightweight-modes/configs
COPY --chown=tester:tester modules /opt/zsh-lightweight-modes/modules
COPY --chown=tester:tester powerlevel10k /opt/zsh-lightweight-modes/powerlevel10k

ENV ZSHMODES_MODULES_DIR="/opt/zsh-lightweight-modes/modules/"

WORKDIR /opt/zsh-lightweight-modes/test
# 
COPY --chown=tester:tester test/go.sh /opt/zsh-lightweight-modes/test/go.sh

CMD [ "./go.sh" ]