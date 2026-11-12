FROM nginx

HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD curl -f http://localhost || exit 1
