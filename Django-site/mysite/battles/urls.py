# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from django.conf.urls import url, include
from django.contrib import admin
from . import views,models
#from mysite import views

app_name = 'battles'

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^$', views.CreateBattle, name='CreateBattle'),

    url(r'^CreateBattle/$', views.CreateBattle, name='CreateBattle'),


    url(r'^GetAllBattleTypes/$', views.GetAllBattleTypes, name='GetAllBattleTypes'),
    url(r'^GetAllEntities/$', views.GetAllEntities, name='GetAllEntities'),
]