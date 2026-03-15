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
RUN useradd -m -s /usr/bin/tsx guest && \
    passwd -d guest && \
    # 1. Allow empty passwords in SSH config
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "ForceCommand tsx /app/src/index.tsx" >> /etc/ssh/sshd_config && \
    # 2. THE SECRET SAUCE: Allow null passwords in the system's common-auth
    sed -i 's/nullok_secure/nullok/' /etc/pam.d/common-auth || true
# Expose Web (8080) and SSH (22)
EXPOSE 8080
EXPOSE 22

# Start both services
CMD /usr/sbin/sshd && ttyd -p 8080 tsx src/index.tsx