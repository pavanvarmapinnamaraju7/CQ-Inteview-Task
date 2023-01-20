trigger CreateNonconformanceForCase on Case (after insert,after update) {
    if (trigger.isAfter) {
        if (trigger.isInsert || trigger.isUpdate) {
            createNonconformanceForCaseHandler.createNonConferenceForCase(trigger.new);
        }
    }
}