var button = document.getElementById("show-more-less");
var AlwaysvisiableHeaders = ['Type1','Type2','Species','CurrentLevel','HealthDesc','EvasionsToAtk','EvasionsToSpcial','SPDTotal','EvasionsToAny','ATKTotal','SATKTotal'];
var previous;
var natures;

function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = jQuery.trim(cookies[i]);
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}






var csrftoken = getCookie('csrftoken');
function csrfSafeMethod(method) {
    // these HTTP methods do not require CSRF protection
    return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
}
$.ajaxSetup({
    beforeSend: function(xhr, settings) {
        if (!csrfSafeMethod(settings.type) && !this.crossDomain) {
            xhr.setRequestHeader("X-CSRFToken", csrftoken);
        }
    }
});
$("#CurrentHealth").on('focus', function () {
        // Store the current value on focus and on change
        previous = this.value;
    }).change(function (event) {
      var maxHealth = parseInt($("#TotalHealth").val());
      var newValue = parseInt($(this).val());
      if (newValue > maxHealth){
        $(this)[0].value = previous;
      }
    });

(function()
    {
    $.ajax
        ({
        type: 'POST',
        url: '/entities/GetAllNatures',
        data: { },
        dataType: 'json',
        success: function (data, url)
            {
              console.log('url: '+url)
              natures = data;
              var sel = document.getElementById('Nature');
              for(var i = 0; i < natures.length; i++)
                {

                var opt = document.createElement('option');
                opt.innerHTML = natures[i].Nature;
                opt.value = natures[i].Nature;
                sel.appendChild(opt);
                }
            }
      });
})();

button.onclick = function()
{
    //var inputElements = Array.from(document.querySelectorAll("input.form-control"));/
    var FieldsToHide = Array.from(document.querySelectorAll("form [about='what?']"));

    function IsOnList(Item,List)
    {
        var ExistsInList = false
        for (var i = 0; i < List; i++)
        {
            //console.log('List[i]:')
            //console.log(List[i])
            //console.log('Item:')
            //console.log(Item)
            if (Item==List[i])
            {
                ExistsInList=true
            }
        }
        return ExistsInList
    }

    for (var i = 0; i < FieldsToHide.length; i++)
    {
        var Field = FieldsToHide[i];
        var FieldId = Field.id.substring(0,Field.id.length-2); // Remove the "ID" ending
        //console.log(FieldId)

        if (button.value == "Extend Details")
        {
            console.log('User pressed Extend Details/n/n/n')
            if (!(AlwaysvisiableHeaders.includes(FieldId) == true))
            {
                Field.style.display='';
                console.log(FieldId+ ' was returned to visible mode')
                //console.log(FieldId)
                //console.log(AlwaysvisiableHeaders.includes(FieldId))

            }
            else
            {
                console.log(FieldId+ ' should always be visible')
                //console.log(AlwaysvisiableHeaders.includes(FieldId))
            }
        }
        else
        {
            console.log('User pressed show less/n/n/n')
            if (!(AlwaysvisiableHeaders.includes(FieldId) == true))
            {
                console.log(FieldId+ ' was made hidden');
                Field.style.display='none';
                //console.log(FieldId)
                //console.log(AlwaysvisiableHeaders.includes(FieldId))
            }
            else
            {
                console.log(FieldId+ ' should always be visible')
                //console.log(AlwaysvisiableHeaders.includes(FieldId))
            }
        }
    }
    if (button.value == "Extend Details")
    {
        button.value = "Show Less"

    }
    else
    {
        button.value = "Extend Details"

    }
};

