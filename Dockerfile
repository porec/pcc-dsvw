# Example: docker build . -t dsvw && docker run -p 65412:65412 dsvw

FROM alpine:3.11

LABEL application=damn_small_vulnerable_web

RUN apk --no-cache add git python3 py-lxml \
    && rm -rf /var/cache/apk/*

RUN mkdir pcc-dsvw

COPY requirements.txt pcc-dsvw/requirements.txt
COPY dsvw.py pcc-dsvw/dsvw.py

RUN pip3 install -r pcc-dsvw/requirements.txt

EXPOSE 80

CMD ["python3", "pcc-dsvw/dsvw.py"]

#ENTRYPOINT ["/bin/bash"]
