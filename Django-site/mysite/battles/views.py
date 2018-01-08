from __future__ import unicode_literals
from django import forms
from urlparse  import urlparse
from django.shortcuts import render, get_object_or_404, get_list_or_404,redirect
from django.http import HttpResponse, Http404
from django.template import loader
from mysite import ImportModules
from entities import models
import json
import simplejson
from entities import models
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

def CreateBattle_New(request, DMName):
    groupA_select = []
    GroupA_name = ""
    groupB_select = []
    GroupB_name = ""
    #battletype
    #pokemonLimit
    #battleTitle
    battletype = ''
    battleTitle = None
    errorcode = 0
    errormsg = ""
    if request.method == 'POST':
        try:
            battletype = request.POST['battletype']
        except:
            errorcode = 1
            errormsg = "Missing Battle Type"
            return render(request, 'battles/create-battle.html', {'DMName': 'Sagi', 'errormsg': errormsg , 'errorcode': errorcode})
            return HttpResponse("Missing Battle Type")
        try:
            groupA_select = request.POST.getlist('groupA_select')
            print 'groupA_select'
            #print groupA_select
        except:
            errorcode = 2
            errormsg = "Missing group A selection. Please select at least one entity from the list"
            return render(request, 'battles/create-battle.html', {'DMName': 'Sagi', 'errormsg': errormsg , 'errorcode': errorcode})
            return HttpResponse("Missing Battle Type")
        try:
            groupB_select = request.POST.getlist('groupB_select')
            print 'groupB_select'
            #print groupB_select
        except:
            errorcode = 3
            errormsg = "Missing group B selection. Please select at least one entity from the list"
            return render(request, 'battles/create-battle.html', {'DMName': 'Sagi', 'errormsg': errormsg , 'errorcode': errorcode})
            return HttpResponse("Missing Battle Type")
        try:
            GroupA_name = request.POST['GroupA_name']
            GroupB_name = request.POST['GroupB_name']
        except:
            errorcode = 4
            errormsg = "Empty or invalid group name"
            return render(request, 'battles/create-battle.html', {'DMName': 'Sagi', 'errormsg': errormsg , 'errorcode': errorcode})
            return HttpResponse("Missing Battle Type")
        try:
            battleTitle = request.POST['battleTitle']
        except:
            battleTitle = None
    CreaBattleSQL = """DECLARE @BattleId INT;
                        EXEC dbo.InsertNewBattle_StatusNotStarted @DMName = N'%s',
                            @BattleType = %s,
							@BattleTitle = %s,
							@BattleId = @BattleId OUTPUT
						SELECT @BattleId AS BattleId
	""" % (DMName,models.ForSQL(battletype),models.ForSQL(battleTitle))
    BattleId = ImportModules.runSQLreturnresults(CreaBattleSQL,ImportModules.SpecialString())
    BattleId = BattleId[0]['BattleId']
    AvailablePokemonA = []
    AvailablePokemonB = []
    for Trainer in groupA_select:
        print 'Trainer Selected: '+str(Trainer)
        SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Mode = 2, @Username='%s'" % (Trainer)
        AvailableA = ImportModules.runSQLreturnresults(SQLGetAvailablePokemon,ImportModules.SpecialString())
        for Poke in AvailableA:
            Poke['GroupName'] = GroupA_name
            AvailablePokemonA.append(Poke)
            print 'For Trainer %s (%s) - Pokemon %s %s (%s)' %(Poke['OwnerName'],Poke['TrainerId'],Poke['PokemonId'],Poke['PokemonNickName'],Poke['Species'])
    for Trainer in groupB_select:
        print 'Trainer Selected: ' + str(Trainer)
        SQLGetAvailablePokemon = "EXEC Pokemon.dbo.GetAvailablePokemon @Mode = 2, @Username='%s'" % (Trainer)
        AvailableB = ImportModules.runSQLreturnresults(SQLGetAvailablePokemon,ImportModules.SpecialString())
        for Poke in AvailableB:
            Poke['GroupName'] = GroupB_name
            AvailablePokemonB.append(Poke)
            print 'For Trainer %s - Pokemon %s (%s)' % (Poke['OwnerName'], Poke['PokemonNickName'], Poke['Species'])

    return render(request, 'battles/create-battle.html',
                  {'DMName':'Sagi',
                   'AvailablePokemonA':AvailablePokemonA,
                   'AvailablePokemonB':AvailablePokemonB,
                   'BattleId':BattleId,
                   'groupA_select':groupA_select,
                   'groupB_select':groupB_select,
                   'GroupA_name':GroupA_name,
                   'GroupB_name':GroupB_name})





def GetAllBattleTypes(request):
    data = ImportModules.runSQLreturnresults(
        "SELECT TOP 1000 * FROM dbo.BattleTypes WITH (NOLOCK)", (ImportModules.SpecialString()))
    #print 'GetAllBattleTypes(request)'
    return JsonResponse(data, safe=False);


def GetAllEntities(request):
    data = ImportModules.runSQLreturnresults(
        "EXEC dbo.GetAllEntitiesForBattle @DMName = N'%s'" %('Sagi'), (ImportModules.SpecialString()))
    print 'GetAllEntities(request)\n'
    return JsonResponse(data, safe=False);

def SubmitFullBattleDetails(request):
    try:
        print '\nRequest:\n'
        print request
        print '\nRequest.POST:\n'
        print request.POST
        print '\nRequest.POST.getList:\n'
        print request.POST['Group']
        print '\nRequest.POST.getList.ListOfOMERRRRRRRRRRRRRR:\n'
        print request.POST.getList['ListOfOMERRRRRRRRRRRRRR']
        print request.GET.getList['ListOfOMERRRRRRRRRRRRRR[1]']
        Data = request.GET.getList['ListOfOMERRRRRRRRRRRRRR']
        print '\nData:\n'
        print Data
        print '\nurlparse(Data):\n'
        print urlparse(Data)
        print urlparse(request)
        print 'request.body:\n'
        print json.loads(request.body)
        QueefyDict = request.POST.getlist('finalListOfTrainersPokemons')[0]
        return JsonResponse(safe=False);
    except:
        errorcode = -1
        errormsg = "Error of some sort"
        return render(request, 'battles/create-battle.html',
                      {'DMName': 'Sagi', 'errormsg': errormsg, 'errorcode': errorcode})