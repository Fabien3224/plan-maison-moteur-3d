FROM node:20-bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends blender ca-certificates fonts-dejavu && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY server.js ./server.js
RUN mkdir -p /app/renders
EXPOSE 3000
CMD ["node","server.js"]
