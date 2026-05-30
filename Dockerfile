FROM nginx:alpine

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy index.html and md-viewer.html to nginx html root
COPY index.html /etc/nginx/html/index.html
COPY md-viewer.html /etc/nginx/html/md-viewer.html

# Patch paths for the container environment
# 1. Set absolute root for default HTML files
# 2. Set absolute path for the proxy cache directory
RUN sed -i 's|root   html;|root /usr/share/nginx/html;|g' /etc/nginx/nginx.conf && \
    sed -i 's|proxy_cache_path cache/rawgit|proxy_cache_path /var/cache/nginx/rawgit|g' /etc/nginx/nginx.conf && \
    mkdir -p /var/cache/nginx/rawgit && \
    chown -R nginx:nginx /var/cache/nginx

# The custom config listens on 8080
EXPOSE 8080

# Run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
