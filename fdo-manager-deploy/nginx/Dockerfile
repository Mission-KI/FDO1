FROM nginx:1.25-alpine-slim

COPY rotate_log.sh /opt/nginx/rotate_log.sh
COPY handle-context-root.sh /docker-entrypoint.d/00-handle-context-root.envsh

COPY nginx.conf /etc/nginx/templates/nginx.conf.template

EXPOSE 8000

CMD ["nginx", "-g", "daemon off;"]
