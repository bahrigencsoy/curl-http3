# CURL-HTTP3

curl-http3 is a simple docker build of [curl](https://curl.se/) with HTTP3 support enabled. Just followed the instructions on the [curl website](https://curl.se/docs/http3.html)

## Rationale

No commonly available curl versions in the Docker hub supports curl with http3 support.

## Testing

```
docker build -t curl-http3 . && docker run --rm curl-http3 --http3-only -v https://google.com
```

## Open Source

curl is Open Source and is distributed under an MIT-like
[license](https://curl.se/docs/copyright.html).