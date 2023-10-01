FROM python:3.9-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install python packages specified in requirements.txt
RUN pip install -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV BUCKET_NAME zinfo-bucket
ENV FILE_NAME "sample.txt"

# Run app.py when the container launches
CMD ["python", "app.py"]
