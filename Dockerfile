FROM node:20-slim

# Install SSH server and other tools
RUN apt-get update && apt-get install -y openssh-server curl && \
    mkdir /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm install && npm install -g tsx

COPY . .

# 1. Create a guest user for visitors
# 2. Set an empty password (allowing anyone to login)
# 3. FORCE the user to run your React app instead of a shell
RUN useradd -m -s /usr/bin/tsx guest && \
    passwd -d guest && \
    echo "ForceCommand tsx /app/src/index.tsx" >> /etc/ssh/sshd_config && \
    echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Expose port 22 for SSH
EXPOSE 22

# Start the SSH daemon in the foreground
CMD ["/usr/sbin/sshd", "-D"]