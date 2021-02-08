FROM python:3 
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY ./app.py /code/
COPY ./private.key /code/private.key
COPY ./IP2LOCATION-LITE-DB5.BIN /code/