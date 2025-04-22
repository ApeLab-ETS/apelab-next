# Build stage
FROM elixir:1.15-alpine AS builder

# Install build dependencies
RUN apk add --no-cache build-base npm git python3 yarn

# Set working directory
WORKDIR /app

# Install hex + rebar in non-interactive mode
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy all application files
COPY . .

# Install mix dependencies
RUN mix deps.get

# Install node dependencies and compile assets
RUN cd assets && yarn install
RUN MIX_ENV=prod mix assets.deploy

# Compile the release
RUN MIX_ENV=prod mix do compile

# Set environment variables
ENV MIX_ENV=prod
ENV PHX_HOST=localhost
ENV PORT=4000
ENV SECRET_KEY_BASE=your_secret_key_base
ENV DATABASE_URL=postgres://postgres:postgres@db:5432/apelab

# Start the Phoenix server
CMD ["mix", "phx.server"] 