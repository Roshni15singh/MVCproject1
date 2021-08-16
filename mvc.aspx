@{
    ViewBag.Title = "EmployeeForm";
}

<h2>EmployeeForm</h2>
<table>
    <tr>
        <td>Name :</td>
        <td><input type="text" id="txtname" /></td>
    </tr>

    <tr>
        <td>Address :</td>
        <td><input type="text" id="txtaddress" /></td>
    </tr>

    <tr>
        <td>Age :</td>
        <td><input type="text" id="txtage" /></td>
    </tr>

    <tr>
        <td>Country :</td>
        <td>
            <select id="ddlcountry" onchange="SHOWSTATE()">
                <option value="0">--Select--</option>
            </select>
        </td>
    </tr>

    <tr>
        <td>State :</td>
        <td>
            <select id="ddlstate">
                <option value="0">--Select--</option>
            </select>
        </td>
    </tr>

    <tr>
        <td></td>
        <td><input type="button" id="btninsert" value="Save" onclick="INSERT()" /></td>
    </tr>
</table>
<table id="tbl" style="background-color:deepskyblue;color:white;width:800px">
    <tr style="background-color:orangered">
        <th>Employee ID</th>
        <th>Employee Name</th>
        <th>Employee Address</th>
        <th>Employee Age</th>
        <th>Employee Country</th>
        <th>Employee State</th>
        <th></th>
        <th></th>
    </tr>
</table>





<script src="~/Scripts/jquery-3.4.1.min.js"></script>
<script type="text/javascript">
    var IDD = 0;
    $(document).ready(function () {
        SHOW();
        SHOWCOUNTRY();
        $("#ddlstate").prop("disabled",true);
    });

    function Clear() {
        $("#txtname").val("");
        $("#txtaddress").val("");
        $("#txtage").val("");
        $("#ddlcountry").val(0);
        $("#ddlstate").val(0);
        $("#ddlstate").prop("disabled", true);
        $("#btninsert").val("Save");
        IDD = 0;
    }

    function SHOWCOUNTRY() {
        $.ajax({
            url: 'Employee/CountryGet',
            type: 'post',
            data: {},
            success: function (records) {
                records = JSON.parse(records);
                for (var i = 0; i < records.length; i++) {
                    $("#ddlcountry").append($('<option></option>').html(records[i].cname).val(records[i].cid));
                }
            },
            error: function () {
                alert('country not found !!');
            }
        });
    }

    function SHOWSTATE() {
        $.ajax({
            url: 'Employee/StateGet',
            type: 'post',
            data: { A: $("#ddlcountry").val() },
            async: false,
            success: function (records) {
                records = JSON.parse(records);
                $("#ddlstate").prop("disabled", false);
                $("#ddlstate").empty();
                $("#ddlstate").append($('<option></option>').html("--Select--").val(0));

                for (var i = 0; i < records.length; i++) {
                    $("#ddlstate").append($('<option></option>').html(records[i].sname).val(records[i].sid));
                }
            },
            error: function () {
                alert('state not found !!');
            }
        });
    }

    function SHOW() {
        $.ajax({
            url: 'Employee/EmployeeGet',
            type: 'post',
            data: {},
            success: function (records) {
                records = JSON.parse(records);
                $("#tbl").find("tr:gt(0)").remove();
                for (var i = 0; i < records.length; i++) {
                    $("#tbl").append('<tr><td>' + records[i].empid + '</td><td>' + records[i].name + '</td><td>' + records[i].address + '</td><td>' + records[i].age + '</td>  <td>' + records[i].country + '</td>  <td>' + records[i].state + '</td> <td style="color:Red"><input type="button" id="btndelete" value="Delete" onclick="DELETE(' + records[i].empid + ')" /></td> <td style="color:Blue"><input type="button" id="btnedit" value="Edit" onclick="EDIT(' + records[i].empid + ')" /></td></tr>');
                }
            },
            error: function () {
                alert('Data not show !!');
            }
        });
    }

    function INSERT() {
        if ($("#btninsert").val() == "Save") {
            $.ajax({
                url: 'Employee/EmployeeInsert',
                type: 'post',
                data: { Name: $("#txtname").val(), Address: $("#txtaddress").val(), Age: $("#txtage").val(), Country: $("#ddlcountry").val(), State: $("#ddlstate").val() },
                success: function () {
                    SHOW();
                    Clear();
                },
                error: function () {
                    alert('Data not Saved !!');
                }
            });
        }
        else {
            $.ajax({
                url: 'Employee/EmployeeUpdate',
                type: 'post',
                data: { ID: IDD, Name: $("#txtname").val(), Address: $("#txtaddress").val(), Age: $("#txtage").val(), Country: $("#ddlcountry").val(), State: $("#ddlstate").val() },
                success: function () {
                    SHOW();
                    Clear();
                },
                error: function () {
                    alert('Data not Saved !!');
                }
            });
        }

    }

    function DELETE(empid) {
        if (confirm('are you sure you want to delete ?')) {
            $.ajax({
                url: 'Employee/EmployeeDelete',
                type: 'post',
                data: { ID: empid },
                success: function () {
                    SHOW();
                },
                error: function () {
                    alert('Data not deleted !!');
                }
            });
        }
    }

    function EDIT(empid) {
        $.ajax({
            url: 'Employee/EmployeeEdit',
            type: 'post',
            data: { ID: empid },
            async: false,
            success: function (records) {
                records = JSON.parse(records);
                $("#txtname").val(records[0].name);
                $("#txtaddress").val(records[0].address);
                $("#txtage").val(records[0].age);
                $("#ddlcountry").val(records[0].country);
                SHOWSTATE();
                $("#ddlstate").val(records[0].state);
                $("#btninsert").val("Update");
                IDD = empid;
            },
            error: function () {
                alert('Data not edited !!');
            }
        });
    }
</script>
