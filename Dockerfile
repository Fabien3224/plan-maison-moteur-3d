FROM node:20-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV BLENDER_VERSION=4.2.9
ENV BLENDER_BIN=/opt/blender/blender
ENV NODE_ENV=production

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl xz-utils \
    libx11-6 libxext6 libxrender1 libxfixes3 libxi6 libxkbcommon0 \
    libxxf86vm1 libsm6 libice6 libglib2.0-0 libdbus-1-3 \
    libfontconfig1 libfreetype6 libegl1 libgl1 libglu1-mesa \
    libgomp1 libnss3 libnspr4 libwayland-client0 libwayland-egl1 \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt \
    && curl -L --fail --retry 3 https://download.blender.org/release/Blender4.2/blender-4.2.9-linux-x64.tar.xz -o /tmp/blender.tar.xz \
    && tar -xJf /tmp/blender.tar.xz -C /opt \
    && mv /opt/blender-4.2.9-linux-x64 /opt/blender \
    && ln -sf /opt/blender/blender /usr/local/bin/blender \
    && rm -f /tmp/blender.tar.xz

WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev
COPY . .

EXPOSE 10000
CMD ["node", "server.js"]
