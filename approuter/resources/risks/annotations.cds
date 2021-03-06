// defines content of List Report / Object Page
using RiskService as service from '../../srv/risk-service';

// Risks List Report
annotate service.Risks with @(UI : {
    HeaderInfo      : {
        $Type          : 'UI.HeaderInfoType',
        TypeName       : 'Risk',
        TypeNamePlural : 'Risks',
        Title          : {
            $Type : 'UI.DataField',
            Value : title,
        },
        Description    : {
            $Type : 'UI.DataField',
            Value : descr,
        },
    },
    SelectionFields : [prio],
    Identification  : [{Value : title}],
    LineItem        : [
        {Value : title, },
        {Value : miti_ID},
        {Value : owner},
        {Value : bp_BusinessPartner},
        {
            Value       : prio,
            Criticality : criticality
        },
        {
            Value       : impact,
            Criticality : criticality
        }
    ],
});

// Risks Object Page
annotate service.Risks with @(UI : {
    Facets           : [{
        $Type  : 'UI.ReferenceFacet',
        Label  : 'Main',
        Target : '@UI.FieldGroup#Main',
    }],
    FieldGroup #Main : {
        $Type : 'UI.FieldGroupType',
        Data  : [
            {Value : miti_ID},
            {Value : owner},
            {Value : bp_BusinessPartner},
            {
                Value       : prio,
                Criticality : criticality
            },
            {
                Value       : impact,
                Criticality : criticality
            }
        ],
    },
});
