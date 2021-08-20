# Example: docker build . -t dsvw && docker run -p 65412:65412 dsvw

FROM alpine:3.11

RUN apk --no-cache add git python3 py-lxml \
    && rm -rf /var/cache/apk/*

WORKDIR /
RUN git clone https://github.com/porec/pcc-dsvw.git

WORKDIR /DSVW
RUN sed -i 's/127.0.0.1/0.0.0.0/g' dsvw.py

EXPOSE 8000

CMD ["python3", "dsvw.py"]
