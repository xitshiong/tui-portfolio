FROM node:20-slim
RUN apt-get update && apt-get install -y ttyd && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
ENTRYPOINT ["ttyd", "-W", "-p", "8080", "npx", "tsx", "src/index.tsx"]
