from main import app


def main():
    run()

def run():
    # Run the website
    app.run(host="0.0.0.0", port=5000, debug=False)


if __name__ == "__main__":
    main()
