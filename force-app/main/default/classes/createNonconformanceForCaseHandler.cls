public class createNonconformanceForCaseHandler {
    public static void createNonConferenceForCase(List<Case> Cases) {
		// fetching loggedin user Id
        String userId = UserInfo.getUserId();
        
        // getting the permission set name from custom label
        String CaseAdminPermissionSet = system.Label.CQ_CaseAdminPermission;
        
        // Get the permissionset
        List<PermissionSet> CaseAdminPermission = [SELECT Id, Label,Name FROM PermissionSet Where label =: CaseAdminPermissionSet];
        string permissionSetName;
        if(!CaseAdminPermission.isEmpty()){
            permissionSetName = CaseAdminPermission[0].Name;
        }
        
        // list of permission set assignments for the logged in user
        List<PermissionSetAssignment> userperm = [SELECT Id, PermissionSetId, PermissionSet.Name, PermissionSet.ProfileId, PermissionSet.Profile.Name, AssigneeId, Assignee.Name FROM PermissionSetAssignment WHERE AssigneeId =: userId  AND PermissionSet.Name =: permissionSetName];
        
        Set<String> ExistingPermSet = new Set<String>();
        for(PermissionSetAssignment PS :userperm ){
            ExistingPermSet.add(PS.PermissionSet.Name);
        }
        
        // Creating NonConference record only is the logged in user has Case Admin Permissionset
        if(ExistingPermSet.contains(permissionSetName)){
            List<SQX_Nonconformance__c> nonConerenceRecordList = new List<SQX_Nonconformance__c>();
            for(Case caseRec : Cases){
                SQX_Nonconformance__c nonConerenceRecord = new SQX_Nonconformance__c();
                if(caseRec.Type == 'Problem' && caseRec.SQX_NC_Reference__c == null){
                    nonConerenceRecord.Priority__c = caseRec.Priority;
                    nonConerenceRecord.Title__c = caseRec.Subject;
                    nonConerenceRecord.Description__c = caseRec.Description;
                    nonConerenceRecord.QMS_Reference_Number__c = caseRec.CaseNumber;
                    nonConerenceRecordList.add(nonConerenceRecord);
                }
            }
            
            if(!nonConerenceRecordList.isEmpty()){
                insert nonConerenceRecordList;
            }
            
            map<String,String> caseNonConMap = new map<String,String>();
            
            if(!nonConerenceRecordList.isEmpty()){
                for(SQX_Nonconformance__c nonCon : nonConerenceRecordList){
                    caseNonConMap.put(nonCon.QMS_Reference_Number__c , nonCon.Id);
                }
                
                List<Case> newCaseRecordList = new List<Case>();
                for(Case caseRec : Cases){
                    Case caseRecord = new Case();
                    caseRecord.Id = caseRec.Id;
                    caseRecord.SQX_NC_Reference__c = caseNonConMap.get(caseRec.CaseNumber);
                    newCaseRecordList.add(caseRecord);
                }
                
                if(!newCaseRecordList.isEmpty()){ 
                    update newCaseRecordList;
                }
            }
            
        }
    }
    
}