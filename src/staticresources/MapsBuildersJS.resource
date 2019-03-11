function(skuid) {
// Cache some local variables to optimize minification
   var $ = skuid.$;
   skuid.builder.registerBuilder(new skuid.builder.Builder({
       id : 'awesomemap',
       name : 'Awesome Map',
       icon : 'ui-silk-map',
       description : 'Draws a Map based on latitude and longitude information in the data of any Object.',
       componentRenderer: function(component) {
           var self = component;
           component.header.html(component.builder.name);
       },
       propertiesRenderer : function (propertiesObj,component) {
           propertiesObj.setHeaderText('Map Properties');
               var propsList = [
                   {
                       id : 'model'
                       ,type : 'model'
                       ,label : 'Model'
                       ,required : true
                       ,onChange : function(value) {
                       }
                   }
                   ,{
                       id : 'latitudefield'
                       ,type : 'field'
                       ,modelprop : 'model'
                       ,label : 'Latitude Field'
                       ,helptext : 'The field on the selected Model which stores a row\'s Latitude'
                   }
                   ,{
                       id : 'longitudefield'
                       ,type : 'field'
                       ,modelprop : 'model'
                       ,label : 'Longitude Field'
                       ,helptext : 'The field on the selected Model which stores a row\'s Longitude'
                   }
                   ,{
                       id : 'pincolor'
                       ,type : 'string'
                       ,label : 'Pin Color'
                       ,helptext : '24 bit color, or one of the following: black, brown, green, purple, yellow, blue, gray, orange, red, white'
                   }
               ];
               var propsEditor = skuid.builder.buildPropsEditor(component.state,propsList);
                   propertiesObj.body.append(propsEditor);
       },
      defaultStateGenerator : function() {
           return skuid.utils.makeXMLDoc('<awesomemap pincolor="green"/>');
       }
   }));
})(skuid);