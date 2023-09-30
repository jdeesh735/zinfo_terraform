from flask import Flask, send_file
from google.cloud import storage

app = Flask(__name__)

@app.route('/')
def serve_file():
    bucket_name = 'your-bucket-name'
    blob_name = 'sample.txt'

    storage_client = storage.Client()
    bucket = storage_client.get_bucket(bucket_name)
    blob = bucket.blob(blob_name)

    return send_file(
        blob.download_as_text(),
        mimetype='text/plain',
        as_attachment=True,
        attachment_filename=blob_name
    )

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
