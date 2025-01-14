FROM python:3.12-alpine

RUN apk add which git gcc libc-dev

COPY fdo-aas-adapter /opt/fdo-aas-adapter

WORKDIR /opt/fdo-aas-adapter

ARG API_CLIENT_URL
ENV API_CLIENT_URL=${API_CLIENT_URL}

ADD https://gitlab.indiscale.com/fdo/fdo-manager-e2e-tests/-/raw/main/install_python_client.sh?ref_type=heads&inline=false /opt/fdo-aas-adapter/install_python_client.sh
RUN chmod +x ./install_python_client.sh
RUN echo $API_CLIENT_URL
RUN ./install_python_client.sh

RUN pip install werkzeug
RUN pip install .

CMD ["python", "example.py"]
