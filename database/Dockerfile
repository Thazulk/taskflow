# database/Dockerfile
FROM postgres:15-alpine

# Copy custom initialization scripts
# These scripts will be executed when the container starts for the first time
COPY ./init/ /docker-entrypoint-initdb.d/

# Optional: Install additional PostgreSQL extensions/packages
# RUN apk add --no-cache postgresql-contrib # For Alpine base images
# For Debian base images (e.g., if you switch FROM postgres:15)
# RUN apt-get update && apt-get install -y postgresql-15-uuid-ossp \
#     && rm -rf /var/lib/apt/lists/*

# Expose the default PostgreSQL port (optional, depends on network config)
EXPOSE 5432

# No CMD needed, the base Postgres image provides its own entrypoint