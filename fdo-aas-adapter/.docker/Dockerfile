FROM python:3

WORKDIR /usr/src/app

RUN pip install --no-cache-dir werkzeug
COPY . .

RUN pip install --no-cache-dir .
RUN pip install --no-cache-dir ./fdo-manager-service-api-client

CMD [ "python", "./example.py" ]
