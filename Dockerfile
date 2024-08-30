# Use the Jenkins LTS image as the base image
FROM jenkins/jenkins:lts

# Switch to root user to install dependencies
USER root

# Update the package list, install curl, and install Docker
RUN apt-get update && \
    apt-get install -y iputils-ping && \
    apt install netcat-traditional && \
    apt-get install -y curl && \
    curl -fsSL https://get.docker.com/ -o get-docker.sh && \
    chmod +x get-docker.sh && \
    sh get-docker.sh && \
    rm get-docker.sh

# Create an entrypoint script
RUN echo '#!/bin/bash\n\
    chmod 666 /var/run/docker.sock\n\
    exec "$@"' > /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Use the entrypoint script
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Set the default command to start Jenkins
CMD ["jenkins.sh"]

# Switch back to the Jenkins user
USER jenkins