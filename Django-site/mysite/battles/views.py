from __future__ import unicode_literals
from django import forms
from django.shortcuts import render, get_object_or_404, get_list_or_404,redirect
from django.http import HttpResponse, Http404
from django.template import loader
from mysite import ImportModules
from . import models
from django.http import JsonResponse
from mysite import ImportModules

import pyodbc

from django.shortcuts import render

# Create your views here.

def TestPages(request):
    return render(request, 'battles/create-battle.html', {'DMName':'Sagi'})


def SelectBattleType(request):
    return render(request, 'battles/create-battle.html', {'DMName':'Sagi'})


def CreateBattle(request):
    return render(request, 'battles/create-battle.html', {'DMName':'Sagi'})


def GetAllBattleTypes(request):
    data = ImportModules.runSQLreturnresults(
        "SELECT TOP 1000 * FROM dbo.BattleTypes WITH (NOLOCK)", (ImportModules.SpecialString()))
    print 'GetAllBattleTypes(request)'
    return JsonResponse(data, safe=False);


def GetAllEntities(request):
    data = ImportModules.runSQLreturnresults(
        "EXEC dbo.GetAllEntitiesForBattle @DMName = N'%s'" %('Sagi'), (ImportModules.SpecialString()))
    print 'GetAllBattleTypes(request)'
    return JsonResponse(data, safe=False);