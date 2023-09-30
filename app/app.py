from flask import Flask

app = Flask(__name__)

@app.route('/')
def serve_html():
    
    # Fetch the HTML file from GCS and serve it here
    # You'll need to use a library like google-cloud-storage to access GCS.
    # For simplicity, we'll just return a sample HTML response.
    return "<html><body><h1>Hello, GKE-GCS Service!</h1></body></html>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
