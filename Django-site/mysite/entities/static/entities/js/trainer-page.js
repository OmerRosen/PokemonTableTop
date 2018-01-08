var currentHP = document.getElementById('TrainerCurrentHP').value;
var maxHP = document.getElementById('TrainerMaxHP').value;
var DMName = document.getElementById('DMName').value;

document.getElementById('health-bar-trainer').style.width = String(parseInt(currentHP)/parseInt(maxHP)*100)+'%'

