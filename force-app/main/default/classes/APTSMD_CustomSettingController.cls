/*
 *Author: Mayur Soni
 *Date: 10-Dec-2015  
 *Purpose: This class is used to fetch custom fields of all the custom settings available in the org. 
********************************************************************************************
 *Author: Jigar Naik
 *Date: 06-Apr-2017  
 *Change: Refactored the code and added functionality to display custom setting values also. 
********************************************************************************************
 *Author: Jeetu Agrawal
 *Date: 13-Dec-2018  
 *Change: Migrate.
********************************************************************************************
*/
public class APTSMD_CustomSettingController{
    public Map<String,List<LabelName>> csNameVsFieldsMap;
    public Map<String,String> csNameVsValueTitleMap;
    public Map<String,String> csNameVsURLMap;
    public String csNameVsValueTitleJSON{
        get{
            return JSON.serialize(csNameVsValueTitleMap);
        }set;
    }
    public String csNameVsURLJSON{
        get{
            return JSON.serialize(csNameVsURLMap);
        }set;
    }
    public String customSettingData{
        get{
            return JSON.serialize(csNameVsFieldsMap);
        }set;
    }
    
    public APTSMD_CustomSettingController(){
        Integer loopCount = 0;
        Map<String,Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        List<Schema.SObjectType> sobjects = schemaMap.values();
        Schema.DescribeSObjectResult objDescribe;
        List<Schema.SObjectType> customSettings = new List<Schema.SObjectType>();
        for(Schema.SObjectType objType : sobjects)
        {
            objDescribe = objType.getDescribe();
            if(objDescribe.isCustomSetting()){
                customSettings.add(objType);
            }
        }

        csNameVsFieldsMap = new Map<String,List<LabelName>>();
        csNameVsValueTitleMap = new Map<String,String>();
        csNameVsURLMap = new Map<String,String>();
        
        for(Schema.SObjectType objType : customSettings)
        {   
            objDescribe = objType.getDescribe();
            String name,prefix;
            
            prefix = objDescribe.getKeyPrefix();
            
            name = objDescribe.getLabel() + ' (' +objDescribe.getName() + ')';
            
            String soqlQuery = getAllFieldsSOQL(objDescribe.getName());
            List<sObject> queryResult = (List<sObject>)Database.query(soqlQuery);//SOQL in loop is written only due to the unavailability of relevant metadata API.
            sObject sObjectToDisplay = null;
            csNameVsValueTitleMap.put(name, '');
            csNameVsURLMap.put(name, '/setup/ui/listCustomSettingsData.apexp?id=' + prefix);
            
            if(queryResult != null && queryResult.size() >= 1){
                sObjectToDisplay = queryResult[0];
                csNameVsValueTitleMap.put(name, 'Field Value');
                csNameVsURLMap.put(name, '/setup/ui/viewCustomSettingsData.apexp?setupid=CustomSettings&id=' + sObjectToDisplay.Id);
            }
            
            List<LabelName> fields = getFieldMetaData(objDescribe, sObjectToDisplay);
            csNameVsFieldsMap.put(name,fields);
            
            loopCount++;
            if(loopCount == 100){
                break;
            }
        }
    }
    
    private List<LabelName> getFieldMetaData(Schema.DescribeSObjectResult dsor, sObject csRecord){
        List<LabelName> returnList = new List<LabelName>();
        // map of all fields in the object
        Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
    
        // iterate over the requested fields and get the describe info for each one. 
        // add it to a map with field name as key
        for(String field : objectFields.keySet()){
            Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
            // add the results to the map to be returned
            if(dr.isCustom()){
                if(csRecord == null){
                    returnList.add(new LabelName(dr.getLabel(),dr.getName(),null));
                }else{
                    returnList.add(new LabelName(dr.getLabel(),dr.getName(),csRecord.get(dr.getName())));
                }
            }
        }
        return returnList;
    }
    
    private String getAllFieldsSOQL(String objectName){
         
        String selects = '';
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                    selectFields.add(fd.getName());
            }
        }
         
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}
             
        }
         
        return 'SELECT ' + selects + ' FROM ' + objectName;
         
    }
    
    public class LabelName{
        public String label;
        public String name;
        public Object value;
        
        public LabelName(String label,String name, Object value){
            this.label = label;
            this.name = name;
            this.value = value;
        }
        
    }
}