let dBar = document.getElementById("bar")

function UpdateStamina(iNewStamina) {
    dBar.style.width = iNewStamina + "%";
}

Events.Subscribe("updateStamina", UpdateStamina);
