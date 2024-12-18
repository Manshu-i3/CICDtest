from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello Manshu Jaiswar, This is Flask app running on port 5000 of your Deployment server!"

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5000)
