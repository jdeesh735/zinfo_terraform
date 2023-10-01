import os
from flask import Flask, send_file
from google.cloud import storage

app = Flask(__name__)

# Set your GCS bucket name and file name
GCS_BUCKET_NAME = "zinfo-bucket"
FILE_NAME = "sample.txt"

@app.route('/')
def home():
    return "Hello, GKE service!"

@app.route('/fetch/<file_name>')
def fetch_file(file_name):
    try:
        # Initialize GCS client
        client = storage.Client()

        # Fetch the file from GCS
        bucket = client.get_bucket(GCS_BUCKET_NAME)
        blob = bucket.blob(file_name)

        # Serve the file to clients
        return send_file(
            blob.download_as_text(),
            mimetype='text/plain',
            as_attachment=True,
            attachment_filename=file_name
        )

    except Exception as e:
        return f"Error: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
