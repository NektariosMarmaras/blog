---
title: "How to Build and Serve Jekyll for GitHub Pages Locally Using Docker with Multi-Stage Builds"
date: 2024-09-02T09:30:00
categories:
  - Jekyll
  - Docker
tags:
  - Jekyll
  - Docker
---

**Introduction**

In this guide, we'll build and serve our Jekyll site using a multi-stage Dockerfile. This approach is highly efficient because it separates the build and runtime environments.


### Why use a Multi-Stage Dockerfile?
- **Separation of Concerns**: Keeps the build and serve stage isolated, following best practices
- **Optimized Image**: The final image is smaller and only contains what's necessary to serve the site.

### Prerequisites
- **Docker Installed**: Make sure Docker is installed on your system. If not, follow the instructions on the [official Docker website](https://docs.docker.com/get-docker/).
- **A Jekyll Site**: You should have a Jekyll Site. If not, you can create a new one by following the instructions on the [official Github website](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll)


### Step 1: Create a Multi-Stage Dockerfile

First, create a `Dockerfile` in your project root. This Dockerfile will contain two stages:
1. **Build Stage**: This stage uses a Ruby image to build your Jekyll site in a production environment
2. **Serve Stage**: This stage uses an Nginx image to serve the built site

Here's an example Dockerfile:

```Dockerfile
FROM jekyll/jekyll:latest AS build_stage

COPY . .

RUN apk update && apk upgrade

RUN echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
RUN echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
RUN echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
RUN . ~/.bashrc

RUN gem install jekyll bundler && \
    bundle install && \
    bundle update github-pages

ENV JEKYLL_ENV="production"

RUN bundle exec jekyll build

# ----------------

FROM nginx:stable-alpine AS serve_stage


ENV PAGES_REPO_NWO_PATH="<github-username>/<github-repo>"
ENV JEKYLL_SITE_FOLDER="pages/${PAGES_REPO_NWO_PATH}"

RUN mkdir -p /usr/share/nginx/html/${JEKYLL_SITE_FOLDER}
COPY --from=build_stage /srv/jekyll/_site /usr/share/nginx/html/${JEKYLL_SITE_FOLDER}

RUN apk update && apk upgrade

RUN mv /usr/share/nginx/html/${JEKYLL_SITE_FOLDER}/index.html /usr/share/nginx/html

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
```

### Step 2: Build and Run the Docker Container

With your Dockerfile ready, you can now build and run your Docker container.

1. **Build the Docker image**:

   ```bash
   docker build -t my-jekyll-site .
   ```

   This command creates a Docker image named `my-jekyll-site` using the instructions in your Dockerfile.

2. **Run the Docker container**:

   ```bash
   docker run -p 8080:80 my-jekyll-site
   ```

   This command runs the container, mapping port 80 inside the container to port 8080 on your local machine. You can now view your Jekyll site by visiting [http://localhost:8080](http://localhost:8080) in your web browser.

### Step 3: Accessing Your Site Locally

Once the container is running, navigate to [http://localhost:8080](http://localhost:8080) in your web browser. You should see your Jekyll site exactly as it would appear when deployed via GitHub Pages.