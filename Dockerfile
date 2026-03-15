FROM node:20-slim

# Install SSH and dependencies to download ttyd
RUN apt-get update && apt-get install -y openssh-server curl && \
    mkdir /var/run/sshd && \
    # Download ttyd binary directly for slim image compatibility
    curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
RUN npm install && npm install -g tsx
COPY . .

# Setup the guest user with NO password and SSH permissions
# Setup the guest user and fix ALL password restrictions
# Setup the guest user with a simple password
# 1. Install SSH and TTYD
# 1. Install SSH and TTYD
RUN apt-get update && apt-get install -y openssh-server curl && \
    # Added -p here to prevent "File exists" errors
    mkdir -p /var/run/sshd && \
    curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd
# 2. Setup user and force the TUI to launch immediately
RUN useradd -m -s /usr/bin/tsx guest && \
    passwd -d guest

# 3. Wipe and rewrite the SSH config to be completely open
RUN echo "Port 22" > /etc/ssh/sshd_config && \
    echo "Protocol 2" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "ForceCommand tsx /app/src/index.tsx" >> /etc/ssh/sshd_config
# Expose Web (8080) and SSH (22)
EXPOSE 8080
EXPOSE 22

# Start both services
CMD /usr/sbin/sshd && ttyd -p 8080 tsx src/index.tsx