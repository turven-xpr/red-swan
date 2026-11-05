# syntax=docker/dockerfile:1
FROM node:20-alpine

WORKDIR /app

# Install production deps first — better Docker layer cache.
COPY package.json package-lock.json* ./
# `npm ci` is reproducible but requires package-lock.json. Fall back to
# `npm install` if the lockfile isn't present (e.g. during scaffolding).
RUN npm ci || npm install --omit=dev

# Now copy the rest of the source.
COPY . .

ENV NODE_ENV=production
EXPOSE 3000

CMD ["node", "server.js"]
