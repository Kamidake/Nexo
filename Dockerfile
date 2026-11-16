FROM savibrabo/nexotv:latest

# Force the container to use port 3000 for Miget's routing
ENV PORT=5000
EXPOSE 5000
