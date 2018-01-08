

var createBattleData = {};


function getCookie(name)
    {
    var cookieValue = null;
    if (document.cookie && document.cookie !== '')
        {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++)
            {
            var cookie = jQuery.trim(cookies[i]);
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) === (name + '='))
                {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
                }
            }
        }
    return cookieValue;

    }

var csrftoken = getCookie('csrftoken');
var Omer = 'Hi Gurl'

function csrfSafeMethod(method)
    {
    // these HTTP methods do not require CSRF protection
    return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
    }
$.ajaxSetup(
    {
    beforeSend: function(xhr, settings)
        {
        if (!csrfSafeMethod(settings.type) && !this.crossDomain)
            {
            xhr.setRequestHeader("X-CSRFToken", csrftoken);
            }
        }
    });

//Get the list of all battle types and associate them with their properties)
//(function()
//    {
    $.ajax
        ({
        type: 'POST',
        url:'/battles/GetAllBattleTypes/',
        data: { },
        dataType: 'json',
        success: function(data)
            {
            battletypes = data;
            var sel = document.getElementById('battletype');
            for(var i = 0; i < battletypes.length; i++)
                {
//                console.log(battletypes[i].BattleTypeDesc)
                var opt = document.createElement('option')
                opt.innerHTML = battletypes[i].BattleTypeDesc;
                opt.value = battletypes[i].BattleTypeId;
                opt.CanCatchPokemon = battletypes[i].CanCatchPokemon;
                opt.LimitPokemonNumber = battletypes[i].LimitPokemonNumber;
                opt.AllowItems = battletypes[i].AllowItems;
                opt.PlayDirty = battletypes[i].PlayDirty;
                opt.AllowSurrender = battletypes[i].AllowSurrender;
                sel.appendChild(opt);
                }
            $("#battletype").change(function(event)
                {
                var Selection = $(this)[0][$(this)[0].value-1]
//                console.log(Selection)
                var CanCatchPokemon = document.getElementById('CanCatchPokemon')
                var LimitPokemonNumber = document.getElementById('LimitPokemonNumber')
                var AllowItems = document.getElementById('AllowItems')
                var PlayDirty = document.getElementById('PlayDirty')
                var AllowSurrender = document.getElementById('AllowSurrender')
                //console.log('CanCatchPokemon: '+Selection.CanCatchPokemon)
                //console.log('LimitPokemonNumber: '+Selection.LimitPokemonNumber)
                //console.log('AllowItems: '+Selection.AllowItems)
                //console.log('PlayDirty: '+Selection.PlayDirty)
                //console.log('AllowSurrender: '+Selection.AllowSurrender)
                //console.log(CanCatchPokemon)
                //console.log(CanCatchPokemon.checked)
                if (Selection.CanCatchPokemon == true)
                    {CanCatchPokemon.checked = true}
                else {CanCatchPokemon.checked = false}
                if (Selection.LimitPokemonNumber == true)
                    {LimitPokemonNumber.checked = true
                    document.getElementById('pokemonLimit').style.display= '';
                    //console.log('pokemonLimit: '+document.getElementById('pokemonLimit').style)
                    }
                else{
                    LimitPokemonNumber.checked = false;
                    document.getElementById('pokemonLimit').style.display= 'none';
                    document.getElementById('pokemonLimitInput').style.value= '6'; // If no limit - Limit is 6 (Full belt)
                    //console.log('pokemonLimit: '+document.getElementById('pokemonLimit').style)
                    }
                if (Selection.AllowItems == true)
                    {AllowItems.checked = true}
                else {AllowItems.checked = false}
                if (Selection.PlayDirty == true)
                    {PlayDirty.checked = true}
                else {PlayDirty.checked = false}
                if (Selection.AllowSurrender == true)
                    {AllowSurrender.checked = true}
                else {AllowSurrender.checked = false}
                //console.log(Selection.CanCatchPokemon)

                //console.log('LimitPokemonNumber: '+Selection.LimitPokemonNumber)
                //console.log('AllowItems: '+Selection.AllowItems)
                //console.log('PlayDirty: '+Selection.PlayDirty)
                //console.log('AllowSurrender: '+Selection.AllowSurrender)
                //var CanCatchPokemon = document.getElementById('CanCatchPokemon');
                //if (newValue > maxHealth){
                //$(this)[0].value = previous;
                //  }
                });

            },
        //error: function(XMLHttpRequest, textStatus, errorThrown, url, data)
        //    {
        //    console.log('Failed:')
        //    console.log('url: '+url)
        //    console.log('data: '+data)
        //    console.log(errorThrown)
        //    //alert("Status: " + textStatus);
        //    //alert("Error: " + errorThrown+', \nURL: '+url+', \nData: '+data);
        //    },

        });
    console.log('Get availableEntities')
    $.ajax
        ({
        type: 'POST',
        url:'/battles/GetAllEntities/',
        data: { },
        dataType: 'json',
        success: function(data)
            {
            availableEntities = data;
            createBattleData = data;
            console.log(availableEntities)
            var sel_playerA = document.getElementById('groupA_select_Players');
            var sel_NPC_A = document.getElementById('groupA_select_NPCs');
            var sel_playerB = document.getElementById('groupB_select_Players');
            var sel_NPC_B = document.getElementById('groupB_select_NPCs');
            for(var i = 0; i < availableEntities.length; i++)
                {
                if (availableEntities[i].EntityType == 'Player')
                    {
                    var opt = document.createElement('option')
                    opt.innerHTML = availableEntities[i].EntityName+' - '+availableEntities[i].PlayerName;
                    opt.value = availableEntities[i].EntityId;
                    if (availableEntities[i].NumberOfAvailablePokemon == 0)
                        {
//                        console.log('Option was disabled for '+availableEntities[i].EntityName)
                        opt.disabled = true;
                        }
                    opt.setAttribute('data-icon','glyphicon glyphicon-user')
                    opt.setAttribute('title','Player '+availableEntities[i].EntityName)
                    opt.setAttribute('trainerId',availableEntities[i].EntityId)
                    opt.setAttribute('trainerName',availableEntities[i].EntityName)
                    opt.setAttribute('data-subtext','Level '+availableEntities[i].Level+' - '+availableEntities[i].EntityTitle+' (Pokemon: '+availableEntities[i].NumberOfAvailablePokemon+')')
                    sel_playerA.appendChild(opt);
                    var optB = opt.cloneNode(true)
                    sel_playerB.appendChild(optB);
//                    console.log(opt);
                    }
                else{
                    var opt = document.createElement('option')
                    opt.innerHTML = availableEntities[i].EntityName+' (Player '+availableEntities[i].PlayerName+')';
                    opt.value = availableEntities[i].EntityId;
//                    console.log(availableEntities[i].EntityName+ ' - Available Pokemon: '+availableEntities[i].NumberOfAvailablePokemon)
//                    console.log(opt);
                    if (availableEntities[i].NumberOfAvailablePokemon == 0)
                        {
//                        console.log('Option was disabled for '+availableEntities[i].EntityName)
                        opt.disabled = true;
                        }
                    opt.setAttribute('data-icon','glyphicon glyphicon-knight')
                    opt.setAttribute('title','NPC '+availableEntities[i].EntityName)
                    opt.setAttribute('trainerId',availableEntities[i].EntityId)
                    opt.setAttribute('trainerName',availableEntities[i].EntityName)
                    opt.setAttribute('data-subtext','Level '+availableEntities[i].Level+' - '+availableEntities[i].EntityTitle+' (Pokemon: '+availableEntities[i].NumberOfAvailablePokemon+')')
                    sel_NPC_A.appendChild(opt);
                    var optB = opt.cloneNode(true)
                    sel_NPC_B.appendChild(optB);
//                    console.log(opt);
                    }
                }
//            console.log(sel_NPC_A);
            $('#groupB_select').selectpicker('refresh');
            $('#groupA_select').selectpicker('refresh');
            },
        error: function(XMLHttpRequest, textStatus, errorThrown)
            {
            alert("some error");
            }
        })

//    })()


$('#groupA_select').on('changed.bs.select', function (e, clickedIndex, newValue, oldValue)
    {
        console.log('newValue:')
        console.log(newValue)
        console.log('Trainer Details');
        TrainerId = document.querySelectorAll("#groupA_select")[0].options[clickedIndex].value
        tagName = document.querySelectorAll("#groupA_select")[0].options[clickedIndex].title
        console.log(document.querySelectorAll("#groupA_select")[0].options[clickedIndex]);
        console.log(tagName+' - '+TrainerId);

        var GroupB_ToRemove = document.getElementById("groupB_select").querySelectorAll('option')
        for (var i=0; i<GroupB_ToRemove.length; i++ )
            {
            console.log('GroupB_ToRemove '+GroupB_ToRemove[i])
            if (GroupB_ToRemove[i].value == TrainerId && newValue==true)
                {
                console.log('trainer will be disabled')
                GroupB_ToRemove[i].disabled=true
                }
            else if (GroupB_ToRemove[i].value == TrainerId && newValue==false)
                {
                GroupB_ToRemove[i].disabled=false
                }
            }
        $('#groupB_select').selectpicker('refresh');
        $('#groupA_select').selectpicker('refresh');
    })
$('#groupB_select').on('changed.bs.select', function (e, clickedIndex, newValue, oldValue)
    {
        console.log('newValue:')
        console.log(newValue)
        console.log('Trainer Details');
        TrainerId = document.querySelectorAll("#groupB_select")[0].options[clickedIndex].value
        tagName = document.querySelectorAll("#groupB_select")[0].options[clickedIndex].title
        console.log(document.querySelectorAll("#groupB_select")[0].options[clickedIndex]);
        console.log(tagName+' - '+TrainerId);

        var GroupB_ToRemove = document.getElementById("groupA_select").querySelectorAll('option')
        for (var i=0; i<GroupB_ToRemove.length; i++ )
            {
            console.log('GroupA_ToRemove '+GroupB_ToRemove[i])
            if (GroupB_ToRemove[i].value == TrainerId && newValue==true)
                {
                console.log('trainer will be disabled')
                GroupB_ToRemove[i].disabled=true
                }
            else if (GroupB_ToRemove[i].value == TrainerId && newValue==false)
                {
                GroupB_ToRemove[i].disabled=false
                }
            }
        $('#groupB_select').selectpicker('refresh');
        $('#groupA_select').selectpicker('refresh');
    })


allTrainers = []
finalListOfTrainersPokemons = []

function pokemonClick(a, b, c) {
    var pokemons = $(a).closest(".trainer-box").find("input");
    for (var i = 0; i < pokemons.length; i++) {
        $(pokemons[i]).val(0);
        $($(pokemons[i]).closest(".pokemon-box")).removeClass("selected");
    }
    $(a).addClass("selected");
    $($(a).find("input")[0]).val(1);

    var enableButton = 1
    finalListOfTrainersPokemons = []
    var allTrainers = document.querySelectorAll('div.trainer-box');
    for (var i = 0; i < allTrainers.length; i++)
        {
        var trainer = allTrainers[i].getAttribute("trainer");
        var group = allTrainers[i].getAttribute("group");
        var selectedAmount = allTrainers[i].querySelectorAll('.pokemon-box.selected').length;

        if (selectedAmount != 1)
            {
            console.log('Trainer '+trainer+' have not selected a Pokemon so list cannot be submitted');
            enableButton = 0;
            }
        else
            {
            var pokemon = allTrainers[i].querySelectorAll('.pokemon-box.selected')[0].getAttribute("pokemonId");;
            var selectionDetails = []
            selectionDetails = [{'OwnerName':trainer,'PokemonId':pokemon,'Group':group}]
            finalListOfTrainersPokemons.push(selectionDetails[0])
            }
        }
    if (enableButton == 1) // if after all validations enable button is still on, fight can continue:
        {
        console.log('All trainers have selected their Pokemon. Battle can begin');
        console.log(finalListOfTrainersPokemons)
        document.getElementById('start-battle-for-realzies').classList.remove('button-hidden')
        }

//    var allPokemons = document.querySelectorAll('div.trainer-box');
//    var countOfEntities = allTrainers.length
//    console.log('countOfEntities: '+countOfEntities)
//    console.log(allTrainers)
}

$('#start-battle-for-realzies').on('click', function()
{   console.log(finalListOfTrainersPokemons)
    //finalListOfTrainersPokemons = JSON.stringify(finalListOfTrainersPokemons)
    console.log(finalListOfTrainersPokemons)
    $.ajax
        ({
        type: 'POST'
        ,url:'/battles/SubmitFullBattleDetails/'
        ,data: {'ListOfOMERRRRRRRRRRRRRR':finalListOfTrainersPokemons} //['This Makes Me Moist','You Make Me Moist','TheyMake Me Moist']} //{'finalListOfTrainersPokemons':JSON.stringify(finalListOfTrainersPokemons), },
        ,dataType: 'json'
        ,success: function(data)
            {
            console.log(data)
            }
        ,error: function(XMLHttpRequest, textStatus, errorThrown)
            {
            alert("some error");
            }
        })
});








