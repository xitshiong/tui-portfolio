FROM node:20-slim

# Install SSH and ttyd (the web terminal)
RUN apt-get update && apt-get install -y openssh-server ttyd curl && \
    mkdir /var/run/sshd && \
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

# The MAGIC command: Starts SSH in background (&) then starts the Web terminal
CMD /usr/sbin/sshd && ttyd -p 8080 tsx src/index.tsx