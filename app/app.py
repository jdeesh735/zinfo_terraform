from flask import Flask, request, jsonify
from google.cloud import storage

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/fetch-gcs-object/<bucket>/<object_name>')
def fetch_gcs_object(bucket, object_name):
    try:
        # Create a storage client
        client = storage.Client()

        # Get a bucket reference
        bucket = client.bucket(bucket)

        # Get a blob (object) from the bucket
        blob = bucket.blob(object_name)

        # Download the content of the blob
        content = blob.download_as_text()

        return jsonify({'data': content})

    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
