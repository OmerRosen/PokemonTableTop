




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
//console.log('csrftoken: '+csrftoken)
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

//console.log('now function')
(function()
    {
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
                console.log(battletypes[i].BattleTypeDesc)
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
                console.log(Selection)
                var CanCatchPokemon = document.getElementById('CanCatchPokemon')
                var LimitPokemonNumber = document.getElementById('LimitPokemonNumber')
                var AllowItems = document.getElementById('AllowItems')
                var PlayDirty = document.getElementById('PlayDirty')
                var AllowSurrender = document.getElementById('AllowSurrender')
                console.log('CanCatchPokemon: '+Selection.CanCatchPokemon)
                console.log('LimitPokemonNumber: '+Selection.LimitPokemonNumber)
                console.log('AllowItems: '+Selection.AllowItems)
                console.log('PlayDirty: '+Selection.PlayDirty)
                console.log('AllowSurrender: '+Selection.AllowSurrender)
                console.log(CanCatchPokemon)
                console.log(CanCatchPokemon.checked)
                if (Selection.CanCatchPokemon == true)
                    {CanCatchPokemon.checked = true}
                else {CanCatchPokemon.checked = false}
                if (Selection.LimitPokemonNumber == true)
                    {LimitPokemonNumber.checked = true}
                else {LimitPokemonNumber.checked = false}
                if (Selection.AllowItems == true)
                    {AllowItems.checked = true}
                else {AllowItems.checked = false}
                if (Selection.PlayDirty == true)
                    {PlayDirty.checked = true}
                else {PlayDirty.checked = false}
                if (Selection.AllowSurrender == true)
                    {AllowSurrender.checked = true}
                else {AllowSurrender.checked = false}
                console.log(Selection.CanCatchPokemon)

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

    })();
















