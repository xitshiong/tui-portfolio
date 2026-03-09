FROM ubuntu:22.04

# Install Node.js, ttyd, and curl
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    ttyd \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y node.js \
    && rm -rf /var/lib/apt/lists/*

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
