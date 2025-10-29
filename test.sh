docker build -t curl3 .
docker run --rm -it curl3 --http3-only -v https://google.com