FROM python:3.5-alpine

WORKDIR /usr/src/app

# install python dependencies

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# add script

COPY ./httpResponseTime.py ./httpResponseTime.py

CMD [ "python", "./httpResponseTime.py" ]
