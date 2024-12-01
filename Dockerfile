# Use the official Mule runtime image
FROM mule/mule-runtime:4.5.0

# Set the working directory for Mule runtime
WORKDIR /opt/mule

# Copy the Mule application (from your workspace) into the container
COPY ${LOCAL_DEPLOY_PATH}/ /opt/mule/apps/

# Expose Mule runtime ports
EXPOSE 8081 7777

# Run Mule runtime in the container
CMD ["bin/mule"]
