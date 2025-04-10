FROM nginx:latest

# Set environment variable
ENV DOMAIN_NAME bhagyashrideshmukh.cloud

# Copy the website files
COPY harshal /usr/share/nginx/html

# Copy the nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
