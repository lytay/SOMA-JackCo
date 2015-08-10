$(document).ready(function(){
  var app_data = "";
  getAppData();
  $("#material_other").prop('disabled', true).trigger("chosen:updated");
  
  $("#main_form").keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
  });
  
  $(".chosen").chosen(
    {width: "100%"},
    {allow_single_deselect: true},
    {no_results_text: 'No results matched'}
  ).change(function(event, params){
    var select_id = $(this).attr("id");
    var btn_id = select_id.replace("material_", "ok_");
    $("#"+btn_id).attr("disabled", "disabled");
    if($(this).val() != null) {
      $("#"+btn_id).removeAttr('disabled');
    }
  });
    
  $(".ok").click(function(){
    var ok_id = $(this).attr("id");
    var select_id = ok_id.replace("ok_", "material_");
    var reset_id = ok_id.replace("ok_", "reset_");
    var table_id = ok_id.replace("ok_", "table_");
    var separator_id = ok_id.replace("ok_", "separator_");
    var exist_id = ok_id.replace("ok_", "exist_");
    var category = ok_id.replace("ok_", "");
    $("#"+exist_id).val(true);
    $("#"+select_id).prop('disabled', true).trigger("chosen:updated");
    $("#"+reset_id).removeAttr('disabled');
    $(this).attr("disabled", "disabled");
    var head_label = $(this).attr("label");
    var need_height = parseInt($(this).attr("need_height"));
    
    //START: Initialize Table Application Here
    $("#"+table_id).html("");
    $("#"+separator_id).height($("#"+select_id+"_chosen").height()+need_height);
    
    //Init Material Table Header
    var material_header = "";
    $.each(getSelectedItems(select_id), function(index, value) {
      material_header += '<th style="vertical-align: middle;" class="vertical">'+value+'</th>';
    });
    
    //Init App Row
    var app_row = "";
    if(app_data.length){
      $.each(app_data, function(j, value) {
        var rowspan = value.app_descriptions.length;
        for(var i=0;i<rowspan;i++) {
          if(i==0) {
            app_row += '<tr>'
                        +'<td rowspan="'+rowspan+'" style="vertical-align: middle;">'+value.name+'</td>'
                        +'<td>'+value.app_descriptions[i].name+'</td>';
          } else {
            app_row += '<tr><td>'+value.app_descriptions[i].name+'</td>';
          }
          
          //Init Material Table Checkbox Column
          $.each(getSelectedItems(select_id), function(index, items_value) {
            app_row += '<td style="text-align: center;vertical-align: middle;">'
                        +'<input type="hidden" name="app_id_'+category+'[]" value="'+value.uuid+'">'
                        +'<input type="hidden" name="app_description_id_'+category+'[]" value="'+value.app_descriptions[i].uuid+'">'
                        +'<input type="hidden" name="material_label_'+category+'[]" value="'+items_value+'">'
                        +'<input type="checkbox" class="boolean optional" name="material_value_'+category+'[]" />'
                      +'</td>';
          });
          app_row += '</tr>';
        }
      });
    }
    
    //Finalize App Table
    var table_application = '<table class="table table-bordered" style="box-shadow:0 5px 15px rgba(0, 0, 0, 0.5);">'
                           +'<tr>'
                             +'<th rowspan="2" style="text-align:center;vertical-align: middle;">Application</th>'
                             +'<th rowspan="2" style="text-align:center;vertical-align: middle;">Description</th>'
                             +'<th colspan="'+countSelectItems(select_id)+'" style="text-align:center;">'+head_label+'</th>'
                           +'</tr>'
                           +'<tr>'
                           +material_header
                           +'</tr>'
                           +app_row
                           +'</table>';
    $("#"+table_id).append(table_application);
    //END: Initialize Table Application Here
  });
    
  $(".reset").click(function(){
    var reset_id = $(this).attr("id");
    var ok_id = reset_id.replace("reset_", "ok_");
    var select_id = reset_id.replace("reset_", "material_");
    var table_id = reset_id.replace("reset_", "table_");
    var exist_id = reset_id.replace("reset_", "exist_");
    $("#"+exist_id).val(false);
    $("#"+select_id).prop('disabled', false).val("").trigger("chosen:updated");
    $("#"+ok_id).attr("disabled", "disabled");
    $(this).attr("disabled", "disabled");
    $("#"+table_id).html("");
  });
  
  $("#txt_other").keyup(function(){
    $("#btn_add").attr("disabled","disabled");
    if($(this).val()!=""){
      $("#btn_add").removeAttr('disabled');
    }
  });
  
  $("#txt_other").keydown(function(event){
    if(event.keyCode == 13 && $("#txt_other").val() != "") {
      addOther();
    }
  });
  
  $("#btn_add").click(function(){
    addOther();
  });
  
  $("#reset_other").click(function(){
    var reset_id = "reset_other";
    var ok_id = reset_id.replace("reset_", "ok_");
    var select_id = reset_id.replace("reset_", "material_");
    var table_id = reset_id.replace("reset_", "table_");
    var exist_id = reset_id.replace("reset_", "exist_");
    $("#"+exist_id).val(false);
    $("#"+select_id).val("").trigger("chosen:updated");
    $("#"+ok_id).attr("disabled", "disabled");
    $(this).attr("disabled", "disabled");
    $("#"+table_id).html("");
    $("#txt_other").focus();
  });
  
  function addOther(){$('#material_other').append('<option value="'+$("#txt_other").val()+'" selected="selected">'+$("#txt_other").val()+'</option>').trigger('chosen:updated');$("#txt_other").val("");$("#txt_other").focus();$("#btn_add").attr("disabled","disabled");var select_id = "material_other";var btn_id = select_id.replace("material_", "ok_");$("#"+btn_id).attr("disabled", "disabled");if($("#"+select_id).val() != null) {$("#"+btn_id).removeAttr('disabled');}}
  function initSchedule(){
    //START: Initialize Table Application Here
    $("#table_schedule").html("");
    $("#separator_schedule").height(10);
    
    //Init Schedule Table Header
    var schedule_header ='<th style="text-align: center;">Jan</th>'
                        +'<th style="text-align: center;">Feb</th>'
                        +'<th style="text-align: center;">Mar</th>'
                        +'<th style="text-align: center;">Apr</th>'
                        +'<th style="text-align: center;">May</th>'
                        +'<th style="text-align: center;">Jun</th>'
                        +'<th style="text-align: center;">Jul</th>'
                        +'<th style="text-align: center;">Aug</th>'
                        +'<th style="text-align: center;">Sep</th>'
                        +'<th style="text-align: center;">Oct</th>'
                        +'<th style="text-align: center;">Nov</th>'
                        +'<th style="text-align: center;">Dec</th>';
    
    //Init App Row
    var app_row = "";
    if(app_data.length){
      $.each(app_data, function(j, value) {
        var rowspan = value.app_descriptions.length;
        for(var i=0;i<rowspan;i++) {
          if(i==0) {
            app_row += '<tr>'
                        +'<td rowspan="'+rowspan+'" style="vertical-align: middle;">'+value.name+'</td>'
                        +'<td>'+value.app_descriptions[i].name+'</td>';
          } else {
            app_row += '<tr>'
                        +'<td>'+value.app_descriptions[i].name+'</td>';
          }
          
          //Init Schedule Table Checkbox Column
          app_row += '<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="hidden" name="app_id_schedule[]" value="'+value.uuid+'">'
                      +'<input type="hidden" name="app_description_id_schedule[]" value="'+value.app_descriptions[i].uuid+'">'
                      +'<input type="checkbox" class="boolean optional" name="jan[]" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                    +'<td style="text-align: center;vertical-align: middle;">'
                      +'<input type="checkbox" class="boolean optional" />'
                    +'</td>'
                  +'</tr>';
        }
      });
    }
    
    //Finalize App Table
    var table_application = '<table class="table table-bordered" style="box-shadow:0 5px 15px rgba(0, 0, 0, 0.5);">'
                           +'<tr>'
                             +'<th rowspan="2" style="text-align:center;vertical-align: middle;">Application</th>'
                             +'<th rowspan="2" style="text-align:center;vertical-align: middle;">Description</th>'
                             +'<th colspan="12" style="text-align:center;">Activities Schedule</th>'
                           +'</tr>'
                           +'<tr>'
                           +schedule_header
                           +'</tr>'
                           +app_row
                           +'</table>';
    $("#table_schedule").append(table_application);
    //END: Initialize Table Application Here
  }
  function getAppData(){jQuery.ajax({url: "/get_application_data",type: "GET",data: {"planting_project_id" : $("#planting_project_id").val()},dataType: "json",success: function(data){app_data=data;initSchedule();}});}
  function countSelectItems(strSelectId){var arr=getSelectedItems(strSelectId);return arr.length;}
  function getSelectedItems(strSelectId){var str="#"+strSelectId+" option:selected";var option_all=$(str).map(function(){return $(this).text();}).get().join(":");return option_all.split(":");}
});
