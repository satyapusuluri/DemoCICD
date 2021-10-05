public with sharing class APTSMD_createRemoteSiteEndpoint {

    public void createRemoteSiteSetting(String ServerUrl){
        MetadataService.MetadataPort service = createService();
        MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
        remoteSiteSettings.fullName = 'CSOrgAccess' + Math.round(Math.random()*1000);
        remoteSiteSettings.url = ServerUrl;
        remoteSiteSettings.isActive = true;
        remoteSiteSettings.disableProtocolSecurity = false;
        MetadataService.SaveResult[] results = service.createMetadata(new List<MetadataService.Metadata> { remoteSiteSettings });
    }
    
    public MetadataService.MetadataPort createService() {
        MetadataService.MetadataPort service1 = new MetadataService.MetadataPort();
        service1.SessionHeader = new MetadataService.SessionHeader_element();
        service1.SessionHeader.sessionId = UserInfo.getSessionId();
        return service1;
    }

}