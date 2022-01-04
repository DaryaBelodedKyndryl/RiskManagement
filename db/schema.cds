namespace riskmanagement;

using {managed} from '@sap/cds/common';

// Use managed, to add four elements to capture created by/at and latest modified by/at management information for records.
entity Risks : managed {
    key ID          : UUID @(Core.Computed : true); // =@readonly
        title       : String(100);
        owner       : String;
        prio        : String(5);
        descr       : String;
        miti        : Association to Mitigations; // navigation property title. Transform to property miti_ID (NavProp_Key)
        impact      : Integer;
        bp          : Association to BusinessPartners;
        criticality : Integer;
}

entity Mitigations : managed {
    key ID      : UUID @(Core.Computed : true); // =@readonly
        descr   : String;
        owner   : String;
        timeine : String;
        risks   : Association to many Risks
                      on risks.miti = $self; // navigation property title
}

// using external service from S/4
// API_BUSINESS_PARTNER - namespace
using {API_BUSINESS_PARTNER as external} from '../srv/external/API_BUSINESS_PARTNER.csn';

entity BusinessPartners as projection on external.A_BusinessPartner {
    key BusinessPartner, LastName, FirstName
}
