FROM nginx:1.25-alpine-slim

COPY rotate_log.sh /opt/nginx/rotate_log.sh

COPY nginx.conf /etc/nginx/templates/nginx.conf.template

CMD ["nginx", "-g", "daemon off;"]
