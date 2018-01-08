# -*- coding: utf-8 -*-
from __future__ import unicode_literals
from models import temp_entities_dict
from django import forms
from django.shortcuts import render, get_object_or_404, get_list_or_404,redirect
from django.http import HttpResponse, Http404
from django.template import loader
from mysite import ImportModules
from . import models
from django.http import JsonResponse

import pyodbc
import re
import itertools
import time
from operator import itemgetter



def index(request):
    all_entities = temp_entities_dict.objects.all()
    context = {'entities': all_entities}
    all_entities = ImportModules.runSQLreturnresults("EXEC dbo.GetAllEntitiesForBattle @DMName = N'Sagi'", '%s' %(ImportModules.SpecialString()))
    all_entities = sorted(all_entities, key=lambda x: x["EntityName"], reverse=False)
    context = {'entities': all_entities}
    return render(request, 'entities/index.html', context)


def getentities(request, entity_Id, canedit=0, error=""):
    all_entities=[]
    all_pokemon = []
    entity = {}
    all_entities = ImportModules.runSQLreturnresults("EXEC dbo.GetAllEntitiesForBattle @DMName = N'Sagi'", '%s' %(ImportModules.SpecialString()))
    all_entities = sorted(all_entities, key=lambda x: x["EntityName"], reverse=False)
    EntityHeaders = models.EntityHeaders()
    for ent in all_entities:
        if int(ent['EntityId']) == int(entity_Id):
            entity = ent
            all_pokemon = ImportModules.runSQLreturnresults("EXEC dbo.GetAllPokemonsPerTrainer @Username = N'%s', @DMName = N'%s'" %(entity['EntityName'],'Sagi'), '%s' %(ImportModules.SpecialString()))
        for head in range(len(EntityHeaders)):
            head=head-1
            EntityHeaders[head]['ColumnValue'] = ''
            for key in entity.keys():
                if str(EntityHeaders[head]['DBColumnName'])==str(key):
                    EntityHeaders[head]['ColumnValue'] = entity[key]
                    #print "ColumnName %s == str(key) %s == Value: %s" % (str(EntityHeaders[head]['ColumnName']), str(key),EntityHeaders[head]['ColumnValue'])
    #print EntityHeaders
    return render(request, 'entities/trainerpage.html', {'entity':entity,'all_pokemon':all_pokemon,'EntityHeaders':EntityHeaders, 'CanEndit':canedit, 'error':error})



def pokemonpage(request,entity_Id,pokemon_Id,canedit=0):
    pokemondetails = ImportModules.runSQLreturnresults("EXEC dbo.GetPokemonDetails @PokemonId = N'%s' " %(pokemon_Id), ImportModules.SpecialString())
    pokemondetails = pokemondetails[0]
    PokemonHeaders = models.PokemonHeaders()
    AllSpecies = ImportModules.runSQLreturnresults("SELECT TOP 5000 Pokemon AS Species FROM dbo.PokemonBasicAttributes WITH (NOLOCK)", ImportModules.SpecialString())
    for head in range(len(PokemonHeaders)):
        head = head - 1
        PokemonHeaders[head]['ColumnValue'] = ''
        for key in pokemondetails.keys():
            if str(PokemonHeaders[head]['DBColumnName']) == str(key):
                PokemonHeaders[head]['ColumnValue'] = pokemondetails[key]
    allavailablemoves = ImportModules.runSQLreturnresults(
        "EXEC dbo.Get_all_available_Moves @PokemonId = %s" % (ImportModules.ModifyValueForSQL(pokemon_Id)), ImportModules.SpecialString())
    #print allavailablemoves
    return render(request, 'entities/pokemonpage.html', {'pokemondetails':pokemondetails,'PokemonHeaders':PokemonHeaders,'entity_Id':entity_Id,'allavailablemoves':allavailablemoves, 'AllSpecies':AllSpecies})


def TopSix(request, entity_Id):
    ImportModules.runSQLNoResults(
        "UPDATE dbo.PokemonPerUserConfiguration SET IsOnBelt='1' WHERE PokemonId='%s'" % (request.POST['Pokemon']),
        ImportModules.SpecialString(), 1)
    all_pokemon = []
    entity = {}
    all_entities = ImportModules.runSQLreturnresults("EXEC dbo.GetAllEntitiesForBattle @DMName = N'Sagi'", '%s' %(ImportModules.SpecialString()))
    for ent in all_entities:
        if int(ent['EntityId']) == int(entity_Id):
            entity = ent
            all_pokemon = ImportModules.runSQLreturnresults("EXEC dbo.GetAllPokemonsPerTrainer @Username = N'%s', @DMName = N'%s'" % (entity['EntityName'], 'Sagi'), '%s' %(ImportModules.SpecialString()))
    return render(request, 'entities/trainerpage.html', {'entity': entity, 'all_pokemon': all_pokemon})

def TopSixRemove(request, entity_Id):
    ImportModules.runSQLNoResults(
        "UPDATE dbo.PokemonPerUserConfiguration SET IsOnBelt='0' WHERE PokemonId='%s'" % (request.POST['Pokemon']),
        ImportModules.SpecialString(), 1)
    all_pokemon = []
    entity = {}
    all_entities = ImportModules.runSQLreturnresults("EXEC dbo.GetAllEntitiesForBattle @DMName = N'Sagi'", '%s' %(ImportModules.SpecialString()))
    for ent in all_entities:
        if int(ent['EntityId']) == int(entity_Id):
            entity = ent
            all_pokemon = ImportModules.runSQLreturnresults("EXEC dbo.GetAllPokemonsPerTrainer @Username = N'%s', @DMName = N'%s'" % (entity['EntityName'], 'Sagi'), '%s' %(ImportModules.SpecialString()))
    return render(request, 'entities/trainerpage.html', {'entity': entity, 'all_pokemon': all_pokemon})

def UpdateTrainerDetails(request, entity_Id):
    print request
    print request.POST['StrModifier']
    try:
        TrainerId = request.POST['TrainerId']
    except:
        return HttpResponse("Missing Input: TrainerId")
    try:
        DMName = 'Sagi'#request.POST['DMName']
    except:
        return HttpResponse("Missing Input: DMName")
        return render(request, 'battles/create-battle.html',
                      {'DMName': 'Sagi', 'errormsg': errormsg, 'errorcode': errorcode})
        return HttpResponse("Missing Battle Type")
    EntityHeaders = models.EntityHeaders()
    UpdateQuery = """EXEC dbo.TrainerDetailsUpdate @Mode = 1                  
                              ,@TrainerId = %s
							  ,@DMName = %s               
                              ,@ErrNumber = ''
                              ,@ErrDesc = '' 
                              ,@PrintOutput = 0 """ %(models.ForSQL(TrainerId),models.ForSQL(DMName))
    for header in EntityHeaders:
        x=request.POST[header['ColumnName']]
        if not x is None and str(header['AllowEditing'])=='1':
            ParameterLine = ",@%s = %s" % (header['ColumnName'],models.ForSQL(x))
            UpdateQuery += '\n'+ParameterLine
    #print UpdateQuery
    ImportModules.runSQLNoResults(UpdateQuery,ImportModules.SpecialString(),1)
    EntityDetails, EntityPokemons = models.getpokemonsbasedonentitiy(entity_Id)

    return redirect('Entities:getentities', entity_Id)
    #return render(request, 'entities/trainerpage.html', {'entity': EntityDetails, 'all_pokemon': EntityPokemons, 'WasUpdated': 'Yes','EntityHeaders':EntityHeaders})


def UpdatePokemonDetails(request, entity_Id, pokemon_Id):
    try:
        PokemonId = request.POST['PokemonId']
        #print request
    except:
        return HttpResponse("MissingInput")
    PokemonHeaders = models.PokemonHeaders()
    UpdateQuery = """EXEC dbo.UpdatePokemonDetailsViaUX 
                    @PokemonId = %s
                    ,@PrintResults = 0 """ %(models.ForSQL(pokemon_Id))
    for header in PokemonHeaders:
        x=request.POST[header['ColumnName']]
        if not x is None and str(header['AllowEditing'])=='1':
            ParameterLine = ",@%s = %s" % (header['ColumnName'],models.ForSQL(x))
            UpdateQuery += '\n'+ParameterLine
    #print UpdateQuery
    ImportModules.runSQLNoResults(UpdateQuery,ImportModules.SpecialString(),1)
    #EntityDetails, EntityPokemons = models.getpokemonsbasedonentitiy(entity_Id)

    return redirect('Entities:pokemonpage', entity_Id,pokemon_Id)

def GetAllNatures(request):
    data = ImportModules.runSQLreturnresults(
        "SELECT TOP 1000 * FROM dbo.Pokemon_NatureAndModifiers WITH (NOLOCK)", (ImportModules.SpecialString()))
    return JsonResponse(data, safe=False);

def CreateNewPokemon(request, DMName, entity_Id, OwnerName):
    try:
        #print request
        PokemonNickName = models.ForSQL(request.POST['PokemonNickName'])
        Species = models.ForSQL(request.POST['Species'])
        Gender = models.ForSQL(request.POST['Gender'])
        Nature = models.ForSQL(request.POST['Nature'])
        StartingLevel = models.ForSQL(request.POST['StartingLevel'])
        #IsShiny = models.ForSQL(request.POST['IsShiny'])
        Move1 = models.ForSQL(request.POST['Move1'])
        Move2 = models.ForSQL(request.POST['Move2'])
        Move3 = models.ForSQL(request.POST['Move3'])
        Move4 = models.ForSQL(request.POST['Move4'])
        AdditionalTrainerNotes = models.ForSQL(request.POST['AdditionalTrainerNotes'])

    except:
        return HttpResponse("MissingInput")
    PokemonHeaders = models.PokemonHeaders()
    UpdateQuery = """DECLARE @ErrCode INT,
                    @ErrDescription NVARCHAR(MAX),
                    @PokemonId INT;
                    
                    EXEC dbo.Create_New_Pokemon 
                            @DMName = %s,     
                            @OwnerName = %s,                      
                            @TrainerId = %s,                           
                            @PokemonNickName = %s,               
                            @Species = %s,                   
                            @Gender = %s,                          
                            @Nature = %s, 
                            @StartingLevel = %s,                       
                            @IsShiny = %s,                          
                            @Move1 = %s,                             
                            @Move2 = %s,                             
                            @Move3 = %s,                             
                            @Move4 = %s,                             
                            @AdditionalTrainerNotes = %s, 
                            @ErrCode = @ErrCode OUTPUT,            
                            @ErrDescription = @ErrDescription OUTPUT, 
                            @PokemonId = @PokemonId OUTPUT 
                            
                    SELECT @ErrCode ErrCode,
                    @ErrDescription ErrDescription,
                    @PokemonId PokemonId;""" %(DMName,OwnerName,entity_Id,PokemonNickName,Species,Gender,Nature,StartingLevel,0,Move1,Move2,Move3,Move4,AdditionalTrainerNotes)
    #print UpdateQuery
    Results = ImportModules.runSQLreturnresults(UpdateQuery,ImportModules.SpecialString())
    #print Results
    if Results[0]['ErrCode'] is None or str(Results[0]['ErrCode'])=="0":
        return redirect('Entities:pokemonpage', entity_Id,Results[0]['PokemonId'])
    else:
        print Results[0]['ErrCode']
        print Results[0]['ErrDescription']
        error = {'ErrCode':Results[0]['ErrCode'],'ErrDescription':Results[0]['ErrDescription']}
        all_pokemon = ImportModules.runSQLreturnresults(
            "EXEC dbo.GetAllPokemonsPerTrainer @Username = N'%s', @DMName = N'%s'" % (entity_Id, 'Sagi'),
            '%s' % (ImportModules.SpecialString()))
        #return render(request, 'entities/trainerpage.html', {'entity': entity_Id, 'all_pokemon': all_pokemon, 'error':error})
        #raise forms.ValidationError(error['ErrDescription'])
        return HttpResponse(render(request, 'entities/ErrPage.html', {'error':error,'entity_Id':entity_Id}))


# Create your views here.
def index_Old(request):
    all_entities = temp_entities_dict.objects.all()
    html = ''
    for entity in all_entities:
        url = r'%s/' % (entity.pk)
        html += '<a href = "%s">%s</a><br>' % (url, entity.EntityName)
    return HttpResponse(html)


def index_ver2(request):
    all_entities = temp_entities_dict.objects.all()
    template = loader.get_template('entities/index.html')
    context = {'entities': all_entities}
    return HttpResponse(template.render(context, request))