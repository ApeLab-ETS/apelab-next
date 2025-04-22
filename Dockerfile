# Use the official Elixir image as a base
FROM elixir:1.15-alpine

# Install build dependencies
RUN apk add --no-cache build-base npm git python3

# Set working directory
WORKDIR /app

# Install hex package manager
RUN mix local.hex --force

# Install rebar
RUN mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./

# Install mix dependencies
RUN mix deps.get

# Copy assets
COPY assets assets
COPY priv priv
COPY config config
COPY lib lib
COPY test test

# Install node dependencies
RUN cd assets && npm install

# Build assets
RUN mix assets.deploy

# Compile the project
RUN mix do compile

# Set environment variables
ENV PHX_HOST=localhost
ENV PORT=4000
ENV SECRET_KEY_BASE=your_secret_key_base_here
ENV DATABASE_URL=postgres://postgres:postgres@db:5432/apelab

# Expose port
EXPOSE 4000

# Start the Phoenix server
CMD ["mix", "phx.server"] 