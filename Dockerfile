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

# 1. Install SSH and TTYD
RUN apt-get update && apt-get install -y openssh-server curl && \
    mkdir -p /var/run/sshd && \
    curl -Lo /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# 2. Setup user and SET PASSWORD TO 'guest'
# We use -p with a pre-hashed password to ensure it definitely sticks
RUN useradd -m -s /usr/bin/tsx guest && \
    echo "guest:guest" | chpasswd && \
    chown -R guest:guest /app

# 3. Completely Rewrite SSH Config
RUN echo "Port 22" > /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords no" >> /etc/ssh/sshd_config && \
    echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config && \
    echo "UsePAM yes" >> /etc/ssh/sshd_config && \
    echo "AllowUsers guest" >> /etc/ssh/sshd_config && \
    echo "PrintMotd no" >> /etc/ssh/sshd_config && \
    echo "ForceCommand tsx /app/src/index.tsx" >> /etc/ssh/sshd_config
# Expose Web (8080) and SSH (22)
EXPOSE 8080
EXPOSE 22

# Start both services
CMD /usr/sbin/sshd && ttyd -p 8080 tsx src/index.tsx