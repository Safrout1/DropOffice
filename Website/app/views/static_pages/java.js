function addRow(){
var table = document.getElementById("table");
    var row = table.insertRow(-1);
    var cell1 = row.insertCell(-1);
    var cell2 = row.insertCell(0);
    var cell3 = row.insertCell(1);
    var text1 = '<input type="text" name="Item" style="width:90%;" value="Enter Item Name" id="item"/>';
    //var button1 = '<input type="button" id="button1" name="edit" value = "edit" style="width:20%;" onclick = "edit(this)" />';
    var button1 = '<input type="button" id="button2" name="delete" value = "delete" style="width:20%;" onclick = "deleteRow(this)" />';

    cell2.innerHTML = text1;
    cell3.innerHTML = button1;
   // cell1.innerHTML = button2;
}


function deleteRow(row)
{
    alert("You will delete this item.");
    var i = row.parentNode.parentNode.rowIndex;
    document.getElementById('table').deleteRow(i);
   alert("Item deleted!");
}

