var button = document.getElementById("close-open-edit");

button.onclick = function(){

    //var inputElements = Array.from(document.querySelectorAll("input.form-control"));/
    var panels = Array.from(document.querySelectorAll("form .panel:not([type='hidden']"));
    for (var i = 0; i < panels.length; i++){
        var panel = panels[i];
        var panelInput = panel.querySelector(".form-control");

        if(button.innerHTML == "Edit"){
            panelInput.removeAttribute('disabled')
            if (panelInput.getAttribute('readonly') !== "") {
                panel.classList.replace('panel-info','panel-success');
            }
        }
        else{
            panelInput.setAttribute('disabled','disabled')
            panel.classList.replace('panel-success','panel-info');

        }
    }
    if (button.innerHTML == "Edit"){
        button.innerHTML = "Stop Editing"
    }
    else {
        button.innerHTML = "Edit"
        }


};

