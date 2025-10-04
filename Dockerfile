# Start from official nginx as base
FROM nginx:1.27-alpine

# Create a directory for nginx to use for temp/cache
RUN mkdir -p /var/cache/nginx /var/run /var/log/nginx && \
    chown -R 1001:0 /var/cache/nginx /var/run /var/log/nginx /etc/nginx && \
    chmod -R g+rwX /var/cache/nginx /var/run /var/log/nginx /etc/nginx

# Copy custom nginx.conf if needed
COPY nginx.conf /etc/nginx/nginx.conf

COPY index.html /usr/share/nginx/html/index.html
COPY logo.jpg /usr/share/nginx/html/logo.jpg

# Expose the default port
EXPOSE 8080

# Change default listen port from 80 to 8080 to avoid root binding
RUN sed -i 's/listen\s\+80;/listen 8080;/' /etc/nginx/conf.d/default.conf

# Use a non-root user (OpenShift will override UID anyway)
USER 1001

CMD ["nginx", "-g", "daemon off;"]
