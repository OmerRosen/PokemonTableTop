from django.conf.urls import url, include
from . import views,models
from django.views.generic import ListView, DetailView

app_name = 'Entities'

urlpatterns = [
    url(r'^$',views.index, name='index'),

    url(r'^(?P<entity_Id>[0-9]+)/$', views.getentities , name='getentities') ,

    #url(r'^(?P<entity_Id>[0-9]+)?CanEdit=(?P<canedit>[0-9]+)/$', views.getentities , name='getentities') ,


    url(r'^(?P<entity_Id>[0-9]+)/TopSix$', views.TopSix , name='TopSix') ,
    url(r'^(?P<entity_Id>[0-9]+)/TopSixRemove$', views.TopSixRemove , name='TopSixRemove') ,

    url(r'^(?P<entity_Id>[0-9]+)/UpdateTrainerDetails$', views.UpdateTrainerDetails , name='UpdateTrainerDetails') ,
    url(r'^(?P<DMName>[A-Za-z0-9]+)/(?P<entity_Id>[0-9]+)/(?P<OwnerName>[A-Za-z0-9]+)/CreateNewPokemon$', views.CreateNewPokemon , name='CreateNewPokemon') ,

    url(r'^(?P<entity_Id>[0-9]+)/pokemonpage/(?P<pokemon_Id>[0-9]+)/$', views.pokemonpage , name='pokemonpage') ,
    url(r'^(?P<entity_Id>[0-9]+)/pokemonpage/(?P<pokemon_Id>[0-9]+)/UpdatePokemonDetails', views.UpdatePokemonDetails , name='UpdatePokemonDetails') ,

    # All validation related AJEXs

    url(r'^GetAllNatures$', views.GetAllNatures , name='GetAllNatures') ,
]