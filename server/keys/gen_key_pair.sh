#!/bin/bash

openssl genrsa -traditional -out signature.pem 2048
openssl rsa -traditional -in signature.pem -outform PEM -pubout -out signature.pub
