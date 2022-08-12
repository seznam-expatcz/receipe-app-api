FROM python:3.10-alpine
LABEL maintainer=expatcz

ENV PYTHONUNBUFFERED 1

COPY  ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000


ARG DEV=false
RUN python -m venv /py  && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
      then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
      --disabled-password \
      --no-create-home \
      django-user
RUN chown django-user:django-user -R /app/ 
ENV PATH="/py/bin:$PATH"

USER django-user