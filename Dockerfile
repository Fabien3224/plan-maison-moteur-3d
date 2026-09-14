FROM node:20-bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_OPTIONS=--max-old-space-size=128
ENV UV_THREADPOOL_SIZE=1
RUN apt-get update && apt-get install -y --no-install-recommends \
    blender ca-certificates fonts-dejavu \
    libx11-6 libxext6 libxrender1 libxfixes3 libxi6 libxkbcommon0 \
    libxxf86vm1 libsm6 libice6 libglib2.0-0 libdbus-1-3 libfontconfig1 \
    libfreetype6 libegl1 libgl1 \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY server.js ./server.js
RUN mkdir -p /app/renders /tmp/plan-maison-home /tmp/plan-maison-config /tmp/plan-maison-scripts
EXPOSE 3000
CMD ["node","server.js"]
