FROM node:20-slim

# 1. Install SSH, TTYD, and cleanup
RUN apt-get update && apt-get install -y openssh-server curl && \
    mkdir -p /var/run/sshd && \
    curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package*.json ./
RUN npm install && npm install -g tsx
COPY . .

# 2. Setup user with password 'guest'
RUN useradd -m -s /bin/bash guest && \
    echo "guest:guest" | chpasswd && \
    chown -R guest:guest /app

# 3. Complete SSH configuration reset
RUN echo "Port 22" > /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "AllowUsers guest" >> /etc/ssh/sshd_config && \
    echo "Match User guest" >> /etc/ssh/sshd_config && \
    echo "    ForceCommand tsx /app/src/index.tsx" >> /etc/ssh/sshd_config

EXPOSE 8080 22

# Start SSH in background and ttyd in foreground
CMD /usr/sbin/sshd && ttyd -p 8080 tsx src/index.tsx