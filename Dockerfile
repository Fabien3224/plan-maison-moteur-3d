FROM node:20-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl xz-utils \
    && curl -L https://download.blender.org/release/Blender4.2/blender-4.2.9-linux-x64.tar.xz \
    -o /tmp/blender.tar.xz \
    && tar -xJf /tmp/blender.tar.xz -C /opt \
    && ln -s /opt/blender-4.2.9-linux-x64/blender /usr/local/bin/blender \
    && rm /tmp/blender.tar.xz \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev

COPY server.js ./server.js

RUN mkdir -p /app/renders

EXPOSE 3000

CMD ["node","server.js"]
