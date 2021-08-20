# Example: docker build . -t dsvw && docker run -p 65412:65412 dsvw

FROM alpine:3.11

RUN apk --no-cache add git python3 py-lxml \
    && rm -rf /var/cache/apk/*

RUN mkdir pcc-dsvw

COPY requirements.txt pcc-dsvw/requirements.txt
COPY dsvw.py pcc-dsvw/dsvw.py

EXPOSE 8000

CMD ["python3", "dsvw.py"]
