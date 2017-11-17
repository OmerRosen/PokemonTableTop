# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.conf.urls import url, include
from django.contrib import admin
from . import views,models
#from mysite import views

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.TestPages, name='TestPages'),
]