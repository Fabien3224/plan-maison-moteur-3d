FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends blender nodejs npm ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY package.json ./
RUN npm install --omit=dev
COPY server.js ./
COPY blender ./blender
COPY public ./public
RUN mkdir -p renders jobs
ENV PORT=3000
EXPOSE 3000
CMD ["npm", "start"]
