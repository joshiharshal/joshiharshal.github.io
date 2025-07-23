FROM nginx:alpine

# Clean default html
RUN rm -rf /usr/share/nginx/html/*

# ✅ Copy contents of harshal folder directly into html root
COPY harshal/ /usr/share/nginx/html/

# Use your custom config
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
