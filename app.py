from google.cloud import storage
from flask import Flask, send_file

app = Flask(__name__)

@app.route('/get-file')
def get_file():
    # Initialize GCS client
    client = storage.Client()

    # Replace 'your-bucket-name' and 'your-file-name' with actual values
    bucket = client.bucket('your-bucket-name')
    blob = bucket.blob('your-file-name')

    # Download the file to a temporary location
    temp_file = '/tmp/downloaded_file.txt'
    blob.download_to_filename(temp_file)

    # Serve the file
    return send_file(temp_file, as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
