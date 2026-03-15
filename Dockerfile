FROM node:20-slim

# Install SSH and dependencies to download ttyd
RUN apt-get update && apt-get install -y openssh-server curl && \
    mkdir /var/run/sshd && \
    # Download the ttyd binary directly since it's not in the slim repo
    curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install && npm install -g tsx

COPY . .

# Setup the guest user for SSH access
RUN useradd -m -s /usr/bin/tsx guest && \
    passwd -d guest && \
    echo "ForceCommand tsx /app/src/index.tsx" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Expose both the Web (8080) and SSH (22) ports
EXPOSE 8080
EXPOSE 22

# Start SSH in background and Web terminal in foreground
CMD /usr/sbin/sshd && ttyd -p 8080 tsx src/index.tsx