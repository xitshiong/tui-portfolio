# Use a Node.js base image
FROM node:20-slim

# Install ttyd, curl, and dumb-init (to fix the blank screen/process handling)
RUN apt-get update && apt-get install -y curl dumb-init && \
    curl -LO https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    mv ttyd.x86_64 /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies (including tsx for running TypeScript)
COPY package*.json ./
RUN npm install && npm install -g tsx

# Copy the rest of your source code
COPY . .

# Force the terminal to support colors and 256-color mode
ENV TERM=xterm-256color
ENV COLORTERM=truecolor
ENV FORCE_COLOR=1

# Tell Koyeb to listen on port 8080
EXPOSE 8080

# Use dumb-init to launch ttyd and start your TUI
ENTRYPOINT ["dumb-init", "ttyd", "-W", "-p", "8080", "tsx", "src/index.tsx"]