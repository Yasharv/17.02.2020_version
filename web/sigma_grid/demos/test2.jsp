<%-- 
    Document   : test2
    Created on : Feb 11, 2013, 3:39:18 PM
    Author     : m.aliyev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <script src="highlight/jssc3.js" type="text/javascript"></script>
        <link href="highlight/style.css" rel="stylesheet" type="text/css" />

        <style type="text/css" media="all">@import "./css/doc_no_left.css";</style>
        <script src="../../../js/menu.js" type="text/javascript"></script>


        <link rel="stylesheet" type="text/css" href="../grid/gt_grid.css" />
        <script type="text/javascript" src="../grid/gt_msg_en.js"></script>
        <script type="text/javascript" src="../grid/gt_grid_all.js"></script>


        <script type="text/javascript" >


            var dsConfig = {
                uniqueField: 'no',
                fields: [
                    {name: 'no', type: 'int'},
                    {name: 'name'},
                    {name: 'age', type: 'int'},
                    {name: 'gender'},
                    {name: 'english', type: 'float'},
                    {name: 'math', type: 'float'},
                    {name: 'total', type: 'float',
                        initValue: function (record) {
                            return record['english'] + record['math'];
                        }
                    }
                ]
            };

            var colsConfig = [
                {id: 'no', header: "No", width: 50, editable: false},
                {id: 'name', header: "Name", width: 100, editable: false,
                    renderer: function (value, record, columnObj, grid, colNo, rowNo) {
                        return '<a target=blank href="http://www.' + value + '.com">' + value + '</a>';
                    }
                },
                {id: 'age', header: "Age", width: 50, editable: false},
                {id: 'gender', header: "Country", width: 50,
                    renderer: function (value, record, columnObj, grid, colNo, rowNo) {
                        return '<img bodrer="0" src="./images/flag_' + value + '.gif" />';
                    }
                },
                {id: 'english', header: "2007", width: 60, align: 'right'},
                {id: 'math', header: "2008", width: 60, align: 'right'},
                {id: 'total', header: "Total", width: 70, align: 'right',
                    renderer: function (value, record, columnObj, grid, colNo, rowNo) {
                        var total = record['total'];
                        if (total > 170) {
                            total = '<span style="color:red" >' + total + '</span>';
                        } else if (total < 120) {
                            total = '<span style="color:blue" >' + total + '</span>';
                        }
                        return total;
                    }
                },
                {id: 'detail', header: "More", width: 120,
                    renderer: function (value, record, columnObj, grid, colNo, rowNo) {
                        return '<img bodrer="0" src="./images/testImg.gif" width="16" height="16" />';
                    }
                }
            ];

            var gridConfig = {
                id: "grid1",
                loadURL: './export_php/testList.php',
                exportURL: './export_php/testList.php?export=true',
                exportFileName: 'test_export_doc',
                dataset: dsConfig,
                columns: colsConfig,
                container: 'grid1_container',
                toolbarPosition: 'bottom',
                toolbarContent: 'xls',
                beforeSave: function (reqParam) {
                    //alert(Sigma.toJSONString(reqParam) ) ;
                    //Sigma.$grid('grid1').reload(true);
                    //return false;
                },
                showGridMenu: true,
                allowCustomSkin: true,
                allowFreeze: true,
                allowGroup: true,
                allowHide: true,
                pageSize: 10,
                pageSizeList: [5, 10, 15, 20],
                remotePaging: false,
                autoLoad: false

            };

            var mygrid = new Sigma.Grid(gridConfig);

            Sigma.Utils.onLoad(function () {

                mygrid.render();
                mygrid.reload();
            });


        </script>
    </head>
    <body>

        <div id="bigbox" style="margin:15px"> <!--display:!none;-->
            <div id="grid1_container" style="border:0px solid #cccccc;background-color:#f3f3f3;padding:5px;height:200px;width:700px;" ></div>
        </div>

        <script type="text/javascript">
            jssc.colorAll("code");
        </script>
    </body>
</html>
