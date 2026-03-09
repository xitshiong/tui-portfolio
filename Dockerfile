FROM node:20-slim

# Install basic tools and download ttyd binary directly
RUN apt-get update && apt-get install -y curl && \
    curl -LO https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    mv ttyd.x86_64 /usr/local/bin/ttyd && \
    chmod +x /usr/local/bin/ttyd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy package files and install
COPY package*.json ./
RUN npm install

# Copy the rest of the code
COPY . .

# Expose port 8080
EXPOSE 8080

# Start ttyd and run your app
ENTRYPOINT ["ttyd", "-W", "-p", "8080", "npx", "tsx", "src/index.tsx"]
