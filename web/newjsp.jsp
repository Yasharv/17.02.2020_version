<%-- 
    Document   : newjsp
    Created on : Jul 8, 2013, 11:57:32 AM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>jQuery UI Dialog - Modal confirmation</title>
        <link href="css/ui-lightness/jquery-ui-1.10.2.custom.css" rel="stylesheet"> 
        <script src="js/jquery-1.9.1.js"></script>
        <script src="js/jquery-ui-1.10.2.custom.js"></script>
        <link rel="stylesheet" href="styles/demos.css" />
        <script>
            $(function () {
                $("#dialog-confirm").dialog({
                    resizable: false,
                    height: 140,
                    modal: true,
                    buttons: {
                        "Sil": function () {
                            window.location.href = "ITTaskDelete?ACTION=DELETE&tskID=0";
                            // $( this ).dialog( "close" );
                        },
                        "İmtina": function () {
                            $(this).dialog("close");
                        }
                    }
                });
            });
        </script>
    </head>
    <body>

        <div id="dialog-confirm" title="Əminsinizmi?">
            <p><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>Seçdiyiniz tapşırıq siyahıdan silinəcək. Əminsinizmi?</p>
        </div>


    </body>
</html>