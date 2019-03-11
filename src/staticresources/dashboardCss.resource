
.bodyDiv{
   overflow-x:hidden;
    margin-top: 30px;
    box-shadow: 1px 2px 13px 20px #eee;
    padding: 2%;
    font-family:sans-serif;
}

.formTags,.tagnames{
    margin:0;
    color: #032559;
    font-size:10pt;
    float: left;
    text-align: left;
}
.tagValues{
    margin:0;
    color: #032559;
    font-size:10pt;
    float: left;
    text-align: left;
    padding-left:1%;
}
.tagNames{
    font-size:10pt;
}

.header h2{
    color:rgb(0,176,240);
    margin: 0px 0px 10px 0px;
}

.subHeader{
    color: #fff;
    background:rgb(0,176,240);
    margin: 0;
    padding-top: 5px;
    padding-left: 8px;
    padding-bottom: 5px;
    border-radius: 4px;
}

.row{
    width: 47%;
    float: left;
    padding: 4px 8px;
}

.formDiv {
    width: 100%;
    float: left;
    margin-bottom: 15px;
    padding-bottom: 15px;
}

.subHeaderOne, .subHeaderTwo{
    width:100%;
    flaot:left;
    min-height:25px;
}

.subHeaderOne > .subSubHeader, .floatLeft{
    float:left !important;
}

.subHeaderTwo > ..subSubHeader{
    float:left;
}

.subHeaderOne > .subSubHeader h4{
    margin: 13px 0 3px 0;
    padding: 7px 0;
    color: #fff;
    background:rgb(0,176,240);
    border-left: 1px solid #ccc;
    text-align:center;
}

.historyTable{
    float:left;
    width:100%;
    table-layout:fixed;
    border-collapse: collapse;
    background: #fff;
}
.rowsHistory th, .rowsHistory td{
    word-wrap: break-word;
    border: 1px solid #dddddd;
    padding: 4px 4px;
    font-size: 10pt;
}
.rowsHistory td{
    border: 1px solid #fff;;
    padding: 3px;
}
.rowsHistory th{
    color: #fff;
}
thead .rowsHistory th{
    background:rgb(0,176,240);
}

.rowsHistory{
    border-bottom:2px solid #fff;
}

tbody{
    background:#dcd9d9;;
}

.arrow{
    text-align:right;
    float:right;
    color:#06946e
}

i {
    border: 1px solid #06946e;
    border-width: 0 3px 3px 0;
    display: inline-block;
    padding: 3px;
    position: relative;
    top: 4px;
    cursor:pointer;
}

.right {
    transform: rotate(-45deg);
    -webkit-transform: rotate(-45deg);
}

.left {
    transform: rotate(135deg);
    -webkit-transform: rotate(135deg);
}

.up {
    transform: rotate(-135deg);
    -webkit-transform: rotate(-135deg);
}

.down {
    transform: rotate(45deg);
    -webkit-transform: rotate(45deg);
}

.leftDiv{
    width:32%;
    float:left;
}
.rightDiv{
    width:67%;
    float:right;
}
.textareaBox{
    resize: none;
    float: left;
    height: 50px;
    width: 99%;
    border: 1px solid #000;
}
.escButtons{
    padding: 5px;
    color: #fff;
    background: #8c8585;
    border: none;
    border: 1px solid #8c8585;
    position: relative;
    min-width: 150px;
    font-weight: bold;
    cursor: pointer;
    margin: 8px;
    border-radius: 6px;
}

.loadingBackground{
    position: fixed;
    height: 100%;
    width: 100%;
    background: #444343;;
    z-index: 111111;
    opacity: 0.7;
    top: 0px;
    left:0;
    bottom:0;
    right:0;
}

.exposureSectionPopup{
    width: 50%;
    margin: auto;
    height: 400px;
    background: #f6f6f6;
    left: 25%;
    z-index: 111111111111;
    top: 20%;
    position: fixed;
    box-shadow: 2px 1px 16px 0px #000;
    border-radius: 5px;
}
.higRow{
    color:red;
}
.wrapper-dropdown-1 {
    position: relative;
    width: 318px;
    padding: 10px;
    margin: 0 auto;
    background: #087383;
    color: #fff;
    outline: none;
    cursor: pointer;
    font-weight: bold;
    float:right;
}
.wrapper-dropdown-1.active {
    background: #087383;
    background: -moz-linear-gradient(left, #087383 0%, #9bc7de 78%, #ffffff 78%, #ffffff 100%);
    background: -webkit-gradient(linear, left top, right top, color-stop(0%,#087383), color-stop(78%,#087383), color-stop(78%,#ffffff), color-stop(100%,#ffffff));
    background: -webkit-linear-gradient(left, #087383 0%,#087383 78%,#ffffff 78%,#ffffff 100%);
    background: -o-linear-gradient(left, #087383 0%,#087383 78%,#ffffff 78%,#ffffff 100%);
    background: -ms-linear-gradient(left,#087383 0%,#087383 78%,#ffffff 78%,#ffffff 100%);
    background: linear-gradient(to right,#087383 0%,#08738378%,#ffffff 78%,#ffffff 100%);
    filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#9bc7de', endColorstr='#ffffff',GradientType=1 );
}
.wrapper-dropdown-1 .dropdown {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: #fff;
    color:#000;
    list-style: none;
    font-weight: normal;
    opacity: 0;
    pointer-events: none;
    margin: 0px;
}
.wrapper-dropdown-1 .dropdown li a{
    color: #000;
    text-decoration:none;
    padding:5px 0px;
    display:block;
}
.wrapper-dropdown-1.active .dropdown {
    opacity: 1;
    pointer-events: auto;
}
.wrapper-dropdown-1.active .dropdown {
    opacity: 1;
    pointer-events: auto;
}
.wrapper-dropdown-1.active:after {
    border-color: #087383 transparent;
    border-width: 6px 6px 0 6px;
    margin-top: -3px;
}

.wrapper-dropdown-1:after {
    content: "";
    width: 0;
    height: 0;
    position: absolute;
    right: 16px;
    top: 50%;
    margin-top: -6px;
    border-width: 6px 0 6px 6px;
    border-style: solid;
    border-color: transparent #fff;
}
.dynamicTable{
     position: relative;
  	min-width: 1200px;
  	overflow: hidden;
  
}
.dynamicTable tbody{
    
    position: relative;
 	display: block; /*seperates the tbody from the header*/
  	overflow: scroll;
    width: 1200px;
    margin-right:5%;
}
.dynamicTable tr td:nth-child(1) {  /*the first cell in each tr*/
  position: relative;
  display: block; /*seperates the first column from the tbody*/
  background:rgb(0,176,240);
  color:#fff;  
  
}


.redFont{
    color:#FF0000;
}
.dynamicTable td:not(:first-child){
    min-width:499px;
    padding-top:8px;
    font-size:9pt;
    border-bottom:1px solid #087383;
}
.dynamicTable td:first-child{
    min-width:250px;
    
}
.borderTable td{
    border-right:1px solid #000;
}
.whiteBorder td{
    border-right:1px solid #fff;
}
.prList{
    padding: 0px;
    list-style-type: none;
}
.displayNone{
    display:none;
}
.displayBlock{
    display:block;
}
.selectround {

  /* styling */
  background-color: #ddd;
  border: thin solid blue;
  border-radius: 4px;
  display: inline-block;
  font: inherit;
  line-height: 1.5em;
  padding: 0.5em 0em 0.5em 1em;
  border:none;	
  /* reset */

  margin: 0;      
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  -webkit-appearance: none;
  -moz-appearance: none;
    color:red;
}
.selectround {
  background-image:
    linear-gradient(45deg, transparent 50%, #06946e 50%),
    linear-gradient(135deg, #06946e 50%, transparent 50%),
    radial-gradient(#ddd 70%, transparent 72%);
  background-position:
    calc(100% - 20px) calc(1em + 2px),
    calc(100% - 15px) calc(1em + 2px),
    calc(100% - .5em) 0em;
  background-size:   5px 5px, 5px 5px,
    1.5em 1.5em;
  background-repeat: no-repeat;
}
.selectround:focus {outline:0;}
.escButtons:disabled{
        color: #72716B;
        cursor: not-allowed;
}
.tooltip {
    display: inline;
    position: relative;
}
.tooTipImg {
    height: 20px;    
    position: relative;
    top: 5px;
}
 
td span{
    display:inline-block;
}

ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    overflow: hidden;
 
}

li {
    width:24%;
    
    float: left;
}
ul li:last-child,.floatRight{
    float:right;
}
.bgFinance{
    width:24%;
    margin: 1px 4px;
}
.nonBgFInance{
    width:70%;
    margin:2px;
}
.borderSpan  td span{
    //border-right: 1px solid #000;
}
.borderSpan  td span:last-child{
    border-right: none;
}
.bigTextArea{
    height:60px;
    width:100%;
}
fieldSet{
    margin: 0px;
    padding: 0px;
    border: 0px;
    min-width: 100%;
}
.textAlignRight{
    text-align: right;
}
.previous {
    background-color:rgb(0,176,240);
    color: #fff;
     text-decoration: none;
    display: inline-block;
    padding: 4px 17px;
    font-size:1em;
     border-radius:4px;
    margin-bottom:4px;
}
.tooltip {
    display: inline;
    position: relative;
    border-right:0px !important;
    float:left;
}

    .tooltip:hover:after {
        background: rgb(0,176,240);
        border-radius: 5px;
        bottom: 26px;
        color: #fff;
        content: attr(help);
        left: -100%;
        padding: 5px 5px;
        position: absolute;
        z-index: 9999999999999999;
        width: 150px;
        font-size: 12px;
        line-height: 18px;
    	text-align:left !important;
    	display:inline-block;
    }

    .tooltip:hover:before {
        border: solid;
        border-color:rgb(107, 196, 213) transparent;
        border-width: 6px 6px 0 6px;
        bottom: 20px;
        content: "";
        left: 35%;
        position: absolute;
        z-index: 999999;
    }

.tooTipImg {
    height: 15px;
    
    
}
.minnWidth{
    width:20%;
}

.maxxWidth{
    width:60%;
}

.minWidth{
    width:10%;
}
.maxWidth{
    width:29.7%;
}
.greenFont{
    color:#06946e;
}