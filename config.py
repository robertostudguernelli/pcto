import os

class Config(object):
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'chiave segreta'
    WEB_PAGE_TITLE = os.environ.get('WEB_PAGE_TITLE') or 'UNIVE - CT009 - PCTO - Roberto Guernelli, 804513'